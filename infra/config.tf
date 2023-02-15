provider "google" {
  project = var.project
  region  = var.region
}

terraform {
  backend "gcs" {
    bucket = "tf-backend-3336"
    prefix = "tf/state"
  }
}
