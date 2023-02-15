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
    TRANSLATE_TOPIC = google_pubsub_topic.translate_topic.name
    RESULT_TOPIC    = google_pubsub_topic.result_topic.name
    TO_LANG         = "es,en,fr,ja"
  }
}

# Create text translate function 
resource "google_cloudfunctions_function" "translate_function" {
  name        = var.translate_function
  description = "Function used to translate text from images"
  runtime     = var.function_runtime

  event_trigger {
    event_type = "google_pubsub_topic.result_topic.publish"
    resource = google_pubsub_topic.result_topic.name
  }
  
  available_memory_mb   = 256
  timeout               = 60
  entry_point           = "Translate Text"

  environment_variables = {
    RESULT_TOPIC    = google_pubsub_topic.result_topic.name
  }
}

# Create save text function 
resource "google_cloudfunctions_function" "save_function" {
  name        = var.save_function
  description = "Function used to save text into GCS bucket"
  runtime     = var.function_runtime

  event_trigger {
    event_type = "google_pubsub_topic.translate_topic.publish"
    resource = google_pubsub_topic.translate_topic.name
  }
  
  available_memory_mb   = 256
  timeout               = 60
  entry_point           = "Save Text"

  environment_variables = {
    result_text_bucket = google_storage_bucket.result_text_bucket.name
  }
}