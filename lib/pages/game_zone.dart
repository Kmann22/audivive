import 'package:flutter/material.dart';
import 'package:audivive/pages/game_3d.dart';
import 'package:audivive/pages/game_sound_identify.dart';
import 'package:audivive/pages/game_rhythm.dart';
import 'package:audivive/pages/game_noise_speech.dart';
import 'package:audivive/pages/game_auditorymemory.dart';
import 'package:audivive/pages/game_reaction.dart';

class GameZonePage extends StatelessWidget {
  final List<Map<String, dynamic>> games = [
    {"name": "Sound Guess", "color": Colors.orange, "icon": Icons.headphones},
    {
      "name": "Speech in Noise",
      "color": Colors.red,
      "icon": Icons.volume_up, // Changed to 'volume_up' for uniqueness
    },
    {
      "name": "Rhythm Training",
      "color": Colors.purple,
      "icon": Icons.album, // Changed to 'album' for uniqueness
    },
    {
      "name": "Reaction Time Game",
      "color": Colors.pink,
      "icon": Icons.access_alarm, // Retained 'access_alarm' as it fits well
    },
    {
      "name": "Auditory Memory Games",
      "color": Colors.green,
      "icon": Icons.memory, // Retained 'memory' as it fits well
    },
    {
      "name": "3D Sounds",
      "color": Colors.blue,
      "icon": Icons.headset, // Changed to 'headset' for uniqueness
    },
  ];

  void _navigateToGame(BuildContext context, String gameName) {
    switch (gameName) {
      case "Sound Guess":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SoundGame()),
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
      case "3D Sounds":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AudioTestScreen()),
        );
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
      appBar: null, // Removed app bar
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.start, // Center content vertically
          children: [
            SizedBox(height: 100),
            // Centered "Game Zone" text
            Text(
              'Game Zone',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            // List of games
            Expanded(
              child: ListView.builder(
                itemCount: games.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      _navigateToGame(context, games[index]["name"]);
                    },
                    child: Card(
                      elevation:
                          10, // Increased elevation for better shadow effect
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(15), // Rounded corners
                      ),
                      margin: const EdgeInsets.only(bottom: 20),
                      color: games[index]["color"],
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 12.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 30,
                              child: Icon(
                                games[index]["icon"],
                                size: 35,
                                color: games[index]["color"],
                              ),
                            ),
                            const SizedBox(
                                width:
                                    20), // Increased space between icon and text
                            Expanded(
                              child: Text(
                                games[index]["name"],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
