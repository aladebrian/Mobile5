import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: _DigitalPetApp(),
  ));
}

class _DigitalPetApp extends StatefulWidget {
  @override
  _DigitalPetAppState createState() => _DigitalPetAppState();
}

class _DigitalPetAppState extends State<_DigitalPetApp> {
  // Pet attributes
  String petName = "Your Pet";
  int happinessLevel = 50;
  int hungerLevel = 50;

  // Controller for name input
  final TextEditingController _nameController = TextEditingController();
  bool _isNameSet = false;

  // Timer for automatic hunger increase
  Timer? _hungerTimer;

  // Variables for game conditions
  String? _gameOverMessage;
  DateTime? _winStartTime;

  @override
  void initState() {
    super.initState();
    // Start a timer that ticks every 30 seconds for hunger increase.
    _hungerTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      setState(() {
        _updateHunger();
        _checkGameConditions();
      });
    });
  }

  @override
  void dispose() {
    _hungerTimer?.cancel();
    _nameController.dispose();
    super.dispose();
  }

  // Function to increase happiness and update hunger when playing with the pet
  void _playWithPet() {
    setState(() {
      happinessLevel = (happinessLevel + 10).clamp(0, 100);
      _updateHunger();
    });
  }

  // Function to decrease hunger and update happiness when feeding the pet
  void _feedPet() {
    setState(() {
      hungerLevel = (hungerLevel - 10).clamp(0, 100);
      _updateHappiness();
    });
  }

  // Update happiness based on hunger level
  void _updateHappiness() {
    if (hungerLevel < 70) {
      happinessLevel = (happinessLevel + 10).clamp(0, 100);
    }
  }

  // Increase hunger level slightly when playing with the pet
  void _updateHunger() {
    hungerLevel = (hungerLevel + 5).clamp(0, 100);
    if (hungerLevel > 70) {
      happinessLevel = (happinessLevel - 20).clamp(0, 100);
    }
  }
  
  // Check win and loss conditions
  void _checkGameConditions() {
    // Loss Condition: Hunger reaches 100 and Happiness drops to 10.
    if (hungerLevel >= 100 && happinessLevel <= 10) {
      _gameOverMessage = "Game Over! Your pet is in distress.";
      _hungerTimer?.cancel();
    } else {
      _gameOverMessage = null;
    }

    // Win Condition: Happiness above 80 for 3 minutes.
    if (happinessLevel > 80) {
      if (_winStartTime == null) {
        _winStartTime = DateTime.now();
      } else {
        final duration = DateTime.now().difference(_winStartTime!);
        if (duration.inMinutes >= 3) {
          _gameOverMessage = "Congratulations! You win!";
          _hungerTimer?.cancel();
        }
      }
    } else {
      // Reset win timer if happiness drops below 80.
      _winStartTime = null;
    }
  }

  // UI for entering pet name
  Widget _buildNameInputUI() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Enter your pet\'s name'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  petName = _nameController.text.isEmpty ? 'Your Pet' : _nameController.text;
                  _isNameSet = true;
                });
              },
              child: Text('Confirm Name'),
            ),
          ],
        ),
      ),
    );
  }

  // Main game UI
  Widget _buildGameUI() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Name: $petName',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'Happiness Level: $happinessLevel',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'Hunger Level: $hungerLevel',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: _playWithPet,
              child: Text('Play with Your Pet'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _feedPet,
              child: Text('Feed Your Pet'),
            ),
            if (_gameOverMessage != null) ...[
              SizedBox(height: 32.0),
              Text(
                _gameOverMessage!,
                style: TextStyle(fontSize: 24.0, color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Digital Pet')),
      body: _isNameSet ? _buildGameUI() : _buildNameInputUI(),
    );
  }
}
