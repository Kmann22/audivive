import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class ReactionTimeGamePage extends StatefulWidget {
  const ReactionTimeGamePage({super.key});

  @override
  State<ReactionTimeGamePage> createState() => _ReactionTimeGamePageState();
}

class _ReactionTimeGamePageState extends State<ReactionTimeGamePage> {
  late AudioPlayer _crowdAudioPlayer;
  late AudioPlayer _bellAudioPlayer;
  bool isPlaying = false;
  Timer? _bellTimer;
  DateTime? _bellStartTime;
  double? _reactionTime;

  @override
  void initState() {
    super.initState();
    _crowdAudioPlayer = AudioPlayer();
    _bellAudioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _crowdAudioPlayer.dispose();
    _bellAudioPlayer.dispose();
    _bellTimer?.cancel();
    super.dispose();
  }

  void startGame() async {
    try {
      await _crowdAudioPlayer.setSource(AssetSource('sound/crowd.mp3'));
      await _crowdAudioPlayer.setReleaseMode(ReleaseMode.loop);
      await _crowdAudioPlayer.play(AssetSource('sound/crowd.mp3'));

      final randomSeconds = Random().nextInt(10) + 5;
      _bellTimer = Timer(Duration(seconds: randomSeconds), playBell);

      setState(() {
        isPlaying = true;
        _reactionTime = null;
      });
    } catch (e) {
      print("Error starting game: $e");
    }
  }

  void playBell() async {
    try {
      _bellStartTime = DateTime.now();
      await _bellAudioPlayer.setSource(AssetSource('sound/bell.mp3'));
      await _bellAudioPlayer.play(AssetSource('sound/bell.mp3'));
    } catch (e) {
      print("Error playing bell: $e");
    }
  }

  void stopGame() async {
    try {
      await _crowdAudioPlayer.stop();
      await _bellAudioPlayer.stop();

      if (_bellStartTime != null) {
        final now = DateTime.now();
        setState(() {
          _reactionTime =
              now.difference(_bellStartTime!).inMilliseconds / 1000.0;
        });
      }

      _bellTimer?.cancel();
      setState(() {
        isPlaying = false;
      });
    } catch (e) {
      print("Error stopping game: $e");
    }
  }

  void showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: const Text(
            "Game Info",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: const Text(
            "This game helps improve your auditory reaction time. "
            "Listen to the crowd noise and stop as soon as you hear the bell. "
            "Your reaction time will be displayed. Practice to improve your focus and reflexes!",
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                "Close",
                style: TextStyle(color: Colors.blueAccent),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Reaction Time Game"),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: showInfoDialog,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: isPlaying ? stopGame : startGame,
              style: ElevatedButton.styleFrom(
                backgroundColor: isPlaying ? Colors.red : Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                elevation: 8,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(isPlaying ? Icons.stop : Icons.play_arrow),
                  const SizedBox(width: 10),
                  Text(isPlaying ? 'Stop' : 'Play'),
                ],
              ),
            ),
            const SizedBox(height: 30),
            if (!isPlaying)
              const Text(
                "Play the crowd audio and find the bell ring in it.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            if (isPlaying)
              const Text(
                "Stop as soon as you hear a bell!",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.amber,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            const SizedBox(height: 30),
            if (_reactionTime != null)
              Card(
                color: Colors.blueGrey.shade900,
                elevation: 8,
                margin: const EdgeInsets.symmetric(horizontal: 40),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    "Your reaction time: ${_reactionTime!.toStringAsFixed(2)} seconds",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
