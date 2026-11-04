output "repository_urls" {
  description = "Registry name => URL to tag and push images"
  value = {
    for k, r in google_artifact_registry_repository.images :
    k => "${r.location}-docker.pkg.dev/${r.project}/${r.repository_id}"
  }
}
