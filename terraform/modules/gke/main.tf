resource "google_container_cluster" "main" {
  name     = "${var.name_prefix}-dwh"
  project  = var.project_id
  location = var.region # regional cluster  : control plane in 3 zones

  # we create oiur owns pools , versiones in the code
  remove_default_node_pool = true
  initial_node_count       = 1

  network    = var.network_id
  subnetwork = var.subnet_id

  networking_mode = "VPC_NATIVE"
  ip_allocation_policy {
    cluster_secondary_range_name  = var.pods_range_name
    services_secondary_range_name = var.services_range_name
  }

  private_cluster_config {
    enable_private_nodes    = true # aucune IP publique sur les nœuds
    enable_private_endpoint = true # plan de contrôle inaccessible depuis Internet
    master_ipv4_cidr_block  = var.master_ipv4_cidr_block
  }

  dynamic "master_authorized_networks_config" {
    for_each = [1]
    content {
      dynamic "cidr_blocks" {
        for_each = var.authorized_networks
        content {
          display_name = cidr_blocks.key
          cidr_block   = cidr_blocks.value
        }
      }
    }
  }

  # Dataplane V2: Native NetworkPolicies, essential for isolating
  # the staging and production namespaces sharing this cluster.
  datapath_provider = "ADVANCED_DATAPATH"

  # Les pods empruntent une identité GCP sans aucune clé.
  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  release_channel {
    channel = "REGULAR"
  }

  # Mises à jour de nœuds hors des créneaux de collecte.
  maintenance_policy {
    recurring_window {
      start_time = "2026-01-01T02:00:00Z"
      end_time   = "2026-01-01T06:00:00Z"
      recurrence = "FREQ=WEEKLY;BYDAY=TU,WE,TH"
    }
  }

  deletion_protection = true

  resource_labels = {
    project = "twitter-market-research"
  }
}
