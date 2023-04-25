// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/views/feedPage.dart';
import 'package:my_app/views/profilePage.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

bool darkMode = false;

IconData _iconLight = Icons.wb_sunny; // initializing a light mode icon
IconData _iconDark = Icons.nights_stay; // initializing a dark mode icon

ThemeData _lightTheme = ThemeData(
  primarySwatch: Colors.yellow,
  brightness: Brightness.light, // setting brightness for light mode
);

ThemeData _darkTheme = ThemeData(
  primarySwatch: Colors.red,
  brightness: Brightness.dark, // setting brightness for dark mode
  buttonTheme: const ButtonThemeData(
    buttonColor: Colors.amberAccent,
  ), // setting button color for dark mode
);

class homePage extends StatefulWidget {
  const homePage({Key? key}) : super(key: key);

  @override
  State<homePage> createState() => homePageState();
}

class homePageState extends State<homePage> {
  // Controller for student ID text field
  final _studentIdController = TextEditingController();
  // Controller for password text field
  final _passwordController = TextEditingController();
  bool _isLoginFormValid = false; // Flag to track if the login form is valid
  bool _darkMode = false; // Flag to track if dark mode is enabled

  @override
  void initState() {
    super.initState();
    _studentIdController.addListener(_updateLoginFormValidation);
    _passwordController.addListener(_updateLoginFormValidation);
  }

  void _updateLoginFormValidation() {
    setState(() {
      _isLoginFormValid = _studentIdController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _studentIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> loginUser(data) async {
    // Method to handle login logic and API request
    try {
      var request = await http.post(
        Uri.https('final-project-9a4f3.uc.r.appspot.com', '/login_student'),
        headers: {'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*'},
        body: jsonEncode(data),
      );

      var responseBody = jsonDecode(request.body);
      if (responseBody['success'] == true) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('student_id', _studentIdController.text);
        await prefs.setString('student_name', responseBody['student_name']);
        await prefs.setString('student_email', responseBody['student_email']);
        await Future.delayed(Duration(seconds: 2));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => feedPage()),
        );
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: 'Log in Successful!',
        );
      } else {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: 'Log In failed',
        );
      }
    } catch (e) {
      return jsonDecode('error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _darkMode ? _darkTheme : _lightTheme,
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'SPACETOSPACE',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  darkMode = !darkMode; // Toggles _darkMode variable when IconButton is pressed
                });
              },
              icon: Icon(darkMode ? _iconDark : _iconLight), // Icon selection based on _darkMode variable
            ),
          ],
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'WELCOME TO MY SPACETOSPACE',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                SizedBox(
                  width: 400,
                  child: TextFormField(
                    controller: _studentIdController,
                    decoration: InputDecoration(
                      hintText: 'Enter your student ID',
                      labelText: 'Student ID',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      icon: Icon(Icons.person_outline),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                SizedBox(
                  width: 400,
                  child: TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      hintText: 'Enter your password',
                      labelText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      icon: Icon(Icons.lock),
                    ),
                    obscureText: true,
                  ),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _isLoginFormValid
                      ? () async {
                          loginUser({
                            "student_id": _studentIdController.text,
                            "password": _passwordController.text,
                          });
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    padding:
                        EdgeInsets.symmetric(horizontal: 55.0, vertical: 16.0),
                    textStyle: TextStyle(fontSize: 15.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: Text('Log In'),
                ),
                SizedBox(height: 16.0),
                Text(
                  "If you don't have an account",
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => profilePage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          horizontal: 48.0, vertical: 16.0),
                      textStyle: TextStyle(fontSize: 15.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      )),
                  child: Text('Create Account'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
