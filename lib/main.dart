import 'package:flutter/material.dart';
import 'dart:async';
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
  String petName = "Your Pet";
  int happinessLevel = 50;
  int hungerLevel = 50;
	bool isVisible = false;
	bool notDone = true;
	int timerCount = 0;
	
	final nameController = TextEditingController();
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
    if (hungerLevel < 30) {
      happinessLevel = (happinessLevel - 20).clamp(0, 100);
    } else {
      happinessLevel = (happinessLevel + 10).clamp(0, 100);
    }
  }

  // Increase hunger level slightly when playing with the pet
  void _updateHunger() {
    hungerLevel = (hungerLevel + 5).clamp(0, 100);
    if (hungerLevel > 100) {
      hungerLevel = 100;
      happinessLevel = (happinessLevel - 20).clamp(0, 100);
    }
  }

	MaterialColor _determineColor() {
		if (happinessLevel < 30) {
			return Colors.red;
		} else if (happinessLevel < 70) {
			return Colors.yellow;
		} else {
			return Colors.green;
		}
	}

	String _determineMood() {
		if (happinessLevel < 30) {
			return "Sad😔";
		} else if (happinessLevel < 70) {
			return "Mundane😐";
		} else {
			return "Happy😊";
		}
	}
	void _setName() {
		setState(() {
			isVisible = !isVisible;
			petName = nameController.text;
		});
	// void startTimer() {
	// 	Timer.periodic(const Duration(seconds: 5), incHunger),
		
	// }
	}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Digital Pet'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
						if (isVisible == false & notDone)
						Column(
							children: <Widget> [
								Text (
								"Enter your pet name."
								),
								TextField(
									controller: nameController,
									decoration: InputDecoration(
										border: OutlineInputBorder(),
										hintText: "Name"
									),
								),
							]
						),
						SizedBox(height: 16.0,),
						ElevatedButton(
							onPressed: _setName, 
							child: Text("Change Name")
						),
						SizedBox(height: 16.0,),
						if (isVisible & notDone)
						Column(
							children: <Widget> [
								Text(
								petName,
								style: TextStyle(
									fontSize: 20.0,
									color: _determineColor()
									),
								),
								SizedBox(height: 16.0),
								Text(
									'Happiness Level: $happinessLevel',
									style: TextStyle(fontSize: 20.0),
								),
								SizedBox(height: 16.0),
								Text(
									'Mood: ${_determineMood()}', 
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
								SizedBox(height: 16.0,),
								Text("Timer: $timerCount")
							]
						)
          ],
        ),
      ),
    );
  }
}