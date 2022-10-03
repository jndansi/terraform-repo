resource "google_service_account" "default" {
  project      = "ndansi-project"
  account_id   = "terraform-sa"
  display_name = "terraform-sa"
}

resource "google_container_cluster" "primary" {
  project            = "ndansi-project" 
  name               = "gke-terraform"
  location           = "us-central1-a"
  initial_node_count = 3
  node_config {
    service_account = google_service_account.default.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    labels = {
      
    }
    tags = ["autoprovisioning-network-tags"]
  }
  timeouts {
    create = "30m"
    update = "40m"
  }
}