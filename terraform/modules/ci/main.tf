# ---------- Workload Identity Federation ----------
# GitHub Actions signs a short-lived OIDC token for every job. GCP trusts that
# token instead of a service account key: there is no secret to leak or rotate.

resource "google_iam_workload_identity_pool" "github" {
  project                   = var.project_id
  workload_identity_pool_id = "github"
  display_name              = "GitHub Actions"
  description               = "Identities issued by GitHub Actions"
}

resource "google_iam_workload_identity_pool_provider" "github" {
  project                            = var.project_id
  workload_identity_pool_id          = google_iam_workload_identity_pool.github.workload_identity_pool_id
  workload_identity_pool_provider_id = "github-actions"
  display_name                       = "GitHub Actions OIDC"

  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }

  # Claims of the GitHub token copied into attributes usable by IAM.
  attribute_mapping = {
    "google.subject"       = "assertion.sub"
    "attribute.repository" = "assertion.repository"
    "attribute.ref"        = "assertion.ref"
  }

  # Every GitHub repository can obtain a token from the same issuer:
  # without this condition, any repository in the world could knock on the door.
  attribute_condition = "assertion.repository == '${var.github_repository}'"
}

# ---------- Identities ----------
# Two identities, two blast radii: pull requests only read, and only the
# protected GitHub environment can change the infrastructure.

resource "google_service_account" "plan" {
  account_id   = "ci-terraform-plan"
  project      = var.project_id
  display_name = "CI Terraform plan"
  description  = "Read-only identity running terraform plan on pull requests"
}

resource "google_service_account" "apply" {
  account_id   = "ci-terraform-apply"
  project      = var.project_id
  display_name = "CI Terraform apply"
  description  = "Identity running terraform apply from the protected environment"
}

# Any workflow of the repository may borrow the plan identity.
resource "google_service_account_iam_member" "plan_wif" {
  service_account_id = google_service_account.plan.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github.name}/attribute.repository/${var.github_repository}"
}

# Only jobs declaring the protected environment may borrow the apply identity:
# GitHub then sets the token subject to repo:<owner/name>:environment:<env>.
resource "google_service_account_iam_member" "apply_wif" {
  service_account_id = google_service_account.apply.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principal://iam.googleapis.com/${google_iam_workload_identity_pool.github.name}/subject/repo:${var.github_repository}:environment:${var.apply_environment}"
}

# ---------- Project permissions ----------

resource "google_project_iam_member" "plan" {
  for_each = toset([
    "roles/viewer",
    "roles/iam.securityReviewer",
  ])

  project = var.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.plan.email}"
}

# Exactly what the platform, prod and staging roots create, nothing more.
resource "google_project_iam_member" "apply" {
  for_each = toset([
    "roles/serviceusage.serviceUsageAdmin",
    "roles/compute.networkAdmin",
    "roles/compute.securityAdmin",
    "roles/compute.instanceAdmin.v1",
    "roles/container.admin",
    "roles/iam.serviceAccountAdmin",
    "roles/iam.serviceAccountUser",
    "roles/resourcemanager.projectIamAdmin",
    "roles/storage.admin",
    "roles/bigquery.dataOwner",
    "roles/secretmanager.admin",
  ])

  project = var.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.apply.email}"
}

# ---------- Terraform state ----------
# Plan reads the state without locking it; apply locks and writes it.

resource "google_storage_bucket_iam_member" "state_plan" {
  bucket = var.state_bucket
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.plan.email}"
}

resource "google_storage_bucket_iam_member" "state_apply" {
  bucket = var.state_bucket
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.apply.email}"
}
