// ignore_for_file: prefer_const_constructors, prefer_final_fields, prefer_interpolation_to_compose_strings
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../widgets/navBar.dart';
import 'postPage.dart';

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
  ),
);


class feedPage extends StatefulWidget {
  @override
  _feedPageState createState() => _feedPageState();
}

class _feedPageState extends State<feedPage> {
  bool _iconBool = false;

  Query<Map<String, dynamic>> _postsCollection = FirebaseFirestore.instance
      .collection('Posts')
      .orderBy('createdat', descending: true); // Query to fetch posts from Firebase

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _iconBool ? _darkTheme : _lightTheme,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Feed Page'),
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  _iconBool = !_iconBool;
                });
              },
              icon: Icon(_iconBool ? Icons.dark_mode : Icons.light_mode),
            ),
          ],
        ),
        drawer: navBar(),
        body: StreamBuilder<QuerySnapshot>(
          
          stream: _postsCollection.snapshots(), // Stream to listen for changes in the posts collection in Firebase
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}'); // Show error message if snapshot has error
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            return ListView.builder(
              itemCount: snapshot.data!.docs.length, // Number of items in the snapshot
              itemBuilder: (BuildContext context, int index) { 
                Map<String, dynamic> data =
                    snapshot.data!.docs[index].data() as Map<String, dynamic>;
                String student_name = data['student_name'] ?? ''; // Get student name from the post data, default to empty string if not available
                String post = data['post'] ?? ''; // Get post content from the post data, default to empty string if not available


                return Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 8.0, horizontal: 300.0),
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Post made by ' + student_name,
                            style: TextStyle(
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            post,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: 'Add',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => postPage(),
              ),
            );
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
