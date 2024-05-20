import 'package:flutter/material.dart';
import 'package:e_opd/doctor_page.dart';

// Assuming your doctor page is named doctor_page.dart
import 'patient_page.dart';
import 'inventory_page.dart';
import 'pharmacy_billing.dart';
import 'lab_page.dart';

class InventoryItem {
  final String name;
  final int quantity;
  final double unitPrice;

  const InventoryItem({
    required this.name,
    required this.quantity,
    required this.unitPrice,
  });
}

class InventoryCard extends StatelessWidget {
  final InventoryItem item;

  const InventoryCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Handle inventory item tap (navigate to inventory page)
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => InventoryPage()),
        );
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(item.name,
                  style:
                      TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
              SizedBox(height: 8.0),
              Row(
                children: [
                  Text('Quantity: ₹{item.quantity}'),
                  Spacer(),
                  Text('Unit Price: \₹' +
                      item.unitPrice.toStringAsFixed(2)), // Format price
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserRoleCard extends StatelessWidget {
  final String role;
  final Map<String, Widget> roleToPageMap; // Required map for navigation

  const UserRoleCard({required this.role, required this.roleToPageMap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        final destinationPage = roleToPageMap[role];
        if (destinationPage != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destinationPage!),
          );
        }
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(role,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<String> userRoles = [
      'Doctors',
      'Nurse 1',
      'Nurse 2',
      'Pharmacist',
      'Lab Technician',
    ];
    final Map<String, Widget> roleToPageMap = {
      'Doctors': DoctorPage(), // Replace with your DoctorPage widget
      'Nurse 1':
          PatientPage(), // Replace with your PatientListPage widget (if applicable)
      'Nurse 2':
          PatientPage(), // Replace with your PatientListPage widget (if applicable)
      'Lab Technician': LabPage(), // Replace with your LabPage widget
      'Pharmacist':
          PharmacyBillingPage(), // Replace with your PharmacyBillingPage widget
    };
    final List<InventoryItem> inventoryList = [
      InventoryItem(name: 'Medicine A', quantity: 50, unitPrice: 10.00),
      InventoryItem(name: 'Bandage', quantity: 20, unitPrice: 5.00),
      InventoryItem(name: 'Antiseptic Solution', quantity: 30, unitPrice: 8.00),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Users and Roles list (Horizontal Scroll)
              Text('Users'),
              SizedBox(height: 16.0),
              Container(
                height: 150.0, // Adjust height as needed
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: userRoles.length,
                  itemBuilder: (context, index) {
                    return UserRoleCard(
                      role: userRoles[index],
                      roleToPageMap: roleToPageMap,
                    );
                  },
                ),
              ),
              Text('Inventory Details'),
              SizedBox(height: 16.0),
              Container(
                height: 200.0, // Adjust height as needed
                child: ListView.builder(
                  itemCount: inventoryList.length,
                  itemBuilder: (context, index) {
                    final item = inventoryList[index];
                    return InventoryCard(item: item);
                  },
                ),
              ),
              // ... other sections of your dashboard (Recent Patients, Inventory List)
            ],
          ),
        ),
      ),
    );
  }
}

class PatientCard extends StatelessWidget {
  final String name;

  const PatientCard({required this.name});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(name),
      ),
    );
  }
}
