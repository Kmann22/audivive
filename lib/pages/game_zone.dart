import 'package:audivive/pages/game_sound_identify.dart';
import 'package:flutter/material.dart';
import 'package:audivive/pages/game_rhythm.dart';
import 'package:audivive/pages/game_noise_speech.dart';
import 'package:audivive/pages/game_auditorymemory.dart';
import 'package:audivive/pages/game_reaction.dart';

class GameZonePage extends StatelessWidget {
  final List<Map<String, dynamic>> games = [
    {"name": "3D Sounds", "color": Colors.blue, "icon": Icons.headset},
    {"name": "Sound Match Image", "color": Colors.orange, "icon": Icons.image},
    {"name": "Pitch and Tone", "color": Colors.green, "icon": Icons.volume_up},
    {"name": "Speech in Noise", "color": Colors.red, "icon": Icons.audiotrack},
    {
      "name": "Rhythm Training",
      "color": Colors.purple,
      "icon": Icons.music_note
    },
    {
      "name": "Sound Discrimination",
      "color": Colors.teal,
      "icon": Icons.compare
    },
    {
      "name": "Auditory Memory Games",
      "color": Colors.yellow,
      "icon": Icons.memory
    },
    {"name": "Find Odd Sound", "color": Colors.cyan, "icon": Icons.hearing},
    {"name": "Reaction Time Game", "color": Colors.pink, "icon": Icons.timer},
    {"name": "Sound Adventure", "color": Colors.indigo, "icon": Icons.explore},
  ];

  void _navigateToGame(BuildContext context, String gameName) {
    switch (gameName) {
      case "Reaction Time Game":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ReactionTimeGamePage()),
        );
        break;
      case "Auditory Memory Games":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TextToSpeechPage()),
        );
        break;
      case "Speech in Noise":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MotivationalGame()),
        );
        break;
      case "Rhythm Training":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RhythmTrainingPage()),
        );
        break;
      case "Sound Match Image":
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  SoundGame()), // Navigate to Sound Match Image game
        );
        break;
      case "Pitch and Tone":
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => PitchAndToneGamePage()),
        // );
        break;
      case "Sound Discrimination":
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //       builder: (context) => SoundDiscriminationGamePage()),
        // );
        break;
      case "Find Odd Sound":
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => FindOddSoundGamePage()),
        // );
        break;
      case "Sound Adventure":
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => SoundAdventureGamePage()),
        // );
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$gameName is under development!')),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Zone'),
        backgroundColor: Colors.blueAccent,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // 3 columns
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: games.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              _navigateToGame(context, games[index]["name"]);
            },
            child: Container(
              decoration: BoxDecoration(
                color: games[index]["color"],
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      games[index]["icon"],
                      size: 40,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      games[index]["name"],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
