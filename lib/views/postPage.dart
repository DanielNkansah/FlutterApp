// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api, use_key_in_widget_constructors, prefer_const_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/widgets/navBar.dart';
import 'dart:convert';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'feedPage.dart';

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

class postPage extends StatefulWidget {
  @override
  postPageState createState() => postPageState();
}

class postPageState extends State<postPage> {
  final _postController = TextEditingController();

  bool _isPostValid = false;

  @override
  void initState() {
    super.initState();
    _postController.addListener(_updatePostValidation);
  }

  void _updatePostValidation() {
    setState(() {
      _isPostValid = _postController.text.isNotEmpty;
    });
  }

  Future<void> makePost(post) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? student_name = prefs.getString('student_name');
    final data = {"student_name": student_name, "post": post};

    // Send POST request to the server
    try {
      final response = await http.post(
          Uri.parse('https://final-project-9a4f3.uc.r.appspot.com/create_post'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(data));

      print(response.statusCode);
      if (response.statusCode == 201) {
        // Show success alert if response status code is 201
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: 'Post Sent Successfully!',
        );
      }
    } catch (e) {
      print("Failed registration: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: _iconBool ? _darkTheme : _lightTheme,
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Post Page'),
            actions: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _iconBool = !_iconBool;
                  });
                },
                icon: Icon(_iconBool ? _iconDark : _iconLight),
              ),
            ],
          ),
          drawer: navBar(),
          body: Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.5,
              margin: EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20,
                    width: 10,
                  ),
                  SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: TextField(
                      controller: _postController,
                      decoration: InputDecoration(
                        hintText: 'Enter your post',
                        labelText: 'New Post',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        icon: Icon(Icons.post_add),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _isPostValid
                        ? () {
                          // Call makePost method to send the post data to server
                            makePost (_postController.text);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => feedPage()),
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    child: const Text('Create Post'),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
