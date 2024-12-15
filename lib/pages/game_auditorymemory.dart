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
    _spokenWords = _words.take(5).toList(); // Limit to 5 words
    _spokenWords.shuffle(); // Shuffle the order for the game
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

  void _showHowToPlay() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("How to Play"),
        content: const Text(
          "1. Press 'Start Game' to hear the words.\n"
          "2. Listen carefully and tap the words in the order they were spoken.\n"
          "3. Once you tap all the words, check if the order is correct.\n"
          "4. If correct, you win! If not, try again.",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  void _showHowItHelps() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("How It Helps to Aid Hearing"),
        content: const Text(
          "This game helps improve auditory memory and listening skills by\n"
          "training the brain to recall spoken words in a specific order. It enhances\n"
          "concentration, improves word recognition, and strengthens cognitive\n"
          "abilities associated with auditory processing, making it beneficial for all ages.",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Auditory Memory Game"),
        actions: [
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: _showHowToPlay,
          ),
          IconButton(
            icon: const Icon(Icons.hearing),
            onPressed: _showHowItHelps,
          ),
        ],
      ),
      body: Center(
        child: _isGameStarted
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Tap the words in the correct order:",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  // Displaying buttons with shuffled words
                  ..._spokenWords.map((word) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: ElevatedButton(
                        onPressed: () => _handleWordTap(word),
                        child: Text(
                          word,
                          style: const TextStyle(fontSize: 18),
                        ),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(200, 50),
                          textStyle: const TextStyle(fontSize: 16),
                        ),
                      ),
                    );
                  }).toList(),
                  const SizedBox(height: 20),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _speakWords,
                    child: const Text(
                      "Start Game",
                      style: TextStyle(fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(200, 50),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
