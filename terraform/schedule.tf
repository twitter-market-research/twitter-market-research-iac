resource "google_compute_resource_policy" "dwh_schedule" {
  name        = "dwh-daily-window"
  region      = var.region
  description = "Cluster running window: covers Ligue 1 kick-offs and work sessions"

  instance_schedule_policy {
    time_zone = "Europe/Paris"

    vm_start_schedule {
      schedule = "0 12 * * *"
    }

    vm_stop_schedule {
      schedule = "30 23 * * *"
    }
  }
}
