import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class ReactionTimeGamePage extends StatefulWidget {
  const ReactionTimeGamePage({super.key});

  @override
  State<ReactionTimeGamePage> createState() => _ReactionTimeGamePageState();
}

class _ReactionTimeGamePageState extends State<ReactionTimeGamePage> {
  late AudioPlayer _audioPlayer;
  bool isPlaying = false;
  bool isPaused = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
  }

  // Function to play the audio
  void playAudio() async {
    try {
      if (!isPlaying) {
        await _audioPlayer.setSource(AssetSource('sound/bell.mp3'));
        await _audioPlayer.play(AssetSource('sound/bell.mp3'));
        setState(() {
          isPlaying = true;
          isPaused = false;
        });
      }
    } catch (e) {
      print("Error playing audio: $e");
    }
  }

  // Function to pause the audio
  void pauseAudio() async {
    try {
      if (isPlaying && !isPaused) {
        await _audioPlayer.pause();
        setState(() {
          isPaused = true;
        });
      } else if (isPaused) {
        await _audioPlayer.resume();
        setState(() {
          isPaused = false;
        });
      }
    } catch (e) {
      print("Error pausing audio: $e");
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reaction Time Game")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                if (isPlaying) {
                  pauseAudio();
                } else {
                  playAudio();
                }
              },
              child: Text(isPlaying && !isPaused ? 'Pause' : 'Play'),
            ),
          ],
        ),
      ),
    );
  }
}
