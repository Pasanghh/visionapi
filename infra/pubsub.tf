# Create the Pub/Sub translate topic
resource "google_pubsub_topic" "translate_topic" {
  name = var.translate_topic
  project = var.project
}

# Create the Pub/Sub result topic
resource "google_pubsub_topic" "result_topic" {
  name = var.result_topic
  project = var.project
}