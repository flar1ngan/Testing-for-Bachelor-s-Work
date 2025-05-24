provider "google" {
  project     = var.project_id
  region      = var.region
  credentials = file(var.credentials_file)
}

resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.zone

  remove_default_node_pool = true
  initial_node_count       = 1

  network    = "default"
  subnetwork = "default"

  release_channel {
    channel = "REGULAR"
  }

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  deletion_protection    = false
}

resource "google_container_node_pool" "primary_nodes" {
  name     = "default-pool"
  location = var.zone
  cluster  = google_container_cluster.primary.name

  autoscaling {
    min_node_count = 2
    max_node_count = 3
  }

  node_config {
    machine_type = "e2-standard-4"


    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    service_account = var.service_account_email
  }

  initial_node_count = 2
}