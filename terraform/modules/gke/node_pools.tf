locals {
  node_pools = {
    prod = {
      node_count     = 1 # × 3 zones
      node_locations = null
      disk_size_gb   = 30
      taint          = true
    }
    staging = {
      node_count     = 1
      node_locations = ["europe-west1-b"] # une seule zone : pas de HA en staging
      disk_size_gb   = 30
      taint          = false
    }
  }
}


resource "google_container_node_pool" "main" {
  for_each = local.node_pools

  name     = "${var.name_prefix}-${each.key}"
  project  = var.project_id
  cluster  = google_container_cluster.main.id
  location = var.region # regional cluster

  # On a regional cluster, this number is PER ZONE.
    node_count     = each.value.node_count
    node_locations = each.value.node_locations

  node_config {
    machine_type = var.node_machine_type
    disk_size_gb = each.value.disk_size_gb

    disk_type    = "pd-balanced"

    service_account = var.node_service_account
    oauth_scopes    = ["https://www.googleapis.com/auth/cloud-platform"]

    workload_metadata_config {
      mode = "GKE_METADATA"
    }

    shielded_instance_config {
      enable_secure_boot          = true
      enable_integrity_monitoring = true
    }

    # The production pool only accepts workloads that explicitly tolerate
    # this taint: staging workloads cannot be scheduled there.
    dynamic "taint" {
      for_each = each.value.taint ? [1] : []
      content {
        key    = "environment"
        value  = "prod"
        effect = "NO_SCHEDULE"
      }
    }

    labels = {
      environment = each.key
    }
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  upgrade_settings {
    max_surge       = 1
    max_unavailable = 0 # never two nodes unavailable at the same time
  }

  lifecycle {
    # The nightly reset modifies node_count outside of Terraform.
    ignore_changes = [node_count]
  }
}
