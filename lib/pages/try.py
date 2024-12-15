import requests
import pygame
import os

# Freesound API key
API_KEY = "KHkfShXAIwEJgFzclZlBfKAcyLI4fvrH6z8FvrZu"

# Freesound API endpoint for text search
url = "https://freesound.org/apiv2/search/text/"

# Request parameters
params = {
    "query": "dog",       # The search keyword
    "token": API_KEY,     # API token
    "fields": "name,url", # Optionl: Limits returned fields
}

# Make the API request
try:
    response = requests.get(url, params=params)
    response.raise_for_status()  # Raises HTTPError for bad responses

    # Parse the JSON response
    data = response.json()
    if "results" in data and data["results"]:
        # Get the URL of the first sound result
        sound_url = data["results"][0]["url"]
        print(f"Downloading and playing sound: {data['results'][0]['name']}")
        
        # Fetch the sound file
        sound_response = requests.get(sound_url)
        sound_response.raise_for_status()  # Check if the sound request was successful
        
        # Save the file locally
        sound_file_path = "downloaded_sound.wav"
        with open(sound_file_path, 'wb') as f:
            f.write(sound_response.content)

        # Initialize pygame mixer and load the sound from the file
        pygame.mixer.init()
        pygame.mixer.music.load(sound_file_path)
        pygame.mixer.music.play()
        
        # Keep the script running while the sound plays
        while pygame.mixer.music.get_busy():
            pygame.time.Clock().tick(10)
        
        # Optionally delete the file after playing
        os.remove(sound_file_path)
    else:
        print("No results found or response structure unexpected.")

except requests.exceptions.HTTPError as http_err:
    print(f"HTTP error occurred: {http_err}")
except requests.exceptions.RequestException as req_err:
    print(f"Request error occurred: {req_err}")
except ValueError as parse_err:
    print(f"JSON parse error: {parse_err}")
except Exception as e:
    print(f"An unexpected error occurred: {e}")
