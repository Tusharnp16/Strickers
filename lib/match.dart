import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Create Match',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: CreateMatchPage(),
    );
  }
}

class CreateMatchPage extends StatefulWidget {
  @override
  _CreateMatchPageState createState() => _CreateMatchPageState();
}

class _CreateMatchPageState extends State<CreateMatchPage> {
  // Controllers to get form data
  final TextEditingController teamAController = TextEditingController();
  final TextEditingController teamBController = TextEditingController();
  final TextEditingController matchDateController = TextEditingController();
  final TextEditingController oversDateController = TextEditingController();
  String matchType = 'ODI'; // Default match type

  // Toss details
  String? tossWinner; // Stores which team won the toss
  String? tossChoice; // Stores if the team wants to bat or bowl

  // Method to display selected details
  void displayMatchDetails() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Match Created'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Team A: ${teamAController.text}'),
              Text('Team B: ${teamBController.text}'),
              Text('Match Date: ${matchDateController.text}'),
              Text('Match Type: $matchType'),
              Text('Overs: ${oversDateController.text}'),
              Text('Toss Winner: ${tossWinner ?? 'Not Selected'}'),
              Text('Toss Choice: ${tossChoice ?? 'Not Selected'}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Form validation and creation logic
  void createMatch() {
    if (teamAController.text.isNotEmpty &&
        teamBController.text.isNotEmpty &&
        matchDateController.text.isNotEmpty &&
        tossWinner != null &&
        tossChoice != null) {
      displayMatchDetails(); // Show match details if all fields are filled
    } else {
      // Show error if any field is empty
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please fill all the fields and select the toss winner and choice.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      setState(() {
        matchDateController.text = DateFormat('dd/MM/yyyy').format(selectedDate); // Formatting the date
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Match'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Team A Input
            TextField(
              controller: teamAController,
              decoration: InputDecoration(
                labelText: 'Team A',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0), // Rounded corners
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              ),
            ),
            SizedBox(height: 16),

            // Team B Input
            TextField(
              controller: teamBController,
              decoration: InputDecoration(
                labelText: 'Team B',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0), // Rounded corners
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              ),
            ),
            SizedBox(height: 16),

            // Match Date Input with Calendar Picker
            GestureDetector(
              onTap: () {
                _selectDate(context); // Open calendar when user taps on the field
              },
              child: AbsorbPointer(
                child: TextField(
                  controller: matchDateController,
                  decoration: InputDecoration(
                    labelText: 'Match Date',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0), // Rounded corners
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  ),
                  keyboardType: TextInputType.datetime,
                ),
              ),
            ),
            SizedBox(height: 16),

            // Match Type Dropdown
            DropdownButtonFormField<String>(
              value: matchType,
              onChanged: (String? newValue) {
                setState(() {
                  matchType = newValue!;
                });
              },
              items: <String>['ODI', 'T20', 'Test']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Match Type',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0), // Rounded corners
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              ),
            ),
            SizedBox(height: 16),

            // Overs Input
            TextField(
              controller: oversDateController,
              decoration: InputDecoration(
                labelText: 'Overs',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0), // Rounded corners
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              ),
            ),
            SizedBox(height: 16),

            // Toss Details - Who won the toss (Radio buttons)
            Text(
              'Who won the toss?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    Radio<String>(
                      value: teamAController.text.isNotEmpty ? teamAController.text : 'Team A',
                      groupValue: tossWinner,
                      onChanged: (String? value) {
                        setState(() {
                          tossWinner = value;
                        });
                      },
                    ),
                    Text(teamAController.text.isNotEmpty ? teamAController.text : 'Team A'),
                  ],
                ),
                Row(
                  children: [
                    Radio<String>(
                      value: teamBController.text.isNotEmpty ? teamBController.text : 'Team B',
                      groupValue: tossWinner,
                      onChanged: (String? value) {
                        setState(() {
                          tossWinner = value;
                        });
                      },
                    ),
                    Text(teamBController.text.isNotEmpty ? teamBController.text : 'Team B'),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),

            // Choose to Bat or Bowl
            Text(
              'Choose to Bat or Bowl:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    Radio<String>(
                      value: 'Bat',
                      groupValue: tossChoice,
                      onChanged: (String? value) {
                        setState(() {
                          tossChoice = value;
                        });
                      },
                    ),
                    Text('Bat'),
                  ],
                ),
                Row(
                  children: [
                    Radio<String>(
                      value: 'Bowl',
                      groupValue: tossChoice,
                      onChanged: (String? value) {
                        setState(() {
                          tossChoice = value;
                        });
                      },
                    ),
                    Text('Bowl'),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),

            // Create Match Button
            ElevatedButton(
              onPressed: createMatch,
              child: Text('Create Match'),
            ),
          ],
        ),
      ),
    );
  }
}
