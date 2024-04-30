import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:login/main.dart';
import 'config.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool isNotValidate = false;

  void registerUser() async {
    if (_usernameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      var regBody = {
        "name": _usernameController.text,
        "email": _emailController.text,
        "password": _passwordController.text
      };

      var response = await http.post(Uri.parse(registration),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(regBody));

      var jsonResponse = jsonDecode(response.body);

      if (jsonResponse['status'] == 200) {
        final snackBar = SnackBar(
          backgroundColor: Colors.green,
          content: Text(jsonResponse['message'],style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.bold)),
          duration: Duration(
              seconds: 3), // Duration for which snackbar will be visible

        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }

      else{
        final snackBar = SnackBar(
          backgroundColor: Colors.red,
          content: Text(jsonResponse['message'],style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.bold),),
          duration: Duration(
              seconds: 3), // Duration for which snackbar will be visible

        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }


    } else {
      setState(() {
        isNotValidate = true;
      });
    }
  }

  // String? _validateUsername(String? value) {
  //   if (value == null || value.isEmpty) {
  //     return 'Email is required';
  //   }

  //   return null;
  // }

  // String? _validatePassword(String? value) {
  //   if (value == null || value.isEmpty) {
  //     return 'Password is required';
  //   }

  //   return null;
  // }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Register",
                    style:
                        TextStyle(fontSize: 40, fontWeight: FontWeight.w500)),
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    errorText: isNotValidate ? "enter username" : null,
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(10.0), // Rounded corners
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    errorText: isNotValidate ? "enter email" : null,
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(10.0), // Rounded corners
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true, // Password field
                  decoration: InputDecoration(
                    labelText: 'Password',
                    errorText: isNotValidate ? "enter username" : null,
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(10.0), // Rounded corners
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    //  Navigator.pushReplacement(
                    //               context,
                    //               MaterialPageRoute(
                    //                   builder: (context) => LoginPage()),
                    //             );

                    registerUser();
                  },
                  child: Text(
                    'Submit',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 252, 25, 108),
                      minimumSize: Size(100, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),

                // SizedBox(height: 10,),

                TextButton(onPressed: () {
                                       Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()),
                                );
                }, child: Text("Back To Login"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
