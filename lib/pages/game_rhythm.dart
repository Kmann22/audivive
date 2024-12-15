import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';

class RhythmTrainingPage extends StatefulWidget {
  @override
  _RhythmTrainingPageState createState() => _RhythmTrainingPageState();
}

class _RhythmTrainingPageState extends State<RhythmTrainingPage> {
  AudioPlayer _audioPlayer = AudioPlayer();
  int _score = 0;
  int _beatCount = 0;
  int _currentTempo = 60;
  Timer? _timer;
  bool _isActive = false;

  String metronomeSound = 'sound/metronome.mp3';

  int _interval(int bpm) => (60000 / bpm).toInt();

  void _startGame() {
    setState(() {
      _score = 0;
      _beatCount = 0;
      _isActive = true;
    });

    _playBeat();
  }

  Future<void> _playBeat() async {
    _timer = Timer.periodic(Duration(milliseconds: _interval(_currentTempo)),
        (timer) async {
      // Set the audio source first
      await _audioPlayer.setSource(AssetSource(metronomeSound));

      // Play the sound after setting the source
      await _audioPlayer.play(AssetSource(metronomeSound));

      setState(() {
        _beatCount++;
      });
    });
  }

  void _onTap() {
    if (!_isActive) return;

    if (_beatCount % 4 == 0) {
      setState(() {
        _score++;
      });
    }
  }

  void _increaseTempo() {
    setState(() {
      _currentTempo += 10;
    });
    _timer?.cancel();
    _playBeat();
  }

  void _stopGame() {
    _timer?.cancel();
    setState(() {
      _isActive = false;
    });
  }

  void _showGameInfoDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Game Info",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            "In this rhythm training game, you'll tap along with the metronome sound to improve your timing and coordination. "
            "Tap on the green circle to score a point. The tempo increases as you progress, making the game more challenging!",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  void _showWhyThisIsUsefulDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Why This is Useful",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            "Rhythm training is crucial for improving motor coordination, timing, and focus. "
            "This game helps with concentration, muscle memory, and reaction time, which are beneficial in various "
            "activities like music, sports, and even driving!",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rhythm Training Game'),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: _showGameInfoDialog,
          ),
          IconButton(
            icon: Icon(Icons.help_outline),
            onPressed: _showWhyThisIsUsefulDialog,
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Rhythm Training',
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent),
              ),
              SizedBox(height: 20),
              Text(
                'Tempo: $_currentTempo BPM',
                style: TextStyle(fontSize: 24, color: Colors.blueAccent),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: _onTap,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: _beatCount % 4 == 0 ? Colors.green : Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Score: $_score',
                style: TextStyle(fontSize: 24, color: Colors.blueAccent),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isActive ? null : _startGame,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isActive
                      ? Colors.grey
                      : Colors
                          .blueAccent, // Use backgroundColor instead of primary
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                child: Text(_isActive ? 'Game Running' : 'Start Game'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isActive ? _increaseTempo : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isActive
                      ? Colors.green
                      : Colors.grey, // Use backgroundColor instead of primary
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                child: Text('Increase Tempo'),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
