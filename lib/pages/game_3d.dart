import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AudioTestScreen extends StatefulWidget {
  @override
  _AudioTestScreenState createState() => _AudioTestScreenState();
}

class _AudioTestScreenState extends State<AudioTestScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  String _side = ''; // Stores whether the sound came from 'left' or 'right'
  String _userChoice = ''; // Stores the user's choice

  // Function to randomly choose the sound and play it
  void _playSound() {
    final random = Random();
    int randomSide = random.nextInt(2); // 0 or 1
    _side = randomSide == 0 ? 'left' : 'right';

    // Load and play the corresponding sound
    String audioPath = _side == 'left' ? 'sound/left.mp3' : 'sound/right.mp3';
    _audioPlayer.play(AssetSource(audioPath));

    // Reset user choice for the next round
    setState(() {
      _userChoice = '';
    });
  }

  // Function to check the user's guess
  void _checkAnswer(String choice) {
    setState(() {
      _userChoice = choice;
    });

    // Display the result
    String resultMessage =
        choice == _side ? 'Correct!' : 'Wrong, it was on the $_side ';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Result'),
          content: Text(resultMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _playSound(); // Play another sound after showing result
              },
              child: Text('Next'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _playSound(); // Start with the first sound when the screen loads
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Guess the Side')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Which side is the sound coming from?',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            if (_userChoice.isEmpty) ...[
              ElevatedButton(
                onPressed: () => _checkAnswer('left'),
                child: Text('Left'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => _checkAnswer('right'),
                child: Text('Right'),
              ),
            ] else ...[
              Text(
                'You guessed: $_userChoice',
                style: TextStyle(fontSize: 16, color: Colors.blue),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _playSound,
                child: Text('Play Another Sound'),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
