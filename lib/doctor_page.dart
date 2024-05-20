import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for FilteringTextInputFormatter
import 'package:flutter/widgets.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart'; // Import the package

class Drugs {
  final String name;
  final String form;
  final String strength;
  final String drugClass;
  final String brandNames; // Optional brand names

  Drugs(
    this.name,
    this.form,
    this.strength,
    this.drugClass,
    this.brandNames,
  );
}

class Drug {
  final String name;
  final String form;
  final String strength;
  final String drugClass;
  final String brandNames; // Dosage instructions (e.g., 1 tablet twice a day)

  Drug(
      {required this.name,
      required this.form,
      required this.strength,
      required this.drugClass,
      required this.brandNames});
}

final List<Drugs> _drugsList = [
  Drugs("Paracetamol", "Tablet", "500mg", "An analgesic", "Panadol"),
  Drugs("Paracetamol", "Tablet", "500mg", "An analgesic", "Tylenol"),
  Drugs("Ibuprofen", "Tablet", "200mg", "NSAID", "Advil"),
  Drugs("Ibuprofen", "Tablet", "200mg", "(NSAID)", "Motrin"),
  Drugs("Augmentin", "Syrup", "125mg/31.25mg per 5mL", "Penicillin antibiotic",
      "Amoxil"),
  Drugs("Augmentin", "Syrup", "125mg/31.25mg per 5mL", "Penicillin antibiotic",
      "Clavulin"),
  Drugs(
      "Augmentin", "Tablet", "500mg/125mg", "Penicillin antibiotic", "Amoxil"),
  Drugs("Augmentin", "Tablet", "500mg/125mg", "Penicillin antibiotic",
      "Clavulin"),
  Drugs(
      "Chlorpheniramine", "Tablet", "10mg", "Antihistamine", "Chlor-Trimeton"),
  Drugs("Chlorpheniramine", "Tablet", "10mg", "Antihistamine", "Teldrin"),
  Drugs("Chlorpheniramine", "Syrup", "10mg", "Antihistamine", "Chlor-Trimeton"),
  Drugs("Chlorpheniramine", "Syrup", "10mg", "Antihistamine", "Teldrin"),
  Drugs("Dextromethorphan", "Syrup", "10 mg", "Cough suppressant", "Delsym"),
  Drugs("Dextromethorphan", "Syrup", "10 mg", "Cough suppressant", "Pertussin"),
  Drugs("Paracetamol", "Syrup", "125 mg", "An analgesic", "Panadol"),
  Drugs("Paracetamol", "Syrup", "250", "An analgesic", "Tylenol"),
  Drugs("Loperamide", "Capsule", "2mg", "Antidiarrheal", "Imodium"),
  Drugs("Loperamide", "Capsule", "2mg", "Antidiarrheal", "Loperamide"),
  Drugs("Prednisolone", "Tablet", "5mg", "Corticosteroid", "Wysolone"),
];

class Patient {
  final String name = 'Patient XX';
  final int age = 27;
  final String medicalHistory = 'Hypertendion';
}

class Medication {
  final String id;
  final String brand;
  final String form;
  final String generic;

  Medication(this.id, this.brand, this.form, this.generic);
}

class Medicine {
  final String brand;
  final String genericName;
  final String dosage;
  final String instructions; // Dosage instructions (e.g., 1 tablet twice a day)

  Medicine({
    required this.brand,
    required this.genericName,
    required this.dosage,
    required this.instructions,
  });

  @override
  String toString() =>
      '$brand ($genericName)'; // Display both brand and generic name
}

class DoctorPage extends StatefulWidget {
  final String doctorName = 'Dr';
  //final Patient patient;

  //const DoctorPage({required this.doctorName, required this.patient});

  @override
  _DoctorPageState createState() => _DoctorPageState();
}

class _DoctorPageState extends State<DoctorPage> {
  final _typeAheadController = TextEditingController();
  final labelController =
      TextEditingController(); // Create controller for Label
  TextEditingController drugController =
      TextEditingController(); // Define a controller for the TextField
  final suggestionsController = SuggestionsController<String>();
  final _typeAheadFocusNode = FocusNode();

