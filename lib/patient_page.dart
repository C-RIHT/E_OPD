import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:e_opd/custom_radio.dart';
//TODO1: Radio button unselected validation
//TODO2: Phone number validation
//TODO3: validation of other UIs

class PatientPage extends StatefulWidget {
  const PatientPage({Key? key}) : super(key: key);

  @override
  State<PatientPage> createState() => _PatientPageState();
}

class _PatientPageState extends State<PatientPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _sexController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _governmentIdController = TextEditingController();
  final _addressController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _knownDiseasesController = TextEditingController();
  final _medicationHistoryController = TextEditingController();
  final _dietPreferencesController = TextEditingController();

  String? _selectedAge;

  // Flag for unit selection visibility (initially hidden)
  final List<String> _ageUnits = [
    'Years',
    'Months',
    'Days'
  ]; // Predefined age units
  String? _selectedSex; // Default selected sex

  final List<String> _sexOptions = [
    'Male',
    'Female',
    'Transgender'
  ]; // Predefined age units
  int? _age;

  List<String> get years => List.generate(
      101, (i) => (i + 1).toString()); // Generate years list (0-100)
  List<String> get months => List.generate(
      12, (i) => (i + 1).toString()); // Generate months list (1-12)

  String? _validateField(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter this field.';
    }
    return null;
  }

  void _handleSave() {
    if (_formKey.currentState!.validate() && _selectedSex != null) {
      _handleAge();
      // Call _handleAge function for age validation and processing

      // Process form data here (e.g., save to database)
      print('Patient data saved successfully!');
      // You can navigate to another page after saving
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields.')),
      );
    }
  }

  void _handleAge() {
    if (_formKey.currentState!.validate()) {
      if (_selectedAge == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Please select a unit (Years, Months, or Days).')),
        );
        return;
      }

      int enteredAge = int.tryParse(_ageController.text) ?? 0;

      print('Age: $enteredAge $_selectedAge');
      // Further processing with age and unit
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in age fields.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Patient Information',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        // Allow scrolling if content overflows
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          //autovalidateMode: AutovalidateMode.onUserInteraction,
          child: LayoutBuilder(
            // Use LayoutBuilder for responsive behavior
            builder: (context, constraints) {
              double screenWidth = MediaQuery.of(context).size.width;
              double maxWidth = screenWidth * 0.7;
              return Column(
                mainAxisSize:
                    MainAxisSize.min, // Content shrinks to minimum size
                crossAxisAlignment:
                    CrossAxisAlignment.stretch, // Fields stretch horizontally
                children: [
                  Container(
                    constraints: BoxConstraints(maxWidth: maxWidth),
                    child: TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        contentPadding: EdgeInsets.all(12.0), // Add padding
                      ),
                      validator: _validateField,
                    ),
                  ),
                  SizedBox(height: 16.0), //AGE section starts here

                  Row(
                    // Row for age unit selection
                    children: [
                      Text("Age:"),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: Row(
                          // Nested Row for Age & Unit selection
                          children: [
                            Expanded(
                              child: TextFormField(
                                // Age input field
                                controller: _ageController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'Age',
                                  contentPadding: const EdgeInsets.all(12.0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(color: Colors.teal),
                                  ),
                                ),
                                validator: _validateField,
                              ),
                            ),
                            const SizedBox(width: 8.0),
                            Wrap(
                              // Wrap for radio buttons within the Row
                              children:
                                  _ageUnits // Use _ageUnits list for dynamic units
                                      .map((String unit) => Row(
                                            // Inner Row for each unit
                                            children: [
                                              Radio<String>(
                                                value: unit,
                                                groupValue: _selectedAge,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _selectedAge = value!;
                                                  });
                                                },
                                                // Color for unselected state
                                              ),
                                              Text(unit),
                                            ],
                                          ))
                                      .toList(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16.0), //SEX section starts here
                  Row(
                    children: [
                      Text('Sex:'), // Text label on the left
                      const SizedBox(width: 16.0),
                      Expanded(
                        // Expanded widget for right-aligned radio buttons
                        child: Row(
                          // Nested Row for radio buttons
                          mainAxisAlignment:
                              MainAxisAlignment.start, // Align to the right
                          children: _sexOptions
                              .map((String sex) => Row(
                                    children: [
                                      Radio<String>(
                                        value: sex,
                                        groupValue: _selectedSex,
                                        onChanged: (value) {
                                          setState(() {
                                            _selectedSex = value!;
                                          });
                                        },
                                      ),
                                      Text(sex),
                                    ],
                                  ))
                              .toList(),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16.0), //Phone Number section starts here
                  Container(
                    constraints:
                        BoxConstraints(maxWidth: maxWidth), // Limit width
                    child: TextFormField(
                      controller: _phoneNumberController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        contentPadding: const EdgeInsets.all(12.0),
                      ),
                      validator: _validateField,
                    ),
                  ),
                  const SizedBox(
                      height: 16.0), //Government ID number starts here
                  Container(
                    constraints: BoxConstraints(
                        maxWidth:
                            maxWidth), // Limit width to 600 on all devices
                    child: TextFormField(
                      controller: _governmentIdController,
                      decoration: InputDecoration(
                        labelText: 'Government ID Number',
                        contentPadding: const EdgeInsets.all(12.0),
                      ),
                      validator: _validateField,
                    ),
                  ),
                  const SizedBox(height: 16.0), // Address section starts here
                  Container(
                    constraints: BoxConstraints(
                        maxWidth:
                            maxWidth), // Limit width to 600 on all devices
                    child: TextFormField(
                      controller: _addressController,
                      maxLines: null, // Allows multi-line input for address
                      decoration: InputDecoration(
                        labelText: 'Address',
                        contentPadding: const EdgeInsets.all(12.0),
                      ),
                      validator: _validateField,
                    ),
                  ),
                  const SizedBox(height: 16.0), //Weight Section starts here
                  Row(
                    children: [
                      Text('Weight (kg):'),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: Container(
                          constraints: BoxConstraints(maxWidth: maxWidth),
                          child: TextFormField(
                            controller: _weightController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(color: Colors.teal),
                              ),
                            ),
                            validator: _validateField,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0), //Height Section starts here
                  Row(
                    children: [
                      Text('Height (cm):'),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: Container(
                          constraints: BoxConstraints(
                              maxWidth:
                                  maxWidth), // Limit width to 600 on all devices
                          child: TextFormField(
                            controller: _heightController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(color: Colors.teal),
                              ),
                            ),
                            validator: _validateField,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                      height: 16.0), //KCO History Section starts here
                  Container(
                    constraints: BoxConstraints(
                        maxWidth: min(constraints.maxWidth,
                            600.0)), // Limit width to 600 on all devices
                    child: TextFormField(
                      controller: _knownDiseasesController,
                      maxLines: null, // Allows multi-line input for diseases
                      decoration: InputDecoration(
                        labelText: 'Known Case of any Diseases',
                        contentPadding: const EdgeInsets.all(12.0),
                      ),
                      validator: _validateField,
                    ),
                  ),
                  const SizedBox(
                      height: 16.0), //Medication History Section starts here
                  Container(
                    constraints: BoxConstraints(
                        maxWidth: min(constraints.maxWidth,
                            600.0)), // Limit width to 600 on all devices
                    child: TextFormField(
                      controller: _medicationHistoryController,
                      maxLines: null, // Allows multi-line input for history
                      decoration: InputDecoration(
                        labelText: 'Medication History',
                        contentPadding: const EdgeInsets.all(12.0),
                      ),
                      validator: _validateField,
                    ),
                  ),
                  const SizedBox(
                      height: 16.0), //Diet preferences Section starts here
                  Container(
                    constraints: BoxConstraints(
                        maxWidth: min(constraints.maxWidth,
                            600.0)), // Limit width to 600 on all devices
                    child: TextFormField(
                      controller: _dietPreferencesController,
                      maxLines: null, // Allows multi-line input for preferences
                      decoration: InputDecoration(
                        labelText: 'Diet Preferences',
                        contentPadding: const EdgeInsets.all(12.0),
                      ),
                      validator: _validateField,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _handleSave,
                    child: const Text('Save Patient Information'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

double min(double a, double b) {
  if (a < b) {
    return a;
  } else {
    return b;
  }
}
