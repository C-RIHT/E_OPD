import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // for formatting date and time

// Assuming PatientData is already defined in patient_data.dart

class VisitData {
  final String patientName; // Placeholder for now
  final String patientId; // Placeholder for now

  VisitData({required this.patientName, required this.patientId});
}

class PatientData {
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

  PatientData({
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

class VisitEntryPage extends StatefulWidget {
  @override
  _VisitEntryPageState createState() => _VisitEntryPageState();
}

class _VisitEntryPageState extends State<VisitEntryPage> {
  final _formKey = GlobalKey<FormState>();
  String _temperature = '';
  String _systolic = ''; // Systolic BP
  String _diastolic = ''; // Diastolic BP
  String _spo2 = '';
  String _pulseRate = '';
  String _currentTime = '';

  @override
  void initState() {
    super.initState();
    _currentTime = DateFormat('yyyy-MM-dd hh:mm:ss a').format(DateTime.now());
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Process form data (placeholder for now)
      print(
          'Visit data: $_currentTime, $_temperature °F , $_systolic/$_diastolic mmHg, $_spo2%, $_pulseRate bpm');
    }
  }

  @override
  Widget build(BuildContext context) {
    final patientData = PatientData(
      name: 'John Doe', // Replace with actual name retrieval logic
      age: 30, // Replace with actual age retrieval logic
      sex: 'Male', // Replace with actual sex retrieval logic
      phoneNumber:
          '+1234567890', // Replace with actual phone number retrieval logic
      governmentId:
          'ABC123', // Replace with actual government ID retrieval logic
      address:
          '123 Main Street, Anytown, CA 12345', // Replace with actual address retrieval logic
      weight: 70.0, // Replace with actual weight retrieval logic
      height: 1.75, // Replace with actual height retrieval logic
      kcoHistory:
          'Hypertension, Diabetes, Hypercholesterolemia, Hyperthyroidism, Prostatomegaly', // Replace with actual history retrieval logic
      medicationHistory:
          'Lisinopril ', // Replace with actual history retrieval logic
      dietPreferences:
          'No dietary restrictions', // Replace with actual preferences retrieval logic
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Visit Entry',
          style: TextStyle(color: Colors.white), // White text color
        ),
        backgroundColor: Colors.teal, // Teal background for app bar
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Patient Information
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Table(
                    border: TableBorder.all(
                        color: Colors.transparent), // No borders
                    children: [
                      TableRow(
                        children: [
                          const TableCell(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Text('Patient:'),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(patientData.name),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          const TableCell(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Text('Age:'),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child:
                                  Text('${patientData.age}/${patientData.sex}'),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          const TableCell(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Text('K/C/O History:'),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(patientData.kcoHistory),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          const TableCell(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Text('Medication History:'),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(patientData.medicationHistory),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          const TableCell(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Text('Diet Preferences:'),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(patientData.dietPreferences),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20.0),

              // Current Time
              Text(
                'Entry at: $_currentTime',
                style: const TextStyle(
                  fontWeight: FontWeight.bold, // Make text bold
                  fontSize: 16.0, // Increase font size to 18.0
                ),
              ),
              const SizedBox(height: 10.0),

              // Vital Signs
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Temperature (Fahrenheit)',
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.teal),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter temperature.';
                          }
                          return null;
                        },
                        onSaved: (value) => _temperature = value!,
                      ),
                      const SizedBox(height: 10.0),
                      Row(
                        children: [
                          Flexible(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'BP (Systolic) mmHg',
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors
                                          .teal), // Box decoration on focus
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter systolic BP.';
                                }
                                return null;
                              },
                              onSaved: (value) => _systolic = value!,
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          const Text(
                            '/',
                            style: TextStyle(
                              fontWeight: FontWeight.bold, // Make text bold
                              fontSize: 24.0, // Increase font size to 18.0
                            ),
                          ), // Slash symbol between BP fields
                          const SizedBox(width: 10.0),
                          Flexible(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'BP (Diastolic) mmHg',
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors
                                          .teal), // Box decoration on focus
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter diastolic BP.';
                                }
                                return null;
                              },
                              onSaved: (value) => _diastolic = value!,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'SpO2',
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.teal),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter SpO2.';
                          }
                          return null;
                        },
                        onSaved: (value) => _spo2 = value!,
                      ),
                      const SizedBox(height: 10.0),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Pulse Rate',
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.teal),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter pulse rate.';
                          }
                          return null;
                        },
                        onSaved: (value) => _pulseRate = value!,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20.0),

              // Submit Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save(); // Save form values
                      _submitForm(); // Call submit function
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.teal,
                  ),
                  child: const Text('Create Visit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
