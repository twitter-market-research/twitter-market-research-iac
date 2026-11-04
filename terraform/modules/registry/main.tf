
resource "google_artifact_registry_repository" "images" {
  for_each = var.writers

  repository_id = each.key
  project       = var.project_id
  location      = var.region
  format        = "DOCKER"
  description   = "Container images built by the ${each.key} repository"

  # A pushed tag can never be moved: what was tested is what runs
  docker_config {
    immutable_tags = true
  }

  # Keep the last 5 versions
  cleanup_policies {
    id     = "keep-recent-versions"
    action = "KEEP"

    most_recent_versions {
      keep_count = 5
    }
  }

  # Layers left behind by re-tagged builds pile up silently.
  cleanup_policies {
    id     = "delete-untagged"
    action = "DELETE"
    condition {
      tag_state  = "UNTAGGED"
      older_than = "604800s"
    }
  }

  labels = {
    project = "twitter-market-research"
  }
}

resource "google_artifact_registry_repository_iam_member" "writer" {
  for_each = var.writers

  project    = var.project_id
  location   = var.region
  repository = google_artifact_registry_repository.images[each.key].name
  role       = "roles/artifactregistry.writer"
  member     = "serviceAccount:${each.value}"
}
