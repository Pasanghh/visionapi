import os
from google.cloud import storage

# Set up Google Cloud credentials and project ID
os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = "/path/to/credentials.json"
project_id = "your-project-id"

# Set up Google Cloud client objects
storage_client = storage.Client(project=project_id)

# Upload a PNG file to a Google Cloud Storage bucket
bucket_name = "your-bucket-name"
local_file_path = "/path/to/local/file.png"
remote_file_name = "remote_file_name.png"
bucket = storage_client.bucket(bucket_name)
blob = bucket.blob(remote_file_name)
blob.upload_from_filename(local_file_path)