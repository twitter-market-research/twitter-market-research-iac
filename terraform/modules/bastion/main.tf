variable "project_id" { type = string }
variable "zone"       { type = string }
variable "subnet_id"  { type = string }
variable "name_prefix" {
  type    = string
  default = "twitter-mr"
}

# Identité du bastion : volontairement vide de droits sur le cluster.
resource "google_service_account" "bastion" {
  account_id   = "bastion"
  project      = var.project_id
  display_name = "Bastion host service account"
  description  = "Network hop only, carries no cluster permission"
}

resource "google_compute_instance" "bastion" {
  name         = "${var.name_prefix}-bastion"
  project      = var.project_id
  machine_type = "e2-micro"
  zone         = var.zone

  tags = ["ssh-iap"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
      size  = 20
      type  = "pd-standard"
    }
  }

  network_interface {
    subnetwork = var.subnet_id
    # Pas d'access_config : pas d'IP publique.
  }

  service_account {
    email  = google_service_account.bastion.email
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
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
    role    = "bastion"
  }

  allow_stopping_for_update = true
}

output "bastion_name" {
  value = google_compute_instance.bastion.name
}
