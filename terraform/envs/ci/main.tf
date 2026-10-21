resource "google_project_service" "required" {
    for_each = toset(
        [
            "iam".googleapis.com",             # comptes de service, pools WIF
            "iamcredentials.googleapis.com",   # jetons temporaires des comptes de service
            "sts.googleapis.com",              # échange jeton Github -> jeton Google
            "cloudresourcemanager.googleapis.com", # reading and modify project IAM
        ]
    )

    service            = each_value
    disable_on_destroy = false
}

module "ci" {
    source = "../../modules/ci"

    project_id        = var.project_id
    github_repository = var.github_repository
    statte_bucket     = var.state_bucket

    depends_on = [google_project_service.required]
}
