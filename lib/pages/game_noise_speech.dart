import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:math';

class MotivationalGame extends StatefulWidget {
  @override
  _MotivationalGameState createState() => _MotivationalGameState();
}

class _MotivationalGameState extends State<MotivationalGame> {
  final FlutterTts _tts = FlutterTts();
  final AudioPlayer _backgroundPlayer = AudioPlayer();
  bool _isGameStarted = false;
  bool _isGameOver = false;
  bool _isTrafficNoisePlaying = false;
  String _wordToGuess = ''; // Store the word to be guessed
  TextEditingController _controller = TextEditingController();

  // List of positive random words
  final List<String> _words = [
    'Success',
    'Love',
    'Peace',
    'Growth',
    'Hope',
    'Happiness',
    'Joy',
    'Prosperity',
    'Kindness',
    'Wisdom',
    'Gratitude',
    'Courage',
    'Strength',
    'Faith',
    'Confidence'
  ];

  // Play the crowd noise and trigger word events
  Future<void> _playTrafficNoise() async {
    setState(() {
      _isTrafficNoisePlaying = true;
    });

    // Start playing crowd noise
    await _backgroundPlayer.setSource(AssetSource('sound/crowd.mp3'));
    await _backgroundPlayer.setVolume(0.3);
    await _backgroundPlayer
        .setReleaseMode(ReleaseMode.loop); // Loop the crowd noise
    await _backgroundPlayer.resume();

    // Wait a random time and then speak a random word
    await _triggerWordDuringNoise();
  }

  // Trigger the word to be spoken at a random interval
  Future<void> _triggerWordDuringNoise() async {
    final random = Random();
    _wordToGuess = _words[random.nextInt(_words.length)];

    // Randomly delay the word speaking
    int wordDelay = random.nextInt(5) + 1; // Random delay between 1-5 seconds

    // Wait for the delay and speak the word
    await Future.delayed(Duration(seconds: wordDelay));
    await _tts.speak(_wordToGuess);

    // Wait until the crowd sound ends before showing the guess dialog
    await _backgroundPlayer.onPlayerComplete;
  }

  // Show a dialog to ask the user to guess the word
  void _showGuessDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Guess the Word!"),
        content: Text("What was the word spoken?"),
        actions: [
          TextField(
            controller: _controller,
            onSubmitted: (guess) {
              _checkAnswer(guess);
              Navigator.of(context).pop();
            },
            decoration: InputDecoration(
              hintText: "Enter your guess here",
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              border: OutlineInputBorder(),
            ),
          ),
          TextButton(
            onPressed: () {
              // Handle submit button
              _checkAnswer(_controller.text);
            },
            child: const Text("Submit"),
          ),
        ],
      ),
    );
  }

  // Check the user's answer (case-insensitive)
  void _checkAnswer(String guess) {
    if (guess.trim().toLowerCase() == _wordToGuess.toLowerCase()) {
      _showResult("Correct! The word was '$_wordToGuess'.");
    } else {
      _showResult("Incorrect. The word was '$_wordToGuess'.");
    }
  }

  // Show the result of the guess
  void _showResult(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _isGameOver = false;
                _controller.clear(); // Clear the TextField
              });
              _playTrafficNoise(); // Restart with crowd noise
            },
            child: const Text("Next"),
          ),
        ],
      ),
    );
  }

  // Start the game
  void _startGame() {
    setState(() {
      _isGameStarted = true;
      _isGameOver = false;
      _controller.clear(); // Clear the previous input
    });
    _playTrafficNoise();
  }

  // Show information about the game
  void _showHowToPlay() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("How to Play"),
        content: Text(
          "In this game, a word will be spoken while a crowd noise is playing in the background. "
          "Your task is to listen carefully and guess the word that was spoken.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Close"),
          ),
        ],
      ),
    );
  }

  // Show information about the importance of the game
  void _showWhyThisIsImportant() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Why This is Important"),
        content: Text(
          "This game helps improve your listening skills, focus, and memory retention in noisy environments. "
          "By practicing under challenging conditions, you can enhance your ability to concentrate in real-world situations.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Close"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _backgroundPlayer.stop();
    _tts.stop();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Guess in Noise"),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: _showHowToPlay,
          ),
          IconButton(
            icon: Icon(Icons.help_outline),
            onPressed: _showWhyThisIsImportant,
          ),
        ],
      ),
      body: Center(
        child: _isGameStarted
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!_isTrafficNoisePlaying)
                    ElevatedButton(
                      onPressed: _playTrafficNoise,
                      child: const Text("Play Traffic Noise"),
                    ),
                  const SizedBox(height: 20),
                  if (!_isGameOver)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          labelText: 'Enter your guess',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                        ),
                        onSubmitted: (guess) {
                          _checkAnswer(guess);
                        },
                      ),
                    ),
                ],
              )
            : ElevatedButton(
                onPressed: _startGame,
                child: const Text("Start Game"),
              ),
      ),
    );
  }
}
