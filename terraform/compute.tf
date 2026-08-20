locals {
  dwh_nodes = {
    "1" = {
      zone         = "europe-west1-b"
      machine_type = "e2-standard-2" # also hosts monitoring, collector and Spark
    }
    "2" = {
      zone         = "europe-west1-c"
      machine_type = "e2-medium"
    }
    "3" = {
      zone         = "europe-west1-d"
      machine_type = "e2-medium"
    }
  }
}

# configurate resources for each VM's instance
resource "google_compute_instance" "dwh" {
  for_each = local.dwh_nodes

  name         = "twitter-mr-dwh-${each.key}"
  machine_type = each.value.machine_type
  zone         = each.value.zone

  # ssh-iap  : reachable through the IAP tunnel
  # dwh-node : cluster member, allowed to talk to other members
  tags = ["ssh-iap", "dwh-node"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2404-lts-amd64"
      size  = 50
      type  = "pd-balanced"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.main.id
  }

  service_account {
    email  = google_service_account.dwh.email
    scopes = ["cloud-platform"]
  }

  metadata = {
    enable-oslogin = "TRUE"
  }

  shielded_instance_config {
    enable_secure_boot          = true
    enable_vtpm                 = true
    enable_integrity_monitoring = true
  }

  # Daily start/stop window.
  resource_policies = [google_compute_resource_policy.dwh_schedule.self_link]

  labels = {
    project = "twitter-market-research"
    role    = "dwh"
    node    = each.key
  }

  allow_stopping_for_update = true
}