  final TextEditingController _medicationController = TextEditingController();
  final TextEditingController _dosageController = TextEditingController();
  final TextEditingController _daysController = TextEditingController();
  String _selectedDosage = 'Tablet'; // Default unit
  bool _morningSelected = false; // Initially unchecked
  bool _noonSelected = false;
  bool _eveningSelected = false;
  bool _nightSelected = false;
  String selectedSuggestion = '';
  final FocusNode focusNode = FocusNode();

  List<String> prescriptions = []; // Replace with your medicine data

  final List<Medicine> _prescribedMedicines = [];
  final List<Medicine> _prescriptionInstructions = []; // Empty list
  Map<String, bool> _selectedDoseForms = {}; // Map to store selection states
  String? _currentSelectedDoseForm; // Stores the currently selected dose form
  final List<String> _doseForms = [
    'Tablet',
    'Capsule',
    'Syrup',
    'Drops',
    'Oint/Cream',
    'Soaps',
    'Powder'
  ]; // List of dose forms
  String _selectedDoseForm =
      ''; // Define a variable to store the selected form, Useed to shortlist typeAhead

  bool _anyChipSelected = false; // Flag to track overall selection state

  @override
  void initState() {
    super.initState();
    _selectedDoseForms = Map.fromIterable(_doseForms,
        key: (form) => form,
        value: (form) => false); // Initialize all selections to false
  }

