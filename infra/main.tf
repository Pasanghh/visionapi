provider "google" {
#  credentials = file("/path/to/credentials.json")
  project     = "pngocr-377813"
  region      = "europe-west2"
}

resource "google_storage_bucket" "screenshots_bucket" {
  name          = "screenshots-bucket-3336"
  location      = "europe-west2"
  force_destroy = true
}

resource "google_service_account" "bucket_sa" {
  account_id   = "${google_storage_bucket.screenshots_bucket.id}"
  display_name = "bucket sa"
}

resource "google_project_service" "vision_api" {
  service = "vision.googleapis.com"
}

resource "google_project_iam_binding" "vision_api" {
  project = "pngocr-377813"  
  role = "roles/visionai.editor"
  members = [
    "serviceAccount:${google_storage_bucket.screenshots_bucket.id}@cloudservices.gserviceaccount.com",
  ]
}