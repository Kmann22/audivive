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
      soundPlayed = false; // Reset sound played state
    });
  }

  @override
  void initState() {
    super.initState();
    _nextSound();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Guess the Sound")),
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
