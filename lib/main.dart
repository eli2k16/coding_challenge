import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(MaterialApp(
    home: DigitalPetApp(),
  ));
}

class DigitalPetApp extends StatefulWidget {
  @override
  _DigitalPetAppState createState() => _DigitalPetAppState();
}

class _DigitalPetAppState extends State<DigitalPetApp> {
  String petName = "Your Pet";
  int happinessLevel = 50;
  int hungerLevel = 50;
  Timer? _hungerTimer;
  String _petMood = "Neutral";
  Color _petColor = Colors.yellow;
  bool isGameOver = false;

  @override
  void initState() {
    super.initState();
    _startHungerTimer();
    _updatePetMood(); // Update mood at the start
  }

  @override
  void dispose() {
    _hungerTimer?.cancel(); // Cancel timer when the app is closed
    super.dispose();
  }

  // Start a timer that increases hunger every 30 seconds
  void _startHungerTimer() {
    _hungerTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      if (!isGameOver) {
        setState(() {
          hungerLevel = (hungerLevel + 5).clamp(0, 100);
          _updatePetMood();
          _checkGameOver();
        });
      }
    });
  }

  // Function to increase happiness and update hunger when playing with the pet
  void _playWithPet() {
    if (!isGameOver) {
      setState(() {
        happinessLevel = (happinessLevel + 10).clamp(0, 100);
        _updateHunger();
        _updatePetMood();
        _checkGameOver();
      });
    }
  }

  // Function to decrease hunger and update happiness when feeding the pet
  void _feedPet() {
    if (!isGameOver) {
      setState(() {
        hungerLevel = (hungerLevel - 10).clamp(0, 100);
        _updateHappiness();
        _updatePetMood();
        _checkGameOver();
      });
    }
  }

  // Update happiness based on hunger level
  void _updateHappiness() {
    if (hungerLevel < 30) {
      happinessLevel = (happinessLevel - 20).clamp(0, 100);
    } else {
      happinessLevel = (happinessLevel + 10).clamp(0, 100);
    }
  }

  // Increase hunger level slightly when playing with the pet
  void _updateHunger() {
    hungerLevel = (hungerLevel + 5).clamp(0, 100);
    if (hungerLevel >= 100) {
      happinessLevel = (happinessLevel - 20).clamp(0, 100);
    }
  }

  // Update pet's mood and color based on happiness level
  void _updatePetMood() {
    if (happinessLevel > 70) {
      _petMood = "Happy 😊";
      _petColor = Colors.green;
    } else if (happinessLevel >= 30 && happinessLevel <= 70) {
      _petMood = "Neutral 😐";
      _petColor = Colors.yellow;
    } else {
      _petMood = "Unhappy 😢";
      _petColor = Colors.red;
    }
  }

  // Check for game over conditions
  void _checkGameOver() {
    if (hungerLevel == 100 && happinessLevel <= 10) {
      setState(() {
        isGameOver = true;
        _hungerTimer?.cancel();
      });
      _showGameOverDialog();
    }
  }

  // Display a game-over dialog
  void _showGameOverDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Game Over'),
        content: const Text(
            'Your pet has reached a hunger level of 100 and is very unhappy.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                isGameOver = false;
                happinessLevel = 50;
                hungerLevel = 50;
                _startHungerTimer();
              });
            },
            child: const Text('Restart'),
          ),
        ],
      ),
    );
  }

  // Set custom pet name
  void _setPetName(String name) {
    setState(() {
      petName = name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Digital Pet'),
      ),
      body: isGameOver
          ? Center(child: Text('Game Over', style: TextStyle(fontSize: 30)))
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Pet Name Customization
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Enter Pet Name',
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: _setPetName,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    'Name: $petName',
                    style: const TextStyle(fontSize: 20.0),
                  ),
                  const SizedBox(height: 16.0),
                  Container(
                    padding: const EdgeInsets.all(20),
                    color: _petColor,
                    child: Text(
                      'Happiness Level: $happinessLevel',
                      style: const TextStyle(fontSize: 20.0, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    'Hunger Level: $hungerLevel',
                    style: const TextStyle(fontSize: 20.0),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    'Mood: $_petMood',
                    style: const TextStyle(fontSize: 20.0),
                  ),
                  const SizedBox(height: 32.0),
                  ElevatedButton(
                    onPressed: _playWithPet,
                    child: const Text('Play with Your Pet'),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _feedPet,
                    child: const Text('Feed Your Pet'),
                  ),
                ],
              ),
            ),
    );
  }
}