  void _showAddPrescriptionBottomSheet(
      BuildContext context, List<String> prescriptions) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return _buildAddPrescriptionForm(
            prescriptions); // Build the form widget
      },
    );
  }

  Widget _buildAddPrescriptionForm(List<String> prescriptions) {
    print('The empty is $_dosageController');
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16.0), // Add some spacing
          const SizedBox(
            height: 8.0,
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            child: prescriptions.isEmpty
                ? TextField(
                    controller: _dosageController,
                    decoration: InputDecoration(labelText: 'Enter Manually'),
                    onSubmitted: (value) {
                      setState(() {
                        prescriptions.add(value);
                        //_dosageController.clear();
                      });
                    },
                  )
                : Text(
                    'Prescriptions: ${prescriptions.join(', ')}',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
          ),

          const SizedBox(
            height: 8.0,
          ),

          const SizedBox(
            height: 8.0,
          ),
          Padding(
            padding:
                const EdgeInsets.all(16.0), // Add padding of 8.0 on all sides
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller:
                        _medicationController, // Create a TextEditingController
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Dosage',
                      border: const OutlineInputBorder(),
                      hintText: 'Enter the dose (e.g., 10.5)',
                    ),
                    onSubmitted: (value) {
                      setState(() {
                        prescriptions.add(value);
                        //_dosageController.clear();
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10.0),
                DropdownButton<String>(
                  value: 'tablets', // Set initial selected unit
                  items: const [
                    DropdownMenuItem(
                      value: 'tablets',
                      child: Text('tablets'),
                    ),
                    DropdownMenuItem(
                      value: 'ml',
                      child: Text('ml'),
                    ),
                    DropdownMenuItem(
                      value: 'drops',
                      child: Text('drops'),
                    ),
                  ],
                  onChanged: (unit) {
                    setState(() {
                      onSubmitted:
                      (value) {
                        setState(() {
                          prescriptions.add(value);
                          //_dosageController.clear();
                        });
                      };
                      // Assuming you're using a stateful widget
                      print('Selected unit: $unit');
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 10.0), // Add spacing between rows
          const SizedBox(height: 10.0), // Add spacing between rows
          Row(
            // Wrap the checkbox row with Expanded to prevent overflow
            mainAxisAlignment: MainAxisAlignment
                .center, // Align the row contents to the center horizontally

            children: [
              Row(
                children: [
                  Checkbox(
                    value: _morningSelected,
                    onChanged: (value) {
                      setState(() {
                        _morningSelected = value!;
                        if (value) {
                          prescriptions.add(_morningSelected.toString());

                          print('Morning selected');
                        }
                      });
                    },
                  ),
                  const Text('Morning'), // Label for the 'Morning' checkbox
                  const SizedBox(width: 10.0),
                  Checkbox(
                    value: _noonSelected,
                    onChanged: (value) {
                      setState(() {
                        _noonSelected = value!;
                        if (value) {
                          prescriptions.add(_noonSelected.toString());

                          print('Noon selected');
                        }
                      });
                    },
                  ),
                  const Text('Noon'), // Label for the 'Noon' checkbox
                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                children: [
                  Checkbox(
                    value: _eveningSelected,
                    onChanged: (value) {
                      setState(() {
                        _eveningSelected = value!;
                        if (value) {
                          prescriptions.add(_eveningSelected.toString());

                          print('Evening selected');
                        }
                      });
                    },
                  ),
                  const Text('Evening'), // Label for the 'Evening' checkbox
                  const SizedBox(width: 10.0),
                  Checkbox(
                    value: _nightSelected,
                    onChanged: (value) {
                      setState(() {
                        _nightSelected = value!;
                        if (value) {
                          prescriptions.add(_nightSelected.toString());

                          print('Night selected');
                        }
                      });
                    },
                  ),
                  const Text('Night'),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 8.0,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter Duration',
                labelText: 'Days',
              ),
            ),
          ),
          const SizedBox(
            height: 8.0,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Special Instructions',
                labelText: 'Special Orders',
              ),
            ),
          ),
          const SizedBox(
            height: 8.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  DoctorPage();
                },
                child: const Text('Add Entry'),
              ),
            ],
          ),
          const SizedBox(
            height: 16.0,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dr. '),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Card(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IntrinsicHeight(
                          child: Padding(
                            padding: EdgeInsets.only(right: 8.0),
                            child: Text(
                              'Patient Name:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Wrap(
                            children: [
                              Text(
                                  'John Doe we adsdf adfsf adfdfa dsf dfa adf f'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Age:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text('35'),
                      ],
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Sex:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text('Male'),
                      ],
                    ),
                    SizedBox(height: 8.0),
                    // ... Add similar rows for other vitals (Temp, BP, PR, SpO2)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Temp:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text('98°F'),
                      ],
                    ),
                    SizedBox(height: 8.0),
                    // ... Add similar rows for other vitals (Temp, BP, PR, SpO2)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'BP:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text('110' '/' '80' 'mmHg'),
                      ],
                    ),
                    SizedBox(height: 8.0),
                    // ... Add similar rows for other vitals (Temp, BP, PR, SpO2)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Pulse Rate:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text('68 bpm'),
                      ],
                    ),
                    SizedBox(height: 8.0),
                    // ... Add similar rows for other vitals (Temp, BP, PR, SpO2)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'SpO2:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text('98%'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            const Text(
              'Your Prescription', // Text below the first card
              style: TextStyle(fontSize: 16.0), // Adjust font size as needed
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Stack(
                // Wrap with Stack for layering
                children: [
                  TypeAheadField<String>(
                    suggestionsController: suggestionsController,
                    hideOnUnfocus: true,
                    hideWithKeyboard: true,
                    suggestionsCallback: (pattern) async {
                      // Implement your logic to filter drugs based on pattern
                      return _drugsList
                          .where((drug) =>
                              drug.name
                                  .toLowerCase()
                                  .contains(pattern.toLowerCase()) ||
                              drug.brandNames
                                  .toLowerCase()
                                  .contains(pattern.toLowerCase()))
                          .map((drug) =>
                              '${drug.form} - ${drug.name} - ${drug.strength} - ${drug.brandNames}')
                          .take(5)
                          .toList();
                    },
                    itemBuilder: (context, suggestion) {
                      return ListTile(
                        title: Text(suggestion),
                      );
                    },
                    onSelected: (suggestion) {
                      setState(() {
                        prescriptions.clear();
                        prescriptions.add(suggestion);
                        drugController.text =
                            suggestion; // Clear the text field (optional)
                      });
                      // get the slection to create a list and updates in the table in main builder

                      // Handle the selected suggestion
                      // You can access details about the selected drug from _drugsList based on the suggestion string
                      print('pritn $prescriptions');
                      _showAddPrescriptionBottomSheet(context, prescriptions);
                    },
                    builder: (context, TextEditingController controller,
                        FocusNode focusNode) {
                      return TextField(
                        controller: controller,
                        focusNode: focusNode,
                        autofocus: false,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Enter Medicine',
                        ),
                      );
                    },
                    constraints: BoxConstraints(maxHeight: 500),
                    loadingBuilder: (context) => const Text('Loading...'),
                    // Loading indicator
                  ),
                  // GestureDetector(
                  //   // Add GestureDetector on top
                  //   onTap: () {
                  //     suggestionsController.close(retainFocus: true);
                  //   },
                  //   child: Container(
                  //     // Fills remaining space (optional)

                  //     color: Colors.transparent, // Make it transparent
                  //     height: 100,
                  //     width: 100,
                  //   ),
                  // ),
                ],
              ),
            ),

            const SizedBox(
              height: 8.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    onPressed:
                    prescriptions.clear();
                    drugController.clear();
                    _showAddPrescriptionBottomSheet(
                      context,
                      prescriptions,
                    );
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Add Manually'),
                ),
              ],
            ),
            const SizedBox(height: 8.0), // Spacing before table
            // Get prescription data (replace with your data fetching logic)
            Table(
              border: TableBorder.all(color: Colors.grey, width: 1.0), // Border
              children: const [
                // Table header row
                TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'No',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Drug Details',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: RotatedBox(
                          quarterTurns: 3, // Rotates 270 degrees (3 quarters)
                          child: Text(
                            'B.Food',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: RotatedBox(
                          quarterTurns: 3, // Rotates 270 degrees (3 quarters)
                          child: Text(
                            'A.Food',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: RotatedBox(
                          quarterTurns: 3, // Rotates 270 degrees (3 quarters)
                          child: Text(
                            'Morning',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: RotatedBox(
                          quarterTurns: 3, // Rotates 270 degrees (3 quarters)
                          child: Text(
                            'Noon',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: RotatedBox(
                          quarterTurns: 3, // Rotates 270 degrees (3 quarters)
                          child: Text(
                            'Evening',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: RotatedBox(
                          quarterTurns: 3, // Rotates 270 degrees (3 quarters)
                          child: Text(
                            'Night',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 8.0,
            ),

            Text(
              'Prescriptions: ${prescriptions.join(', ')}',
              style: Theme.of(context).textTheme.titleMedium,
            ),

            const SizedBox(
              height: 8.0,
            ),
          ],
        ),
      ),
    );
  }
}




//   @override
//   Widget build(BuildContext context) {
//     return CupertinoPageScaffold(
//       navigationBar: CupertinoNavigationBar(
//         middle: Text(
//             'Dr. ${widget.doctorName}'), // Display doctor name in navigation bar
//       ),
//       child: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Card(
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Patient: ${widget.patient.name}',
//                         style: const TextStyle(
//                             fontSize: 16.0, fontWeight: FontWeight.bold),
//                       ),
//                       const SizedBox(height: 8.0),
//                       Text('Age: ${widget.patient.age}'),
//                       Text('Medical History: ${widget.patient.medicalHistory}'),
//                     ],
//                   ),
//                 ),
//               ),

//               // Display e-prescription card (replace with your data retrieval logic)
//               Card(
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'E-Prescription',
//                         style: TextStyle(
//                             fontSize: 16.0, fontWeight: FontWeight.bold),
//                       ),
//                       const SizedBox(height: 8.0),

//                       // List of Medications
//                       const Text('List of Medications:'),
//                       ListView.builder(
//                         shrinkWrap: true, // Prevent list from overflowing
//                         itemCount: _prescribedMedicines
//                             .length, // Replace with your data source
//                         itemBuilder: (context, index) {
//                           final medicine = _prescribedMedicines[
//                               index]; // Access medicine data
//                           return Text(
//                             ' - ${medicine.brand} (${medicine.genericName}) - ${medicine.dosage}',
//                           );
//                         },
//                       ),

//                       const SizedBox(height: 8.0),

//                       // Additional Instructions
//                       const Text('Additional Instructions:'),
//                       Text(
//                         _prescriptionInstructions
//                             .map((medicine) => medicine.instructions)
//                             .join('\n'),
//                       ), // Handle missing instructions
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 8.0),
//               const Text(
//                 'Create Prescriptions:',
//                 style: TextStyle(
//                   fontSize: 14.0, // Adjust font size as needed
//                   color: Colors.black, // Set font color to black
//                 ),
//               ),
//               const SizedBox(height: 16.0),
//               Wrap(
//                 spacing: 8.0, // Spacing between chips
//                 children: [
//                   for (final form in [
//                     'Tablet',
//                     'Capsule',
//                     'Syrup',
//                     'Drops',
//                     'Oint/Cream',
//                     'Soaps',
//                     'Powder'
//                   ])
//                     Column(
//                       children: [
//                         SelectableChip(
//                           label: form,
//                           onSelected: (isSelected) =>
//                               _handleChipSelection(form, isSelected),
//                           selectedColor: Colors.teal,
//                           backgroundColor: CupertinoColors.systemGrey4,
//                           isSelected: _selectedDoseForms[form] ??
//                               false, // Pass the correct selection state
//                         ),
//                         SizedBox(height: 8.0),
//                       ],
//                     ),
//                 ],
//               ),

//               const SizedBox(height: 16.0),

//               CupertinoTypeAheadField<Drugs>(
//                 builder: (context, controller, focusNode) => StatefulBuilder(
//                   builder: (context, setState) => CupertinoTextField(
//                     controller: _medicationController,
//                     focusNode: focusNode,
//                     placeholder: 'Enter Drug Name',
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10.0),
//                       border: Border.all(color: CupertinoColors.systemGrey4),
//                     ),
//                     onChanged: (value) {
//                       setState(() {
//                         _medicationController.text = value;
//                         _medicationController.selection =
//                             TextSelection.fromPosition(
//                           TextPosition(
//                               offset: _medicationController.text.length),
//                         );
//                       });
//                     },
//                   ),
//                 ),
//                 suggestionsCallback: (pattern) {
//                   final selectedForm = _selectedDoseForm;
//                   if (selectedForm != null && selectedForm.isNotEmpty) {
//                     return _drugsList
//                         .where((drug) =>
//                             drug.name
//                                 .toLowerCase()
//                                 .contains(pattern.toLowerCase()) &&
//                             drug.form.toLowerCase() ==
//                                 selectedForm.toLowerCase())
//                         .take(5)
//                         .toList();
//                   } else {
//                     // No chip selected, return all suggestions
//                     return _drugsList
//                         .where((drug) => drug.name
//                             .toLowerCase()
//                             .contains(pattern.toLowerCase()))
//                         .take(5)
//                         .toList();
//                   }
//                 },
//                 itemBuilder: (context, suggestion) => Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Text(
//                     '${suggestion.name} - ${suggestion.strength}', // Display name and strength
//                     style: CupertinoTheme.of(context).textTheme.textStyle,
//                   ),
//                 ),
//                 onSelected: (Drugs selection) {
//                   _medicationController.text =
//                       '${selection.name}-${selection.strength}';
//                   _medicationController.selection = TextSelection.fromPosition(
//                     TextPosition(offset: _medicationController.text.length),
//                   );
//                   // Handle drug selection here (e.g., display details)
//                   print('Selected drug: ${selection.name}');
//                 },
//               ),
//               const SizedBox(height: 8.0),
//               Row(
//                 children: [
//                   Text(
//                     'Dosage',
//                     style: TextStyle(
//                       fontSize: 16.0,
//                       color: Colors.black,
//                     ),
//                   ),
//                   const SizedBox(width: 8.0),
//                   Flexible(
//                     child: Row(
//                       // Nested Row for number field and dropdown
//                       children: [
//                         Expanded(
//                           child: CupertinoTextField(
//                             controller: _dosageController,
//                             keyboardType: TextInputType.number,
//                             placeholder: 'Enter dosage',
//                             padding: EdgeInsets.all(8.0),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(5.0),
//                               border: Border.all(
//                                   color: CupertinoColors.systemGrey4),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 8.0),
//                         CupertinoButton(
//                           onPressed: () {
//                             showCupertinoModalPopup<void>(
//                               context: context,
//                               builder: (BuildContext context) =>
//                                   CupertinoActionSheet(
//                                 title: const Text('Select a Unit'),
//                                 actions: <Widget>[
//                                   CupertinoActionSheetAction(
//                                     child: const Text('Tablet'),
//                                     onPressed: () {
//                                       setState(() {
//                                         _selectedDosage = 'Tablet';
//                                       });
//                                       Navigator.pop(context);
//                                     },
//                                   ),
//                                   CupertinoActionSheetAction(
//                                     child: const Text('ml'),
//                                     onPressed: () {
//                                       setState(() {
//                                         _selectedDosage = 'ml';
//                                       });
//                                       Navigator.pop(context);
//                                     },
//                                   ),
//                                   CupertinoActionSheetAction(
//                                     child: const Text('Drops'),
//                                     onPressed: () {
//                                       setState(() {
//                                         _selectedDosage = 'Drops';
//                                       });
//                                       Navigator.pop(context);
//                                     },
//                                   ),
//                                 ],
//                                 cancelButton: CupertinoActionSheetAction(
//                                   child: const Text('Cancel'),
//                                   isDefaultAction: true,
//                                   onPressed: () {
//                                     Navigator.pop(context);
//                                   },
//                                 ),
//                               ),
//                             );
//                           },
//                           child: Row(
//                             children: [
//                               Text('Selected Unit: $_selectedDosage'),
//                               const Icon(CupertinoIcons.chevron_down),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),

//               Row(
//                 children: [
//                   Text(
//                     'No. of days:',
//                     style: TextStyle(
//                       fontSize: 16.0,
//                       color: Colors.black,
//                     ),
//                   ),
//                   const SizedBox(width: 8.0),
//                   Flexible(
//                     child: CupertinoTextField(
//                       controller:
//                           _daysController, // Your controller to manage the input value
//                       keyboardType:
//                           TextInputType.number, // Set keyboard type for numbers
//                       placeholder: 'Enter days', // Placeholder text
//                       padding: EdgeInsets.all(8.0), // Adjust padding as needed
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(5.0),
//                         border: Border.all(color: CupertinoColors.systemGrey4),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               Row(
//                 children: [
//                   CupertinoSwitch(
//                     value: _isCheckedMorning,
//                     onChanged: (bool newValue) {
//                       setState(() {
//                         _isCheckedMorning = newValue;
//                       });
//                     },
//                   ),
//                   const SizedBox(width: 8.0),
//                   Flexible(
//                     child: Text(
//                       'Morning',
//                       style: TextStyle(
//                         fontSize: 18.0, // Increase the font size as needed
//                       ),
//                       overflow: TextOverflow
//                           .ellipsis, // Handle overflow with ellipsis
//                     ),
//                   ),
//                   const SizedBox(width: 8.0),
//                   CupertinoSwitch(
//                     value: _isCheckedNoon,
//                     onChanged: (bool newValue) {
//                       setState(() {
//                         _isCheckedNoon = newValue;
//                       });
//                     },
//                   ),
//                   const SizedBox(width: 8.0),
//                   Flexible(
//                     child: Text(
//                       'Noon',
//                       style: TextStyle(
//                         fontSize: 18.0,
//                       ),
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                   const SizedBox(width: 8.0),
//                   CupertinoSwitch(
//                     value: _isCheckedEvening,
//                     onChanged: (bool newValue) {
//                       setState(() {
//                         _isCheckedEvening = newValue;
//                       });
//                     },
//                   ),
//                   const SizedBox(width: 8.0),
//                   Flexible(
//                     child: Text(
//                       'Evening',
//                       style: TextStyle(
//                         fontSize: 18.0,
//                       ),
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                   const SizedBox(width: 8.0),
//                   CupertinoSwitch(
//                     value: _isCheckedNight,
//                     onChanged: (bool newValue) {
//                       setState(() {
//                         _isCheckedNight = newValue;
//                       });
//                     },
//                   ),
//                   const SizedBox(width: 8.0),
//                   Flexible(
//                     child: Text(
//                       'Night',
//                       style: TextStyle(
//                         fontSize: 18.0,
//                       ),
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                 ],
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
