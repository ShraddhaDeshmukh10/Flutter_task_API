import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ListViewScreen extends StatefulWidget {
  @override
  _ListViewScreenState createState() => _ListViewScreenState();
}

class _ListViewScreenState extends State<ListViewScreen> {
  List users = [];

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    final response =
        await http.get(Uri.parse('https://gorest.co.in/public-api/users'));
    final responseBody = jsonDecode(response.body);
    setState(() {
      users = responseBody['data'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        'List View Of Employees',
        style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
      )),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
              Colors.blueAccent.shade200,
              Colors.white,
              Colors.blueAccent
            ])),
        child: ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return Card(
              child: ListTile(
                leading: Icon(Icons.person),
                title: Text(user['name']),
                subtitle: Text(user['email']),
              ),
            );
          },
        ),
      ),
    );
  }
}
