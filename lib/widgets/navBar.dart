// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:my_app/views/homePage.dart';
import '../views/editPage.dart';
import '../views/feedPage.dart';
import '../views/viewProfilePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class navBar extends StatefulWidget {
  @override
  _navBarState createState() => _navBarState();
}

class _navBarState extends State<navBar> {
  final _studentNameController = TextEditingController();
  final _studentMailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getUser(); // Call the getUser() function when the state is initialized
  }

  Future<void> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance(); // Initialize SharedPreferences
    String? student_name = prefs.getString('student_name'); // Get the stored student name from SharedPreferences
    String? student_email = prefs.getString('student_email'); // Get the stored student email from SharedPreferences


    setState(() {
      _studentNameController.text = student_name!; // Set the text value of the student name controller to the stored student name
      _studentMailController.text = student_email!; // Set the text value of the student email controller to the stored student email
    });
    print(student_name);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(_studentNameController.text), // Account name
            accountEmail: Text(_studentMailController.text), // Account email
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text("Home"), // Title of the ListTile
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => feedPage()),
              );
              // Handle home icon onTap
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("View Profile"), // Title of the ListTile
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => viewProfilePage(studentId: '')),
              );
              // Handle view profile icon onTap
            },
          ),
          ListTile(
              leading: const Icon(Icons.edit),
              title: const Text("Edit Profile"), // Title of the ListTile
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => editProfilePage(studentId: '')),
                );
              }),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"), // Title of the ListTile
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => homePage()),
              );
              // Handle logout icon onTap
            },
          )
        ],
      ),
    );
  }
}
