variable "project" {
  type        = string
  default     = "pngocr-377813"
  description = "GCP Project ID"
}

variable "region" {
  type        = string
  default     = "europe-west2"
  description = "GCP region"
}

variable "image_bucket" {
  type        = string
  default     = "screenshots-bucket-3336"
  description = "Bucket used to store images"
}

variable "text_bucket" {
  type        = string
  default     = "text-bucket-3336"
  description = "Bucket used to store txt files"
}

variable "function_bucket" {
  type        = string
  default     = "function-bucket-3336"
  description = "Bucket used to store the python fucntion script"
}

variable "image_function" {
  type        = string
  default     = "image-3336435"
  description = "Function used to detect text from images"
}

variable "translate_function" {
  type        = string
  default     = "translate-3336435"
  description = "Function used to translate text from images"
}

variable "save_function" {
  type        = string
  default     = "save-3336435"
  description = "Function used to save text to GCS bucket"
}
variable "function_runtime" {
  type        = string
  default     = "python39"
  description = "Runtime used in function"
}

variable "translate_topic" {
  type        = string
  default     = "translatetopic"
  description = "Pub/Sub topic used to trigger the translate function"
}

variable "result_topic" {
  type        = string
  default     = "resulttopic"
  description = "Pub/Sub topic used to trigger the save text function"
}