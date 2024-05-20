import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class InventoryItem {
  final String id;
  final String brand;
  final String category;
  final String name;
  final int quantity;
  final double price;

  InventoryItem({
    required this.id,
    required this.brand,
    required this.category,
    required this.name,
    required this.quantity,
    required this.price,
  });

  factory InventoryItem.fromList(List<dynamic> list) {
    // Ensure type safety for each property
    return InventoryItem(
      id: list[0].toString(),
      brand: list[1].toString(),
      category: list[2].toString(),
      name: list[3].toString(),
      quantity: int.parse(list[4].toString()),
      price: double.parse(list[5].toString()),
    );
  }
}

class InventoryPage extends StatefulWidget {
  const InventoryPage({Key? key}) : super(key: key);

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _brandController = TextEditingController();
  final _categoryController = TextEditingController();
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();

  List<InventoryItem> _items = [];
  bool _showNewItemForm = false; // Flag to control form visibility
  String _selectedBrand = ''; // Add this line to define _selectedBrand
  String _selectedCategory = ''; // Add this line to define _selectedCategory
  List<InventoryItem> inventory = []; // Define the inventory list

  @override
  void initState() {
    super.initState();
    _getInventoryFromCSV();
  }

  Future<void> _getInventoryFromCSV() async {
    final csvString =
        await rootBundle.loadString('assets/sheets/priceList.csv');

    // Use the CsvToListConverter to parse the CSV string
    final csvData = const CsvToListConverter().convert(csvString);
    final items = csvData.skip(1).map((row) {
      // Skip header row
      return InventoryItem.fromList(row);
    }).toList();

    setState(() {
      _items = items;
    });
  }

  String? validateTextField(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required.'; // Error message for empty field
    }

    // Add additional validation logic here based on your needs...

    return null; // No error returned if validation passes
  }

  void _addNewItem() {
    print('step 1');

    if (_formKey.currentState!.validate()) {
      // Extract form values
      final name = _nameController.text;
      final brand = _brandController.text;
      final category = _categoryController.text;
      String quantityString = _quantityController.text;
      String priceString = _priceController.text;

      // Parse and handle potential errors
      int? quantity;
      double? price;
      try {
        quantity = int.parse(quantityString);
        price = double.parse(priceString);
      } catch (e) {
        // Show error message if parsing fails
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invalid quantity or price. Please enter numbers.'),
          ),
        );
        return; // Exit the function if parsing fails
      }
      print('step 2');

      // Create new inventory item (using parsed values)
      final newItem = InventoryItem(
        id: UniqueKey().toString(),
        name: name,
        brand: brand,
        category: category,
        quantity: quantity!,
        price: price!,
      );

      // Update state
      setState(() {
        print('step 3');

        _items.add(newItem);
        _showNewItemForm = false; // Hide form after successful submission
        // Clear form fields after successful submission (optional)
        _nameController.text = '';
        _brandController.text = '';
        _categoryController.text = '';
        _quantityController.text = '';
        _priceController.text = '';
      });
    }
  }

  Widget _addNewItemForm() {
    return Container(
      padding: const EdgeInsets.all(20.0), // Add padding around the form
      decoration: BoxDecoration(
        color:
            Colors.grey.shade50, // Use a lighter shade of teal for background
        borderRadius: BorderRadius.circular(10.0), // Add rounded corners
        border: Border(
          top: BorderSide(
            // Top border with thicker width
            color: Colors.teal.shade700,
            width: 6.0, // Set thickness for top border
          ),
          left: BorderSide(
            // Left side border
            color: Colors.teal.shade700,
            width: 2.0, // Set thickness for sides
          ),
          right: BorderSide(
            // Right side border
            color: Colors.teal.shade700,
            width: 2.0, // Set thickness for sides
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max, // Avoid unnecessary scrolling
        children: [
          // Title (optional)
          Text(
            'Add New Item',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.teal.shade900, // Use darker shade for text
            ),
          ),
          const SizedBox(height: 16.0), // Spacing between title and fields

          // Text fields with improved styling
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Name',
              labelStyle:
                  TextStyle(color: Colors.teal.shade700), // Adjust label color
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: Colors.grey.shade400), // Light teal border
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide:
                    BorderSide(color: Colors.teal), // Teal border on focus
              ),
            ),
            validator: validateTextField,
            onFieldSubmitted: (_) =>
                _formKey.currentState!.validate(), // Call validate on submit
          ),

          const SizedBox(height: 12.0), // Spacing between fields

          TextFormField(
            controller: _brandController,
            decoration: InputDecoration(
              labelText: 'Brand',
              labelStyle: TextStyle(color: Colors.teal.shade700),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: Colors.grey.shade400), // Light teal border
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.teal),
              ),
            ),
            validator: (value) {
              // Existing validation logic
            },
          ),
          const SizedBox(height: 12.0), // Spacing between fields

          TextFormField(
            controller: _categoryController,
            decoration: InputDecoration(
              labelText: 'Category',
              labelStyle: TextStyle(color: Colors.teal.shade700),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: Colors.grey.shade400), // Light teal border
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.teal),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'This field is required.'; // Error message for empty field
              }
              return null; // No error returned if validation passes
            },
          ),
          const SizedBox(height: 12.0), // Spacing between fields

          TextFormField(
            controller: _quantityController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Quantity',
              labelStyle: TextStyle(color: Colors.teal.shade700),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: Colors.grey.shade400), // Light teal border
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.teal),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'This field is required.'; // Error message for empty field
              }
              return null; // No error returned if validation passes
            },
          ),
          const SizedBox(height: 12.0), // Spacing between fields

          TextFormField(
            controller: _priceController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: 'Price',
              labelStyle: TextStyle(color: Colors.teal.shade700),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey.shade400, // Light teal border
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.teal),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'This field is required.'; // Error message for empty field
              }
              return null; // No error returned if validation passes
              // Existing validation logic
            },
            onChanged: (String priceString) {
              // Perform basic validation or update UI based on price

              // Example 1: Check if the entered value is a valid double
              if (double.tryParse(priceString) == null) {
                // Show error message (consider using setState to update a UI element)
                // This could be a separate function to improve code organization.
              } else {
                // Hide error message (if shown previously)
              }
            },
          ),

          const SizedBox(height: 16.0), // Spacing before button

          ElevatedButton(
            onPressed: () {
              print('button pressed');

              if (_formKey.currentState != null &&
                  _formKey.currentState!.validate()) {
                _addNewItem(); // Call the _addNewItem function
              }
              print('2 press');
            },
            child: const Text('Add Item'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.teal, // Set text color to white
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(10.0), // Rounded button corners
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _getInventoryFromCSV,
          ),
        ],
      ),
      body: _items.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal, // Specify horizontal scrolling
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('ID')),
                  DataColumn(label: Text('Brand')),
                  DataColumn(label: Text('Category')),
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Quantity')),
                  DataColumn(label: Text('Price')),
                ],
                rows: _items.take(10).map((item) {
                  // Show only the first 10 items
                  return DataRow(cells: [
                    DataCell(Text(item.id)),
                    DataCell(Text(item.brand)),
                    DataCell(Text(item.category)),
                    DataCell(Text(item.name)),
                    DataCell(Text(item.quantity.toString())),
                    DataCell(Text(item.price.toString())),
                  ]);
                }).toList(),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            // Show the form when FAB is pressed
            _showNewItemForm = true;
          });
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.blue, // You can customize the color (optional)
      ),

// ... other code

      bottomNavigationBar: _showNewItemForm
          ? _addNewItemForm() // Build and display the form
          : null,
    );
  }
}
