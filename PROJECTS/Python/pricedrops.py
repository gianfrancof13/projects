from googleapiclient.discovery import build
import pandas as pd

api_key = 'AIzaSyBHjNHSy7hPNo0XhfFGUrPxvgufi2ktyrc'

api_service_name = "youtube"
api_version = "v3"

# Get credentials and create an API client
youtube = build(
api_service_name, api_version, develop=api_key)

request = youtube.channels().list(
part="snippet,contentDetalis,statistics",
id="UCrm__fZncRqD9FvjfytJ-CA"
)
response = request.execute()

print(response)