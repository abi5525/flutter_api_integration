import 'package:flutter/material.dart';
import 'package:login/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor:Color.fromARGB(255, 252, 25, 108),),
          useMaterial3: true,
        ),
        home: LoginPage());
  }
}

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();


  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email or Phone is required';
    }
    if (value != '1234') {
      return 'Invalid username';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value != '1234') {
      return 'Invalid password';
    }
    return null;
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
                Text("Login",style: TextStyle(fontSize: 40,fontWeight: FontWeight.w500)),
                SizedBox(height: 30,),
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username/Email',
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(10.0), // Rounded corners
                    ),
                  ),
                  validator: _validatePassword,
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true, // Password field
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(10.0), // Rounded corners
                    ),
                  ),
                  validator: _validatePassword,
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    // Handle login button press (validation etc.)
                    //  if (_formKey.currentState!.validate()) {
                    //             Navigator.pushReplacement(
                    //               context,
                    //               MaterialPageRoute(
                    //                   builder: (context) => HomePage()),
                    //             );
                    //           }

                     Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomePage()),
                                );
                  },
                  
                  child: Text('Login',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
                  style: ElevatedButton.styleFrom(
                                  backgroundColor: Color.fromARGB(255, 252, 25, 108),
                                  minimumSize: Size(100, 50),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                            ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
