# Create a bucket for image storage
resource "google_storage_bucket" "screenshots_bucket" {
  name          = var.image_bucket
  location      = var.region
  force_destroy = true

  uniform_bucket_level_access = true
}

# Create a bucket for result text storage
resource "google_storage_bucket" "result_text_bucket" {
  name          = var.text_bucket
  location      = var.region
  force_destroy = true

  uniform_bucket_level_access = true
}

# Create a bucket for python script storage
resource "google_storage_bucket" "function_bucket" {
  name          = var.function_bucket
  location      = var.region
  force_destroy = true

  uniform_bucket_level_access = true
}