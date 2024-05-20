import 'package:flutter/material.dart';

class PharmacyBillingPage extends StatefulWidget {
  @override
  _PharmacyBillingPageState createState() => _PharmacyBillingPageState();
}

class _PharmacyBillingPageState extends State<PharmacyBillingPage> {
  final TextEditingController _medicineController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  List<Map<String, dynamic>> _medicines = [];
  double _totalAmount = 0.0;

  @override
  void dispose() {
    _medicineController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _addMedicine() {
    if (_medicineController.text.isNotEmpty &&
        _quantityController.text.isNotEmpty &&
        _priceController.text.isNotEmpty) {
      double quantity = double.parse(_quantityController.text);
      double price = double.parse(_priceController.text);
      double amount = quantity * price;

      setState(() {
        _medicines.add({
          'medicine': _medicineController.text,
          'quantity': quantity,
          'price': price,
          'amount': amount,
        });
        _totalAmount += amount;
      });

      _medicineController.clear();
      _quantityController.clear();
      _priceController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pharmacy Billing'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _medicineController,
              decoration: InputDecoration(
                labelText: 'Medicine Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _quantityController,
                    decoration: InputDecoration(
                      labelText: 'Quantity',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: TextField(
                    controller: _priceController,
                    decoration: InputDecoration(
                      labelText: 'Price',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _addMedicine,
              child: Text('Add Medicine'),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: _medicines.length,
                itemBuilder: (context, index) {
                  final medicine = _medicines[index];
                  return ListTile(
                    title: Text(medicine['medicine']),
                    subtitle: Text(
                        'Quantity: ${medicine['quantity']}, Price: \$${medicine['price']}'),
                    trailing:
                        Text('\$${medicine['amount'].toStringAsFixed(2)}'),
                  );
                },
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Total Amount: \$${_totalAmount.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
