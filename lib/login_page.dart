import 'package:flutter/material.dart';
import 'dashboard_page.dart'
    as dashboard; // Assuming your dashboard is in a separate file

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
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
                    labelText: 'Username *',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your username';
                    }
                    _username = value; // Capture username for dummy login
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Password *',
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    _password = value; // Capture password for dummy login
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Simulate dummy login (replace with actual authentication)
                      if (_username == 'admin' && _password == 'password') {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => dashboard.DashboardPage()),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Invalid username or password'),
                          ),
                        );
                      }
                    }
                  },
                  child: Text('Login'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.teal,
                    minimumSize: Size(double.infinity, 48.0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
