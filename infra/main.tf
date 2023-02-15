
# Create a Cloud Vision API service account
resource "google_service_account" "vision_api_sa" {
  account_id   = "vision-service-account"
  display_name = "Cloud Vision API Service Account"
}

# Grant the Cloud Vision API service account access to the image bucket
resource "google_storage_bucket_iam_member" "image_bucket_iam" {
  bucket = var.image_bucket
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
  sensitive = true
}

