import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SoundGame extends StatefulWidget {
  @override
  _SoundGameState createState() => _SoundGameState();
}

class _SoundGameState extends State<SoundGame> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final List<Map<String, String>> sounds = [
    {'sound': 'dog-barking.mp3', 'scrambled': 'gdo rkab'},
    {'sound': 'cat.mp3', 'scrambled': 'tac'},
    {'sound': 'police-siren.mp3', 'scrambled': 'licpo esreni'},
    {'sound': 'loud-thunder.mp3', 'scrambled': 'dluo tdhunre'},
    {'sound': 'rain-sound.mp3', 'scrambled': 'niar sonud'},
    {'sound': 'bell.mp3', 'scrambled': 'blel'}
  ];

  String currentSound = '';
  String currentScrambled = '';
  int score = 0;
  bool soundPlayed = false;
  final TextEditingController _controller = TextEditingController();

  void _playSound(String sound) {
    _audioPlayer.play(AssetSource('sound/$sound'));
    setState(() {
      soundPlayed = true;
    });
  }

  void _stopSound() {
    _audioPlayer.stop();
    setState(() {
      soundPlayed = false; // Reset soundPlayed after stopping the audio
    });
  }

  void _checkAnswer(String answer) {
    if (answer == currentSound.split('.')[0]) {
      setState(() {
        score++;
      });
      Fluttertoast.showToast(msg: "Correct!", toastLength: Toast.LENGTH_SHORT);
    } else {
      Fluttertoast.showToast(
          msg: "Try Again!", toastLength: Toast.LENGTH_SHORT);
    }
    _nextSound();
  }

  void _nextSound() {
    final sound = (sounds..shuffle()).first;
    setState(() {
      currentSound = sound['sound']!;
      currentScrambled = sound['scrambled']!;
      soundPlayed = false; // Reset soundPlayed state for the next round
      _controller.clear(); // Clear the text field after each round
    });
  }

  void _showGameInfo() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("How to Play"),
          content: Text(
            "In this game, you will hear a sound. Your task is to guess which sound it is based on the scrambled word that represents it. "
            "Type your guess and press 'Submit Guess'. You score a point for each correct guess!",
          ),
          actions: <Widget>[
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
  void dispose() {
    _audioPlayer.stop(); // Stop any sound when leaving the game screen
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _nextSound();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Guess the Sound"),
        actions: [
          IconButton(
            icon: Icon(Icons.info),
            onPressed: _showGameInfo, // Show game instructions
          ),
          IconButton(
            icon: Icon(Icons.stop),
            onPressed: _stopSound, // Stop audio
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Scrambled sound text or waiting for sound to play
            soundPlayed
                ? Text(
                    "Scrambled Sound: $currentScrambled",
                    style: TextStyle(fontSize: 24),
                  )
                : CircularProgressIndicator(),

            SizedBox(height: 20),
            // Play sound button
            ElevatedButton(
              onPressed: soundPlayed
                  ? null
                  : () {
                      _playSound(currentSound);
                    },
              child: Text("Play Sound"),
            ),

            SizedBox(height: 20),
            // Text Field to input guess
            if (soundPlayed)
              TextField(
                controller: _controller,
                onSubmitted: _checkAnswer,
                decoration: InputDecoration(
                  labelText: "Guess the sound",
                  border: OutlineInputBorder(),
                ),
              ),

            SizedBox(height: 20),
            // Submit Button
            if (soundPlayed)
              ElevatedButton(
                onPressed: () {
                  _checkAnswer(_controller.text);
                },
                child: Text("Submit Guess"),
              ),

            SizedBox(height: 20),
            // Display score
            Text(
              "Score: $score",
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
