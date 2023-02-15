# Create image processing function 
resource "google_cloudfunctions_function" "image_function" {
  name        = var.image_function
  description = "Function used to detect text from images"
  runtime     = var.function_runtime

  event_trigger {
    event_type = "google.storage.object.finalize"
    resource   = google_storage_bucket.screenshots_bucket.self_link
  }

  available_memory_mb   = 256
  source_archive_bucket = google_storage_bucket.screenshots_bucket.id
  timeout               = 60
  entry_point           = "Image Processing"

  environment_variables = {
    TRANSLATE_TOPIC = "translatetopic"
    RESULT_TOPIC    = "resulttopic"
    TO_LANG         = "es,en,fr,ja"
  }
}

# IAM entry for a single user to invoke the function
resource "google_cloudfunctions_function_iam_member" "invoker" {
  project        = google_cloudfunctions_function.function.project
  region         = google_cloudfunctions_function.function.region
  cloud_function = google_cloudfunctions_function.function.name

  role   = "roles/cloudfunctions.invoker"
  member = "user:myFunctionInvoker@example.com"
}