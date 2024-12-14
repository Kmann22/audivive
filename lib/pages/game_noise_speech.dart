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
  bool _isGameStarted = false; // To track if the game has started
  int _currentPhaseIndex = 0;
  bool _isPlayingTrafficNoise = false;
  bool _isGameOver = false;

  final List<Map<String, dynamic>> _phases = [
    {
      "text":
          "Success is not the key to happiness. Happiness is the key to ___.",
      "answer": "Success",
      "options": ["Success", "Freedom", "Life", "Wealth"]
    },
    {
      "text": "Don't watch the clock; do what it ___.",
      "answer": "Does",
      "options": ["Wants", "Ticks", "Does", "Says"]
    },
    {
      "text": "The only way to do great work is to ___ what you do.",
      "answer": "Love",
      "options": ["Love", "Know", "Understand", "Practice"]
    },
    {
      "text": "Believe you can, and you're ___ there.",
      "answer": "Almost",
      "options": ["Almost", "Always", "Not", "Already"]
    },
  ];

  Future<void> _playTrafficNoise() async {
    setState(() => _isPlayingTrafficNoise = true);
    await _backgroundPlayer.setSource(AssetSource('assets/sounds/crowd.mp3'));
    await _backgroundPlayer.setVolume(0.3); // Set traffic sound volume
    await _backgroundPlayer.setReleaseMode(ReleaseMode.loop); // Loop the audio
    await _backgroundPlayer.resume();

    // Wait until the traffic noise finishes
    await Future.delayed(const Duration(
        seconds: 10)); // Adjust duration as per your audio length
    if (!_isGameOver) {
      _showQuestion();
    }
  }

  Future<void> _speakPhase(String text) async {
    await _tts.setSpeechRate(0.5); // Adjust speed
    await _tts.setVolume(1.0); // Speech volume
    await _tts.speak(text);
  }

  void _checkAnswer(String selectedOption) {
    final correctAnswer = _phases[_currentPhaseIndex]["answer"];
    if (selectedOption == correctAnswer) {
      _showResult("Winner! Correct Answer.");
    } else {
      _showResult("Loser! Incorrect Answer.");
    }
  }

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
                if (_currentPhaseIndex < _phases.length - 1) {
                  _currentPhaseIndex++;
                } else {
                  _currentPhaseIndex = 0; // Restart game
                }
              });
              _playTrafficNoise(); // Play traffic noise before the next phase
            },
            child: const Text("Next"),
          ),
        ],
      ),
    );
  }

  void _startPhase() {
    final phaseText = _phases[_currentPhaseIndex]["text"];
    _speakPhase(phaseText);
  }

  // Randomly speak phrases
  void _randomSpeak() {
    final random = Random();
    if (_isGameStarted && !_isGameOver) {
      Future.delayed(Duration(seconds: random.nextInt(5) + 5), () {
        if (!_isGameOver) {
          final randomPhrase = _phases[random.nextInt(_phases.length)]["text"];
          _speakPhase(randomPhrase);
        }
      });
    }
  }

  // Show fill-in-the-blank question
  void _showQuestion() {
    setState(() {
      _isGameOver = true;
    });
    final currentPhase = _phases[_currentPhaseIndex];
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(currentPhase["text"]),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: currentPhase["options"].map<Widget>((option) {
            return ElevatedButton(
              onPressed: () => _checkAnswer(option),
              child: Text(option),
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _backgroundPlayer.stop();
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Motivational Fill-in-the-Blanks")),
      body: _isGameStarted
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Listen to the motivational thought and fill in the blank:",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(height: 20),
                if (!_isGameOver)
                  ElevatedButton(
                    onPressed: _randomSpeak,
                    child: const Text("Listen Random Phrase"),
                  ),
              ],
            )
          : Center(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isGameStarted = true;
                  });
                  _playTrafficNoise(); // Start the game with traffic noise
                },
                child: const Text("Start Game"),
              ),
            ),
    );
  }
}
