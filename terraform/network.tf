

# -------- GCP APIs --------
# Activate the API
resource "google_project_service" "required" {
  for_each = toset([
    "compute.googleapis.com",
    "iap.googleapis.com",
    "secretmanager.googleapis.com",
    "storage.googleapis.com",
    "bigquery.googleapis.com",
  ])


  service = each.value

  # Never deactivate API even if we destroy the infra
  disable_on_destroy = false
}


# ------------- VPC ------------
resource "google_compute_network" "main" {
  name                    = "twitter-mr-vpc"
  auto_create_subnetworks = false
  description             = "VPC of twitter market research's platform"
  depends_on              = [google_project_service.required]
}

resource "google_compute_subnetwork" "main" {
  name          = "twitter-mr-subnet"
  network       = google_compute_network.main.id
  region        = var.region
  ip_cidr_range = "10.10.0.0/24"

  private_ip_google_access = true
}

# -------------- Internet Output without public IP --------
resource "google_compute_router" "main" {
  name    = "twitter-mr-master"
  network = google_compute_network.main.id
  region  = var.region
}

resource "google_compute_router_nat" "main" {
  name                               = "twitter-mr-nat"
  router                             = google_compute_router.main.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

# -------------- Firewalls -------------
resource "google_compute_firewall" "allow_iap_ssh" {
  name        = "allow-sh-from-iap"
  network     = google_compute_network.main.name
  description = "incoming SSH, only via IAP"
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  # Ip plage for Identity-Aware Proxy
  source_ranges = ["35.235.240.0/20"]
  target_tags   = ["ssh-iap"]
}

resource "google_compute_firewall" "allow_internal_cluster" {
  name        = "allow-internal-cluster"
  network     = google_compute_network.main.name
  description = "Kafka, ZooKeeper and metrics traffic between DWH nodes"

  allow {
    protocol = "tcp"
    ports = [
      "2181", # ZooKeeper client
      "2888", # ZooKeeper peer
      "3888", # ZooKeeper leader election
      "9092", # Kafka broker
      "9093", # Kafka inter-broker
      "9100", # node_exporter
      "7071", # JMX exporter
    ]
  }

  # Only machines tagged dwh-node may reach machines tagged dwh-node.
  source_tags = ["dwh-node"]
  target_tags = ["dwh-node"]
}









