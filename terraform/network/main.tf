resource "google_compute_network" "main" {
  name                    = "${var.name_prefix}-vpc"
  project                 = var.project_id
  auto_create_subnetworks = false
  description             = "VPC of the Twitter Market Research platform"
}

resource "google_compute_subnetwork" "main" {
  name          = "${var.name_prefix}-subnet"
  project       = var.project_id
  network       = google_compute_network.main.id
  region        = var.region
  ip_cidr_range = var.subnet_cidr

  # Reach Google APIs without a public IP.
  private_ip_google_access = true

  # Required by GKE in VPC-native mode.
  secondary_ip_range {
    range_name    = "gke-pods"
    ip_cidr_range = var.pods_cidr
  }

  secondary_ip_range {
    range_name    = "gke-services"
    ip_cidr_range = var.services_cidr
  }
}

# ---------- Egress without public IPs ----------
resource "google_compute_router" "main" {
  name    = "${var.name_prefix}-router"
  project = var.project_id
  network = google_compute_network.main.id
  region  = var.region
}

resource "google_compute_router_nat" "main" {
  name                               = "${var.name_prefix}-nat"
  project                            = var.project_id
  router                             = google_compute_router.main.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

# ---------- Firewall ----------
resource "google_compute_firewall" "allow_iap_ssh" {
  name        = "${var.name_prefix}-allow-ssh-from-iap"
  project     = var.project_id
  network     = google_compute_network.main.name
  description = "Inbound SSH, through IAP only"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  # Reserved Identity-Aware Proxy range.
  source_ranges = ["35.235.240.0/20"]
  target_tags   = ["ssh-iap"]
}
