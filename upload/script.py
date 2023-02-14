from google.cloud import storage
import os

# Set up Google Cloud credentials and project ID
project_id = "pngocr-377813"

client = storage.Client()
bucket = client.bucket(project_id)

directory = '/Users/e-pgsa/Desktop/sanatize'
# Iterate over the PNG files in the directory and upload each one
for filename in os.listdir(directory):
    if filename.endswith('.png'):
        filepath = os.path.join(directory, filename)
        blob = bucket.blob(filename)
        blob.upload_from_filename(filepath)
        print(f'Uploaded {filename} to {bucket.name}')