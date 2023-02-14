provider "google" {
#  credentials = file("/path/to/credentials.json")
  project     = "pngocr-377813"
  region      = "europe-west2"
}

resource "google_storage_bucket" "screenshots_bucket" {
  name          = "screenshots-bucket"
  location      = "europe-west2"
  force_destroy = true
}

resource "google_project_service" "vision_api" {
  service = "vision.googleapis.com"
}

resource "google_project_iam_binding" "vision_api" {
  role = "roles/cloudvision.googleapis.com/USER"
  members = [
    "serviceAccount:${google_storage_bucket.screenshots_bucket.project_number}@cloudservices.gserviceaccount.com",
  ]
}