import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:login/config.dart';
import 'package:login/home.dart';
import 'package:login/register_page.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  String? token = prefs.getString('token');

  runApp(MyApp(token: token));
}

class MyApp extends StatelessWidget {
  final String? token;

  const MyApp({required this.token, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromARGB(255, 252, 25, 108),
        ),
        useMaterial3: true,
      ),
      home: token != null && !JwtDecoder.isExpired(token!) ? HomePage(token: token!) : LoginPage(),
    );
  }
}


class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late SharedPreferences prefs;
  bool isNotValidate = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSharedPref();
  }

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  void loginUser() async {
    if (_emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      var loginBody = {
        "email": _emailController.text,
        "password": _passwordController.text
      };

      var response = await http.post(Uri.parse(login),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(loginBody));

      var jsonResponse = jsonDecode(response.body);

      print(jsonResponse);

      if (jsonResponse['status'] == 200) {

          String myToken = jsonResponse['token'];
          // Map<String, dynamic> decodedToken = JwtDecoder.decode(yourToken);
          // print(decodedToken['email']);

          // print(jsonResponse['token']);
        print("logged in");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage(token: myToken,)),
          
        );
      } else {
        final snackBar = SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            jsonResponse['message'],
            style: TextStyle(
                color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
          ),
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
                Text("Login",
                    style:
                        TextStyle(fontSize: 40, fontWeight: FontWeight.w500)),
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    errorText: isNotValidate ? "Enter Email" : null,
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
                    errorText: isNotValidate ? "Enter Password" : null,
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(10.0), // Rounded corners
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    // Handle login button press (validation etc.)
                    // if (_formKey.currentState!.validate()) {
                    //   Navigator.pushReplacement(
                    //     context,
                    //     MaterialPageRoute(builder: (context) => HomePage()),
                    //   );
                    // }

                    //  Navigator.pushReplacement(
                    //               context,
                    //               MaterialPageRoute(
                    //                   builder: (context) => HomePage()),
                    //             );

                    loginUser();
                  },
                  child: Text(
                    'Login',
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

                TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => RegisterPage()));
                    },
                    child: Text("Register Here"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

