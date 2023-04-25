// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'feedPage.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool _iconBool = false; // initializing a boolean variable

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

class profilePage extends StatefulWidget {
  const profilePage({Key? key}) : super(key: key);

  @override
  _profilePageState createState() => _profilePageState();
}

class _profilePageState extends State<profilePage> {
  final _studentIdController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _dateOfBirthController = TextEditingController();
  final _yearGroupController = TextEditingController();
  final _majorController = TextEditingController();
  final _campusResidenceController = TextEditingController();
  final _bestFoodController = TextEditingController();
  final _bestMovieController = TextEditingController();
  bool _isProfileFormValid = false;

  @override
  void initState() {
    super.initState();
    _studentIdController.addListener(_updateProfileFormValidation);
    _fullNameController.addListener(_updateProfileFormValidation);
    _emailController.addListener(_updateProfileFormValidation);
    _passwordController.addListener(_updateProfileFormValidation);
    _dateOfBirthController.addListener(_updateProfileFormValidation);
    _yearGroupController.addListener(_updateProfileFormValidation);
    _majorController.addListener(_updateProfileFormValidation);
    _campusResidenceController.addListener(_updateProfileFormValidation);
    _bestFoodController.addListener(_updateProfileFormValidation);
    _bestMovieController.addListener(_updateProfileFormValidation);
  }

  void _updateProfileFormValidation() {
    setState(() {
      _isProfileFormValid = _studentIdController.text.isNotEmpty &&
          _fullNameController.text.isNotEmpty &&
          _emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty &&
          _dateOfBirthController.text.isNotEmpty &&
          _yearGroupController.text.isNotEmpty &&
          _majorController.text.isNotEmpty &&
          _campusResidenceController.text.isNotEmpty &&
          _bestFoodController.text.isNotEmpty &&
          _bestMovieController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _studentIdController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _dateOfBirthController.dispose();
    _yearGroupController.dispose();
    _majorController.dispose();
    _campusResidenceController.dispose();
    _bestFoodController.dispose();
    _bestMovieController.dispose();
    super.dispose();
  }

  Future<void> createUser() async {
    final data = {
      "student_id": _studentIdController.text,
      "student_name": _fullNameController.text,
      "email": _emailController.text,
      "password": _passwordController.text,
      "dob": _dateOfBirthController.text,
      "year_group": _yearGroupController.text,
      "major": _majorController.text,
      "campus_side": _campusResidenceController.text,
      "best_food": _bestFoodController.text,
      "best_movie": _bestMovieController.text
    };

    // RESPONSE
    try {
      // Send a POST request to the specified URL with the given headers and body
      final response = await http.post(
          Uri.parse('https://final-project-9a4f3.uc.r.appspot.com/create_profile'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(data));

          // If the response status code is 201 (created)
      if (response.statusCode == 201) {
        // Get an instance of SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();

        // Store the value of _studentIdController.text with key 'student_id'
        await prefs.setString('student_id', _studentIdController.text);
        // Show a success alert with the given text
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: 'Profile Created Successfully!',
        );
      }
    } catch (e) {
      // Print an error message if the try block encounters an exception
      print("Failed: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _iconBool
          ? _darkTheme
          : _lightTheme, // switching theme based on boolean variable
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Create Profile'),
            actions: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _iconBool = !_iconBool; // toggling boolean variable
                  });
                },
                icon: Icon(_iconBool
                    ? _iconDark
                    : _iconLight), // switching icon based on boolean variable
              ),
            ],
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Container(
                  margin: EdgeInsets.all(16.0),
                  child: Container(
                    margin: EdgeInsets.fromLTRB(100, 0, 0, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 20),
                        TextFormField(
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
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _fullNameController,
                          decoration: InputDecoration(
                            hintText: 'Enter your full name',
                            labelText: 'Full Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            icon: Icon(Icons.person),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            hintText: 'Enter your email',
                            labelText: 'Email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            icon: Icon(Icons.mail),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
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
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _dateOfBirthController,
                          decoration: InputDecoration(
                            hintText: 'Enter your date of birth',
                            labelText: 'Date of Birth',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            icon: Icon(Icons.calendar_month),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _yearGroupController,
                          decoration: InputDecoration(
                            hintText: 'Enter your year group',
                            labelText: 'Year Group',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            icon: Icon(Icons.school),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _majorController,
                          decoration: InputDecoration(
                            hintText: 'Enter your major',
                            labelText: 'Major',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            icon: Icon(Icons.book),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _campusResidenceController,
                          decoration: InputDecoration(
                            hintText:
                                'Enter whether or not you have campus residence',
                            labelText: 'Campus Residence',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            icon: Icon(Icons.home),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _bestFoodController,
                          decoration: InputDecoration(
                            hintText: 'Enter your favorite food',
                            labelText: 'Best Food',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            icon: Icon(Icons.food_bank),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _bestMovieController,
                          decoration: InputDecoration(
                            hintText: 'Enter your favorite movie',
                            labelText: 'Best Movie',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            icon: Icon(Icons.movie),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _isProfileFormValid // If _isProfileFormValid is true, this function will be called on button press
                              ? () {
                                  createUser();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => feedPage()), // Defines the new page to navigate to, in this case, feedPage()
                                  );
                                }
                              : null, // If _isProfileFormValid is false, the button will be disabled (onPressed set to null)
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          child: Text('Register'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )),
    );
  }
}
