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
            icon: Icon(Icons.stop),
            onPressed: _stopGame,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Rhythm Training',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Tempo: $_currentTempo BPM',
              style: TextStyle(fontSize: 24),
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
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isActive ? null : _startGame,
              child: Text(_isActive ? 'Game Running' : 'Start Game'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isActive ? _increaseTempo : null,
              child: Text('Increase Tempo'),
            ),
          ],
        ),
      ),
    );
  }
}
