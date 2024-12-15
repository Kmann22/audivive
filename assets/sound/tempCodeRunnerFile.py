import numpy as np
import pyaudio
from pydub import AudioSegment

# Load the metronome sound (replace with the actual file path)
sound = AudioSegment.from_file("metronome.mp3")

# Function to apply basic panning (simulating spatialization)
def spatialize_sound(sound, pan, depth):
    # pan should be between -1 (left) and 1 (right)
    # depth should be between 0 (front) and 1 (back)

    # Convert the AudioSegment to raw audio data
    samples = np.array(sound.get_array_of_samples())
    
    # Calculate the number of channels
    num_channels = 2  # Stereo
    samples = samples.reshape((-1, num_channels))  # Make stereo audio

    # Apply panning and depth (attenuate for "behind")
    left = samples[:, 0] * (1 - abs(pan)) * (1 - depth)
    right = samples[:, 1] * (1 - abs(pan)) * (1 - depth)

    # Combine the left and right channels back together
    spatialized_samples = np.vstack([left, right]).T.flatten()
    
    # Convert the samples back to AudioSegment
    spatialized_sound = sound._spawn(spatialized_samples.astype(np.int16).tobytes())
    
    return spatialized_sound

# Function to play the sound using PyAudio
def play_sound(sound):
    # Set up the audio player
    p = pyaudio.PyAudio()
    stream = p.open(format=pyaudio.paInt16,
                    channels=2,
                    rate=sound.frame_rate,
                    output=True)
    
    # Convert the audio segment to bytes and play it
    stream.write(sound.raw_data)
    stream.stop_stream()
    stream.close()
    p.terminate()

# Apply spatialization and play sound with "behind" effect
def play_spatialized_metronome():
    # Pan sound slightly center and apply "behind" effect
    # Pan is 0 (center), depth is 1 (maximum depth, i.e., "behind")
    spatialized_sound = spatialize_sound(sound, pan=0, depth=1)
    play_sound(spatialized_sound)

# Run the spatialized metronome with "behind" effect
play_spatialized_metronome()
