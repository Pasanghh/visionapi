data "google_storage_project_service_account" "gcs_account" {
}

# To use GCS CloudEvent triggers, the GCS service account requires the Pub/Sub Publisher(roles/pubsub.publisher) IAM role in the specified project.
# (See https://cloud.google.com/eventarc/docs/run/quickstart-storage#before-you-begin)
resource "google_project_iam_member" "gcs-pubsub-publishing" {
  project = var.project
  role    = "roles/pubsub.publisher"
  member  = "serviceAccount:${data.google_storage_project_service_account.gcs_account.email_address}"
}

resource "google_service_account" "account" {
  account_id   = "gcf-sa"
  display_name = "Test Service Account - used for both the cloud function and eventarc trigger in the test"
}

# Permissions on the service account used by the function and Eventarc trigger
resource "google_project_iam_member" "invoking" {
  project    = var.project
  role       = "roles/run.invoker"
  member     = "serviceAccount:${google_service_account.account.email}"
  depends_on = [google_project_iam_member.gcs-pubsub-publishing]
}

# Create image processing function 
resource "google_cloudfunctions_function" "image_function" {
  name        = var.image_function
  description = "Function used to detect text from images"
  runtime     = var.function_runtime

  entry_point = "process_image"
  environment_variables = {
    GCP_PROJECT     = var.project
    TRANSLATE_TOPIC = google_pubsub_topic.translate_topic.name
    RESULT_TOPIC    = google_pubsub_topic.result_topic.name
    TO_LANG         = "es,en,fr,ja"
  }

  source_archive_bucket = var.function_bucket
  source_archive_object = "main.py"


  event_trigger {
    event_type = "google.storage.object.finalize"
    resource   = google_storage_bucket.screenshots_bucket.name
  }
}


# Create text translate function 
resource "google_cloudfunctions2_function" "translate_function" {
  name        = var.translate_function
  location    = var.region
  description = "Function used to translate text from images"

  event_trigger {
    event_type     = "google.cloud.pubsub.topic.v1.messagePublished"
    pubsub_topic   = google_pubsub_topic.result_topic.id
    trigger_region = var.region
    retry_policy   = "RETRY_POLICY_RETRY"
  }

  build_config {
    runtime     = var.function_runtime
    entry_point = "translate_text"
    environment_variables = {
      RESULT_TOPIC = google_pubsub_topic.result_topic.name
      GCP_PROJECT  = var.project
    }
    source {
      storage_source {
        bucket = var.function_bucket
        object = "main.py"
      }
    }
  }
}

# Create save text function 
resource "google_cloudfunctions2_function" "save_function" {
  name        = var.save_function
  location    = var.region
  description = "Function used to save text into GCS bucket"

  build_config {
    runtime     = var.function_runtime
    entry_point = "save_result"
    environment_variables = {
      RESULT_BUCKET = "${var.text_bucket}"
      GCP_PROJECT   = var.project
    }
    source {
      storage_source {
        bucket = var.function_bucket
        object = "main.py"
      }
    }
  }

  event_trigger {
    event_type     = "google.cloud.pubsub.topic.v1.messagePublished"
    pubsub_topic   = google_pubsub_topic.result_topic.id
    trigger_region = var.region
    retry_policy   = "RETRY_POLICY_RETRY"
  }

}

resource "google_storage_bucket_object" "app" {
  name   = "main.py"
  source = "/Users/e-pgsa/visionapi/upload/app/main.py"
  bucket = var.function_bucket
}

# # # Create a zip file containing the Cloud Function code
# # data "archive_file" "function_zip" {
# #   type = "zip"

# #   source_file = "/Users/e-pgsa/visionapi/upload/main.py"
# #   output_path = "function.zip"
# # }

# # # Upload the local file to the Cloud Storage bucket
# # resource "google_storage_bucket_object" "function_zip" {
# #   name   = "function.zip"
# #   bucket = google_storage_bucket.function_bucket.name

# #   source = data.archive_file.function_zip.output_path
# # }