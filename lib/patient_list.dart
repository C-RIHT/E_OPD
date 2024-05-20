import 'package:e_opd/patient_page.dart';
import 'package:e_opd/visit_entry.dart';
import 'package:flutter/material.dart';

class Patient {
  final int id; // Unique identifier for each patient
  final String name;
  final int age;
  final String sex;
  final String phoneNumber;
  final String governmentId;
  final String address;
  final double weight;
  final double height;
  final String kcoHistory;
  final String medicationHistory;
  final String dietPreferences;

  Patient({
    required this.id,
    required this.name,
    required this.age,
    required this.sex,
    required this.phoneNumber,
    required this.governmentId,
    required this.address,
    required this.weight,
    required this.height,
    required this.kcoHistory,
    required this.medicationHistory,
    required this.dietPreferences,
  });
}

class PatientList extends StatefulWidget {
  @override
  _PatientListState createState() => _PatientListState();
}

class _PatientListState extends State<PatientList> {
  final List<Patient> _patients = [
    // Create Patient objects with details (replace with actual data)
    Patient(
      id: 1,
      name: 'Name 1',
      age: 30,
      sex: 'Sex 1',
      phoneNumber: '(123) 456-7890',
      governmentId: 'ABC123',
      address: '123 Main St',
      weight: 70.0,
      height: 175.0,
      kcoHistory: 'KCO History 1,' 'KCO History 2',
      medicationHistory: 'Medication History 1',
      dietPreferences: 'Diet Preferences 1',
    ),
    Patient(
      id: 2,
      name: 'Name 2',
      age: 20,
      sex: 'Sex 2',
      phoneNumber: '(123) 456-7890',
      governmentId: 'ABC123',
      address: '123 Main St',
      weight: 70.0,
      height: 175.0,
      kcoHistory: 'KCO History 2',
      medicationHistory: 'Medication History 2',
      dietPreferences: 'Diet Preferences 1',
    ),
    Patient(
      id: 3,
      name: 'Name 3',
      age: 30,
      sex: 'Sex 3',
      phoneNumber: '(123) 456-7890',
      governmentId: 'ABC123',
      address: '123 Main St',
      weight: 70.0,
      height: 175.0,
      kcoHistory: 'KCO History 3',
      medicationHistory: 'Medication History 3',
      dietPreferences: 'Diet Preferences 3',
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Patient List',
          style: TextStyle(color: Colors.white), // Set text color to white
        ),
        backgroundColor: Colors.teal,
      ),
      body: ListView.builder(
        itemCount: _patients.length,
        itemBuilder: (context, index) {
          final patient = _patients[index];
          // Wrap ListTile in a Container
          return Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey.shade300, // Mild grey color for the border
                  width: 1.0, // Adjust border width as needed
                ),
              ),
            ),
            child: ListTile(
              title: Text('Patient ${patient.id}'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PatientDetailsPage(patient: patient),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  PatientPage()), // Replace with your PatientPage route
        ),
        child: Icon(Icons.add), // Add button icon
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation
          .endFloat, // Position it at the bottom right
    );
  }
}

class PatientDetailsPage extends StatelessWidget {
  final Patient patient;

  const PatientDetailsPage({required this.patient});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Patient Details',
          style: TextStyle(color: Colors.white), // Set text color to white
        ),
        backgroundColor: Colors.teal,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: Colors.white), // Set back arrow color
          onPressed: () => Navigator.pop(context), // Handle back button press
        ),
      ),
      body: SingleChildScrollView(
        // Allow scrolling for long details
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Name: ${patient.name}',
                style: TextStyle(fontSize: 18.0),
              ),
              SizedBox(height: 8.0),
              Text(
                'Age: ${patient.age} (Age ${patient.id})',
              ),
              SizedBox(height: 8.0),
              Text(
                'Sex: ${patient.sex} (Sex ${patient.id})',
              ),
              SizedBox(height: 8.0),
              Text(
                'Phone Number: ${patient.phoneNumber}',
              ),
              SizedBox(height: 8.0),
              Text(
                'Government ID: ${patient.governmentId}',
              ),
              SizedBox(height: 8.0),
              Text(
                'Address: ${patient.address}',
              ),
              SizedBox(height: 8.0),
              Text(
                'Weight: ${patient.weight} kg (Weight ${patient.id})',
              ),
              SizedBox(height: 8.0),
              Text(
                'Height: ${patient.height} cm (Height ${patient.id})',
              ),
              SizedBox(height: 8.0),
              Text(
                'KCO History: ${patient.kcoHistory} (KCO History ${patient.id})',
              ),
              SizedBox(height: 8.0),
              Text(
                'Medication History: ${patient.medicationHistory} (Medication History ${patient.id})',
              ),
              SizedBox(height: 8.0),
              Text(
                'Diet Preferences: ${patient.dietPreferences} (Diet Preferences ${patient.id})',
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  VisitEntryPage()), // Replace with your PatientPage route
        ),
        child: Icon(Icons.add), // Add button icon
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation
          .endFloat, // Position it at the bottom right
    );
  }
}
