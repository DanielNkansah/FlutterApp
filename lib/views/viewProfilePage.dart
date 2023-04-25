// // ignore_for_file: prefer_const_constructors

// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/widgets/navBar.dart';
import 'dart:convert';
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

class viewProfilePage extends StatefulWidget {
  final String studentId; // Pass the student ID as a parameter
  const viewProfilePage({Key? key, required this.studentId}) : super(key: key);

  @override
  _viewProfilePageState createState() => _viewProfilePageState();
}

class _viewProfilePageState extends State<viewProfilePage> {
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

  @override
  void initState() {
    super.initState();
    getUser();
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

  Future<void> getUser() async {
    final data = {
      "student_id": widget.studentId,
    };

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? student_id = prefs.getString('student_id');
    // RESPONSE
    try {
      final response = await http.get(
        Uri.parse(
            'https://final-project-9a4f3.uc.r.appspot.com/retrieve_profile?student_id=${student_id}'),
      );
      var responseData = jsonDecode(response.body);
      setState(() {
        _studentIdController.text = responseData["student_id"];
        _fullNameController.text = responseData["student_name"];
        _emailController.text = responseData['email'];
        _passwordController.text = responseData['password'];
        _dateOfBirthController.text = responseData['dob'];
        _yearGroupController.text = responseData['year_group'];
        _majorController.text = responseData['major'];
        _campusResidenceController.text = responseData['campus_side'];
        _bestFoodController.text = responseData['best_food'];
        _bestMovieController.text = responseData['best_movie'];
      });
    } catch (e) {
      print("Failed: $e"); // Prints the error message if the request fails
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _iconBool
          ? _darkTheme
          : _lightTheme, // switching theme based on boolean variable
      home: Scaffold(
          appBar: AppBar(
            title: Text('My Profile'),
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
          drawer: navBar(),
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
                        Text("Student ID"),
                        TextFormField(
                          controller: _studentIdController,
                          readOnly: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            icon: Icon(Icons.person_outline),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text("Full Name"),
                        TextFormField(
                          controller: _fullNameController,
                          readOnly: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            icon: Icon(Icons.person),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text("Email"),
                        TextFormField(
                          controller: _emailController,
                          readOnly: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            icon: Icon(Icons.mail),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text("Password(Hidden)"),
                        TextFormField(
                          controller: _passwordController,
                          readOnly: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            icon: Icon(Icons.lock),
                          ),
                          obscureText: true,
                        ),
                        SizedBox(height: 20),
                        Text("Date Of Birth"),
                        TextFormField(
                          controller: _dateOfBirthController,
                          readOnly: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            icon: Icon(Icons.calendar_month),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text("Year Group"),
                        TextFormField(
                          controller: _yearGroupController,
                          readOnly: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            icon: Icon(Icons.school),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text("Major"),
                        TextFormField(
                          controller: _majorController,
                          readOnly: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            icon: Icon(Icons.book),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text("Campus Residence"),
                        TextFormField(
                          controller: _campusResidenceController,
                          readOnly: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            icon: Icon(Icons.home),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text("Best Food"),
                        TextFormField(
                          controller: _bestFoodController,
                          readOnly: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            icon: Icon(Icons.food_bank),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text("Best Movie"),
                        TextFormField(
                          controller: _bestMovieController,
                          readOnly: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            icon: Icon(Icons.movie),
                          ),
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
