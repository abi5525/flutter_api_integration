import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

String stringResponse = '';
Map mapResponse = {};
Map dataResponse = {};
List<dynamic> listResponse = []; // Use dynamic for flexibility
List<dynamic> filteredList = []; // Stores filtered results

bool isLoading = true;
String searchText = ''; // Stores the current search term

Widget buildLoading() {
  return Center(
    child: CircularProgressIndicator(),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> apiCall() async {
    http.Response response;

    response = await http.get(Uri.parse("https://reqres.in/api/users?page=2"));
    if (response.statusCode == 200) {
      setState(() {
        mapResponse = json.decode(response.body);
        listResponse = mapResponse["data"];
        filteredList = listResponse; // Initially show all data
        isLoading = false;
      });
    }
  }

  void filterUsers(String searchTerm) {
    filteredList = listResponse.where((user) {
      final firstName = user["first_name"].toString().toLowerCase();
      final lastName = user["last_name"].toString().toLowerCase();
      final fullName = firstName + ' ' + lastName;
      final email = user["email"].toString().toLowerCase();
      return fullName.toLowerCase().contains(searchTerm.toLowerCase()) ||
          email.toLowerCase().contains(searchTerm.toLowerCase());
    }).toList();
    setState(() {}); // Update UI with filtered results
  }

  @override
  void initState() {
    apiCall();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("User Profile",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          centerTitle: true,
          toolbarHeight: 80,
          backgroundColor: Color.fromARGB(255, 252, 25, 108),
          bottom: PreferredSize(
            preferredSize: Size(MediaQuery.of(context).size.width, 30.0),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 15),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search by name or email',
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
                  prefixIcon: Icon(
                    Icons.search,
                  ),
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(20.0), // Adjust radius as needed
                  ),
                ),
                onChanged: (value) {
                  searchText = value;
                  filterUsers(searchText);
                },
              ),
            ),
          ),
        ),
        body: isLoading
            ? buildLoading()
            : ListView.builder(
                itemBuilder: (context, index) {
                  final user = filteredList[index];
                  return Container(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.network(user["avatar"]),
                        ),
                        Text(user["id"].toString()),
                        Text(user["first_name"].toString() +
                            " " +
                            user["last_name"].toString()),
                        Text(user["email"].toString()),
                        Divider(),
                      ],
                    ),
                  );
                },
                itemCount: filteredList.length,
              ),
      ),
    );
  }
}
