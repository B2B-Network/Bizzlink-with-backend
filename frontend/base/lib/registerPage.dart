import "package:base/routes.dart";
import "package:flutter/material.dart";
import "loginPage.dart";
import 'dart:async';
import 'dart:convert';
import "package:base/userid.dart";
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool changeButton = false;

  Service service = Service();

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
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController countryCodeController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  @override
  void initState() {
    countryCodeController.text = "91";
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;

  String errorMessage = "";

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color(0xFFF6F1F1),
      child: Form(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 80, left: 8, right: 8),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Register Now',
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
              Text(
                'Welcome user, please register to continue using our app',
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'Mplus1p',
                ),
              ),
              SizedBox(
                height: 35,
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
                        controller:firstNameController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Enter First Name",
                        ),
                      ),
                    ),
                  ],
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
                        controller: lastNameController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Enter Last Name",
                        ),
                      ),
                    ),
                  ],
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
                      width: 40,
                      child: TextField(
                        controller: countryCodeController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Text(
                      "|",
                      style: TextStyle(fontSize: 33, color: Colors.grey),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: TextField(
                          controller:mobileNumberController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Mobile Number",
                      ),
                    ))
                  ],
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
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Enter Email Id",
                        ),
                      ),
                    ),
                  ],
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
                        controller:usernameController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Enter User Name",
                        ),
                      ),
                    ),
                  ],
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
                        controller:passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Create password",
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
                        controller:confirmPasswordController,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Confirm password",
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
              errorMessage.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        errorMessage,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                        ),
                      ),
                    )
                  : SizedBox(),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 350,
                height: 45,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () async {
                        final RegExp passwordRegex = RegExp(
                          r'^(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#$%^&*(),.?":{}|<>])(.{8,})$',
                        );
                        if (!passwordRegex.hasMatch(passwordController.text)) {
                          setState(() {
                            errorMessage =
                                "Password must have at least 8 characters, "
                                "1 special character, and 1 capital letter.";
                          });
                          return;
                        }

                      if (passwordController.text != confirmPasswordController.text) {
                        setState(() {
                          errorMessage = "Passwords do not match";
                        });
                        return; // Exit the method if passwords do not match
                      }


                      var response = await service.saveUser(
                          firstNameController.text,
                          lastNameController.text,
                          emailController.text,
                          countryCodeController.text,
                          mobileNumberController.text,
                          usernameController.text,
                          passwordController.text,
                      );
                      if (response.statusCode == 200) {
                        // Registration successful, navigate to the homepage
                        Map<String, dynamic> responseData = json.decode(response.body);
                        int? userId = responseData['userId'];
                        if (userId != null) {
                        await UserPreferences.saveUserId(userId.toString());
                        Navigator.pushNamed(context, MyRoutes.homePage);
                        }
                        else {
                          // Display the error message to the user
                          String errorMessage = responseData['message'];
                          setState(() {
                              this.errorMessage = errorMessage;
                          });
                        }
                      } else {
                        // Handle registration failure (show error message, etc.)
                        print("Registration failed. Status code: ${response.statusCode}");
                        // You may want to show an error message to the user here
                      }
                    },
                    child: Text(
                      "Register",
                      style: TextStyle(
                        fontFamily: 'Mplus1p',
                        fontSize: 18,
                        color:Colors.blue[900],
                      ),
                    )),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
                child: Text(
                  'Already have an account, Login',
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

class Service {
  Future<http.Response> saveUser(
      String firstName,
      String lastName,
      String email,
      String countryCode,
      String mobileNumber,
      String username,
      String password) async {
    // Create uri
    //var uri = Uri.parse("http://localhost:3000/user/register");
    var uri = Uri.parse("http://172.17.73.110:3000/user/register");

    Map<String, String> headers = {"Content-Type": "application/json"};
    Map<String, dynamic> data = {
      'firstName': '$firstName',
      'lastName': '$lastName',
      'email': '$email',
      'countryCode': '$countryCode',
      'mobileNumber': '$mobileNumber',
      'username': '$username',
      'password': '$password',
    };

    var body = json.encode(data);
    var response = await http.post(uri, headers: headers, body: body);
    return response;
  }
}