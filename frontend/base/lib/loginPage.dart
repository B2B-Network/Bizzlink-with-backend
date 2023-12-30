import 'package:base/registerPage.dart';
import 'package:base/routes.dart';
import 'package:base/userid.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:base/forgotpassword.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool changeButton = false;
  
  moveToHome(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        changeButton = true;
      });

      await Future.delayed(Duration(seconds: 1));
      await Navigator.pushNamed(context, MyRoutes.firstRoute);
      setState(() {
        changeButton = false;
      });
    }
  }

  String errorMessage = "";

  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

Future<void> _login() async {
  final String mobileNumber = mobileNumberController.text;
  final String password = passwordController.text;

  //final Uri uri = Uri.parse("http://localhost:3000/user/login");
  final Uri uri = Uri.parse("http://172.17.73.110:3000/user/login");

  Map<String, String> headers = {"Content-Type": "application/json"};
  Map<String, dynamic> data = {
    'mobileNumber': '$mobileNumber',
    'password': '$password',
  };

  var body = json.encode(data);
  var response = await http.post(uri, headers: headers, body: body);

  if (response.statusCode == 200) {

    final Map<String, dynamic> responseData = json.decode(response.body);

    final int? userId = responseData['userId'] as int?;
    await UserPreferences.saveUserId(userId.toString());
    Navigator.pushNamed(context, MyRoutes.homePage);
  } else {
    // Display an error message and clear input fields
    setState(() {
      errorMessage = "Incorrect mobile number or password";
      mobileNumberController.text = "";
      passwordController.text = "";
    });
  }
}


  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color(0xFFF6F1F1),
      child: Form(
        key: _formKey,
        child: Padding(
        padding: const EdgeInsets.only(top: 120, left: 8, right: 8),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(
                'assets/images/bizzlink logo.png',
                width: 150,
                height: 150,
              ),
              SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Login Now',
                  style: TextStyle(
                    color: Color(0xFF0245A3),
                    fontSize: 30,
                    fontFamily: 'Mplus1p',
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Please Login or Sign up to continue using the app',
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'Mplus1p',
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                height: 55,
                width: 350,
                decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Color(0xFF0245A3)),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextField(
                  controller: mobileNumberController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.phone, color: Colors.grey),
                    hintText: "Mobile Number",
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 55,
                width: 350,
                decoration: BoxDecoration(
                    border: Border.all(width: 2, color: Color(0xFF0245A3)),
                    borderRadius: BorderRadius.circular(15)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextField(
                        controller: passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Enter your password",
                          suffixIcon: IconButton(
                            icon: Icon(
                                _obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Color(0xFF0245A3)),
                            onPressed: () {
                              setState(() {
                                _obscureText =
                                    !_obscureText; // Toggle the visibility
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (errorMessage.isNotEmpty)
                Text(
                  errorMessage,
                  style: TextStyle(
                    color: Colors.red,
                    fontFamily: 'Mplus1p',
                  ),
                ),
              SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ResetPassword(),
              ),
            );

                  },
                  child: Text(
                    "Forgot Password",
                    style: TextStyle(
                      color: Colors.black,
                      decoration: TextDecoration.underline,
                      fontFamily: 'Mplus1p',
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              SizedBox(
                width: 350,
                height: 45,
                child: ElevatedButton(
                  
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                            
                    onPressed: () {
                          _login();
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(
                        fontFamily: 'Mplus1p',
                        fontSize: 18,
                        color:Colors.blue[900]
                      ),
                    )),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => RegisterPage()));
                },
                child: Text(
                  'Do not have an account? Register',
                  style: TextStyle(
                    color: Colors.black,
                    decoration: TextDecoration.underline,
                    fontFamily: 'Mplus1p',
                  ),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}