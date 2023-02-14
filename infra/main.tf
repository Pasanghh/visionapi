provider "google" {
#  credentials = file("/path/to/credentials.json")
  project     = var.project
  region      = var.region
}

# Create a bucket for image storage
resource "google_storage_bucket" "screenshots_bucket" {
  name          = var.bucket
  location      = var.region
  force_destroy = true

  uniform_bucket_level_access = true
}

# Create service account for the bucket
resource "google_service_account" "bucket_sa" {
  account_id   = "${google_storage_bucket.screenshots_bucket.id}"
  display_name = "bucket sa"
}

# Bind visionai editior to service account
resource "google_project_iam_binding" "vision_api" {
  project = var.project
  role = "roles/visionai.editor"
  members = [
    "serviceAccount:${google_storage_bucket.screenshots_bucket.name}@pngocr-377813.iam.gserviceaccount.com",
  ]
}

# Create a Cloud Vision API service account
resource "google_service_account" "vision_api_sa" {
  account_id   = "vision-service-account"
  display_name = "Cloud Vision API Service Account"
}

# Grant the Cloud Vision API service account access to the bucket
resource "google_storage_bucket_iam_member" "bucket_iam" {
  bucket = google_storage_bucket.bucket.name
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.vision_api_sa.email}"
}

# Enable the Cloud Vision API for the project
resource "google_project_service" "vision_api" {
  service = "vision.googleapis.com"
}

# Create a Cloud Vision API API key
resource "google_service_account_key" "vision_api_key" {
  service_account_id = google_service_account.vision_api_sa.name
  private_key_type   = "TYPE_GOOGLE_CREDENTIALS_FILE"
}

# Output the API key as a file
output "vision_api_key" {
  value       = google_service_account_key.vision_api_key.private_key
  description = "Cloud Vision API API key"
}

