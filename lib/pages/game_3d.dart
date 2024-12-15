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
  int _score = 0; // Tracks the user's score

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

    // Check if the user's choice is correct
    String resultMessage =
        choice == _side ? 'Correct!' : 'Wrong, it was on the $_side';

    // Update score if the answer is correct
    if (choice == _side) {
      _score++;
    }

    // Display the result in a dialog
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
                if (choice == _side) {
                  _playSound(); // Play another sound only if the guess is correct
                }
              },
              child: Text('Next'),
            ),
          ],
        );
      },
    );
  }

  // Stop sound when leaving the screen
  @override
  void dispose() {
    super.dispose();
    _audioPlayer.stop();
  }

  // Show rules dialog
  void _showRules() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Game Rules'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                  '1. A sound will play from either the left or the right side.'),
              SizedBox(height: 10),
              Text(
                  '2. You need to guess whether the sound is from the left or the right.'),
              SizedBox(height: 10),
              Text('3. Get it right to earn points and progress.'),
              SizedBox(height: 10),
              Text('4. Play multiple rounds to improve your hearing skills!'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
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
      appBar: AppBar(
        title: Text('Guess the Side'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: _showRules, // Show rules when pressed
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Which side is the sound coming from?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              if (_userChoice.isEmpty) ...[
                ElevatedButton(
                  onPressed: () => _checkAnswer('left'),
                  child: Text('Left'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => _checkAnswer('right'),
                  child: Text('Right'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                ),
              ] else ...[
                Text(
                  'You guessed: $_userChoice',
                  style: TextStyle(fontSize: 16, color: Colors.blue),
                ),
                SizedBox(height: 20),
                Text(
                  'Your Score: $_score',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _playSound,
                  child: Text('Play Another Sound'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
