import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeechPage extends StatefulWidget {
  const TextToSpeechPage({super.key});

  @override
  State<TextToSpeechPage> createState() => _TextToSpeechPageState();
}

class _TextToSpeechPageState extends State<TextToSpeechPage> {
  late FlutterTts _flutterTts;
  List<String> _words = [];
  List<String> _spokenWords = [];
  List<String> _userSequence = [];
  bool _isGameStarted = false;

  @override
  void initState() {
    super.initState();
    _flutterTts = FlutterTts();
    _generateWords();
  }

  void _generateWords() {
    // Generate a list of random words
    const wordPool = [
      "apple",
      "banana",
      "cat",
      "dog",
      "elephant",
      "fish",
      "grape",
      "hat",
      "ice",
      "jelly",
      "kite",
      "lemon",
      "monkey",
      "notebook",
      "orange",
      "piano",
      "queen",
      "rainbow",
      "sun",
      "tree",
      "umbrella",
      "violin",
      "water",
      "xylophone",
      "yoyo",
      "zebra"
    ];
    _words = wordPool.toList()..shuffle();
    _spokenWords = _words.take(10).toList();
  }

  Future<void> _speakWords() async {
    for (String word in _spokenWords) {
      await _flutterTts.speak(word);
      await Future.delayed(const Duration(seconds: 2)); // Pause between words
    }
    setState(() {
      _isGameStarted = true; // Enable the game once words are spoken
    });
  }

  void _handleWordTap(String word) {
    setState(() {
      _userSequence.add(word);
      if (_userSequence.length == _spokenWords.length) {
        _checkSequence();
      }
    });
  }

  void _checkSequence() {
    if (_userSequence.join(',') == _spokenWords.join(',')) {
      _showMessage("Winner!");
    } else {
      _showMessage("Failed! Try again.");
    }
  }

  void _showMessage(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _resetGame();
            },
            child: const Text("Play Again"),
          ),
        ],
      ),
    );
  }

  void _resetGame() {
    setState(() {
      _generateWords();
      _userSequence = [];
      _isGameStarted = false;
    });
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Auditory Memory Game")),
      body: Center(
        child: _isGameStarted
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Tap the words in the order they were spoken:",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: (_spokenWords.take(4).toList()..shuffle())
                        .map(
                          (word) => ElevatedButton(
                            onPressed: () => _handleWordTap(word),
                            child: Text(word),
                          ),
                        )
                        .toList(),
                  ),
                ],
              )
            : ElevatedButton(
                onPressed: _speakWords,
                child: const Text("Start Game"),
              ),
      ),
    );
  }
}
