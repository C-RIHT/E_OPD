import 'package:e_opd/inventory_page.dart';
import 'package:e_opd/patient_page.dart';
import 'package:e_opd/visit_entry.dart';
import 'package:e_opd/doctor_page.dart';
import 'package:flutter/material.dart';
import 'login_page.dart';
import 'signup_page.dart';
import 'dashboard_page.dart';
import 'patient_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.teal,
        textSelectionTheme: TextSelectionThemeData(
            cursorColor: Colors.teal), // Set cursor color
      ),
      home: LandingPage(),
    );
  }
}

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade700, Colors.tealAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: isLoading
              ? Image.asset('assets/logo/clinic_logo.png')
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // E-OPD title with colored text and rounded border
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white, // Background color for the text
                        borderRadius:
                            BorderRadius.circular(30.0), // Rounded corners
                        border: Border.all(
                          color: Colors.white, // Border color
                          width: 1.0, // Border width
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0), // Inner padding
                        child: Text(
                          'E-OPD',
                          style: TextStyle(
                            fontFamily:
                                'Roboto', // Change font family (optional)
                            fontWeight: FontWeight.bold,
                            fontSize: 36.0, // Adjust font size as needed
                            color: Colors.teal, // Text color (adjust as needed)
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Display the clinic logo image
                    Image.asset('assets/logo/clinic_logo.png'),
                    const SizedBox(height: 20),
                    // Login and Signup buttons with same size, bold font
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()),
                            );
                          },
                          child: Text(
                            'Login',
                            style: TextStyle(
                              fontFamily:
                                  'Roboto', // Change font family (optional)
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(150, 50),
                          ),
                        ),
                        const SizedBox(
                            height: 10), // Add spacing between buttons
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignupPage()),
                            );
                          },
                          child: Text(
                            'Signup',
                            style: TextStyle(
                              fontFamily:
                                  'Roboto', // Change font family (optional)
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(150, 50),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
