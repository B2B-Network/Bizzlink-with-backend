import 'package:base/loginPage.dart';
import 'package:base/registerPage.dart';
import 'package:flutter/material.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          'assets/images/bg.jpeg', // Replace with your image path
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
        Material(
          color: Colors.transparent, // Make the Material widget transparent
          child: Center(
            child: Form(
              child: Padding(
                padding: const EdgeInsets.only(top: 230),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/bizzlink logo.png', // Your image path
                      width: 100, // Set the width as per your requirement
                      height: 100, // Set the height as per your requirement
                    ),
                    SizedBox(height: 10), // Adjust the spacing
                    Text(
                      'BizzLink',
                      style: TextStyle(
                        color: Color(0xFF0245A3),
                        fontSize: 44,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Mplus1p',
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Double the vision, double the impact',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Mplus1p',
                      ),
                    ),
                    SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: [
                          Container(
                            width: 150,
                            height: 50,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginPage()));
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue[900], 
                                ),
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'Mplus1p',
                                    color:Colors.grey[300],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          Container(
                            width: 150,
                            height: 50,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              RegisterPage()));
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue[900], // Set the background color
                                  ),
                                child: Text(
                                  'Register',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'Mplus1p',
                                    color:Colors.grey[300],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
