import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'login_page.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  bool _acceptTerms = false;
  //TODO: 1. add accept terms and conditions while signup, 2. Add the website navigation for the terms and conditions
  bool _phoneVerified = false;
  String _phoneNumber = '';
  String _selectedState = 'Unselected';
  String _otp = '123456'; // Add this line to define _otp

  Future<void> _showOtpDialog() async {
    // Validate phone number before showing OTP dialog
    if (_formKey.currentState!.validate()) {
      _otp = ''; // Reset OTP for new attempt
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Enter OTP'),
            content: OtpTextField(
              numberOfFields: 6,
              enabled: true,
              enabledBorderColor: Colors.teal, // Maintains teal border color
              showFieldAsBox: true,
              onCodeChanged: (String code) {
                setState(() {
                  _otp = code;
                });
              },
              onSubmit: (String verificationCode) {
                if (verificationCode == '123456') {
                  setState(() {
                    _phoneVerified = true;
                  });
                  Navigator.of(context).pop(); // Close OTP dialog
                } else {
                  // Show error message
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Invalid OTP'),
                        content: Text('Please try again.'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
          );
        },
      );
    }
  }

  void _handleFormSubmit() {
    if (_formKey.currentState!.validate()) {
      // Simulate form submission (replace with your actual logic)
      print('Form submitted successfully!');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Thank you'),
            content:
                Text('Our team will contact you shortly with credentials.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close alert dialog
                  // Replace with your actual navigation logic to login page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    //TODO: DO not make the page expand as per the device
    return Scaffold(
      appBar: AppBar(
        title: Text('Signup'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Applicant's Name *",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the applicant\'s name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Clinic / Hospital Name *',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the clinic/hospital name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Number of Staffs *',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the number of staffs';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Address *',
                  ),
                  maxLines: null,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the address';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Doctor Name *',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the doctor\'s name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Doctor Registration Number *',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the doctor\'s registration/MCI number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Doctor Registration State *',
                  ),
                  value: _selectedState,
                  onChanged: (value) {
                    setState(() {
                      _selectedState = value!;
                    });
                    _formKey.currentState!.validate(); // Trigger revalidation
                  },
                  items: [
                    DropdownMenuItem(
                        value: 'Unselected',
                        child: Text('Select a state of registration')),
                    DropdownMenuItem(
                        value: 'Andhra Pradesh', child: Text('Andhra Pradesh')),
                    DropdownMenuItem(value: 'Assam', child: Text('Assam')),
                    DropdownMenuItem(value: 'Bihar', child: Text('Bihar')),
                    // Add more states with unique values
                  ],
                  validator: (value) {
                    if (value == 'Unselected' || value!.isEmpty) {
                      return 'Please select the doctor\'s registration state';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Clinic Registration Number',
                  ),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Contact Number *',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the contact number';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _phoneNumber = value;
                    });
                  },
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed:
                      _phoneVerified ? _handleFormSubmit : _showOtpDialog,
                  child: Text(_phoneVerified ? 'Submit' : 'Verify'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.teal,
                    minimumSize: Size(double.infinity, 48.0),
                  ),
                ),
                if (_phoneVerified)
                  Text('Phone number verified: $_phoneNumber'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
