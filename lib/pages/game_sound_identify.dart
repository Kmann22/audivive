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
  bool isSoundLoaded =
      false; // Flag to ensure sound is loaded only when the button is pressed
  final TextEditingController _controller = TextEditingController();

  void _playSound(String sound) {
    _audioPlayer.play(AssetSource('sound/$sound'));
    setState(() {
      soundPlayed = true;
      isSoundLoaded = true; // Mark sound as loaded once played
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
      isSoundLoaded = false; // Reset the sound loaded flag for the next round
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

  void _showGameImportance() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Importance of the Game"),
          content: Text(
            "This game helps improve your auditory skills, memory, and reaction time. "
            "It's designed to enhance your ability to recognize sounds and react quickly to auditory stimuli.",
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
          // Button to show the importance of the game
          IconButton(
            icon: Icon(Icons.info),
            onPressed: _showGameImportance,
          ),
          // Button to show how to play
          IconButton(
            icon: Icon(Icons.help),
            onPressed: _showGameInfo,
          ),
        ],
      ),
      body: Center(
        // Center-align all content
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Center content vertically
            children: [
              // Only show scrambled sound after sound is played
              if (soundPlayed)
                Text(
                  "Scrambled Sound: $currentScrambled",
                  style: TextStyle(fontSize: 24),
                ),
              if (!soundPlayed)
                CircularProgressIndicator(), // Show progress indicator until play sound is pressed

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
      ),
    );
  }
}
