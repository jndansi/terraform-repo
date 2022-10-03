terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.38.0"
    }
  }
}


provider "google" {
  project     = "ndansi-project"
  region      = "us-central1"
  zone        = "us-central1-a"
}


resource "google_compute_firewall" "default" {
  name    = "jason-firewall2"
  network = google_compute_network.default.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "8080", "1000-2000"]
  }

  source_tags = ["web"]
}

resource "google_compute_network" "default" {
  name = "test-network"
}

resource "google_service_account" "default" {
  account_id   = "ndansi-project"
  display_name = "Service Account"
}

resource "google_compute_instance" "default" {
  name         = "new-vm"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  tags = ["http-server", "https-server"  ]

  boot_disk {
    initialize_params {
      image = "centos-cloud/centos-7"
    }
  }

 

   network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }

  metadata = {
    enable-oslogin = "true"
  }

  

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.default.email
    scopes = ["cloud-platform"]
  }
}