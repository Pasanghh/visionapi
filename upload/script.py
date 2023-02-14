from google.cloud import storage
import os

# Set up Google Cloud credentials and project ID
os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = "/Users/e-pgsa/Desktop/pythonjson/pngocr-377813-0922f457cb4a.json"
project_id = "pngocr-377813"

client = storage.Client()
bucket = client.bucket('screenshots-bucket-3336')

directory = '/Users/e-pgsa/Desktop/sanatize'
# Iterate over the PNG files in the directory and upload each one
for filename in os.listdir(directory):
    if filename.endswith('.png'):
        filepath = os.path.join(directory, filename)
        blob = bucket.blob(filename)
        blob.upload_from_filename(filepath)
        print(f'Uploaded {filename} to {bucket.name}')