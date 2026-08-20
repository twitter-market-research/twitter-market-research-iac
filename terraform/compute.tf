resource "google_compute_instance" "dwh" {
  name         = "twitter-mr-dwh"
  machine_type = var.machine_type
  zone         = var.zone

  # Make sure firewall rule will be applied to the VM
  tags = ["ssh-iap"]

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

  labels = {
    project = "twitter-market-research"
    role    = "dwh"
  }

  # Allow terraform to stop VM's instance for change the type
  allow_stopping_for_update = true
}