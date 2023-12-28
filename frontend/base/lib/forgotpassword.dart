import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:math';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ResetPassword(),
    );
  }
}

class ResetPassword extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ResetPassword> {
  TextEditingController emailController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmNewPasswordController = TextEditingController();

  bool showOtpFields = false;
  bool showVerifyButton = false;
  bool showPasswordFields = false;
  bool showResetButton = false;

String generatedOtp = "";

  void _sendOTP() async {
    final email = emailController.text;
    final response =
        await http.get(Uri.parse('http://192.168.1.9:3000/user/checkEmail/$email'));

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);

      if (result['exists']) {
        // Generate and send OTP
        generatedOtp = _generateRandomOtp();
        _sendOtpEmail(email, generatedOtp);

        setState(() {
          showOtpFields = true;
          showVerifyButton = true;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'The email is invalid or does not exist.',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      // Handle other status codes
      print('Error: ${response.statusCode}');
    }
  }

void _verifyOTP() {
    final enteredOtp = otpController.text;

    if (enteredOtp == generatedOtp) {
      setState(() {
        showPasswordFields = true;
        showResetButton = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Invalid OTP.',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _generateRandomOtp() {
    // Generate a random 6-digit OTP
    final random = Random();
    return (100000 + random.nextInt(900000)).toString();
  }

void _sendOtpEmail(String toEmail, String otp) async {
  // Use your SMTP server configuration
  final smtpServer = gmailSaslXoauth2('b2bnetwork0@gmail.com', 'B2BNetwork@2000');

  // Create a message
  final message = Message()
    ..from = Address('b2bnetwork0@gmail.com', 'Bizzlink')
    ..recipients.add(toEmail)
    ..subject = 'Password Reset OTP'
    ..text = 'Please enter the following One Time Password in the Bizzlink Application to reset your password. Your One Time Password is: $otp';

  // Send the email
  try {
    final sendReport = await send(message, smtpServer);
    print('Email sent successfully: $sendReport');
  } catch (e) {
    print('Error sending email: $e');
  }
}




  void _resetPassword() {
    // Implement your password reset logic here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0245A3),
        iconTheme: IconThemeData(color: Colors.grey[300]),
        title: Text("Reset Password",
        style: TextStyle(
          color: Colors.grey[300],
          fontSize:25, // Set the text color to white
        ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ListView(
                shrinkWrap: true,
                children: [
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: _sendOTP,
                    child: Text('Send One Time Password'),
                  ),
                  if (showOtpFields) ...[
                    SizedBox(height: 20.0),
                    TextFormField(
                      controller: otpController,
                      decoration: InputDecoration(labelText: 'One Time Password'),
                    ),
                    if (showVerifyButton) ...[
                      SizedBox(height: 20.0),
                      ElevatedButton(
                        onPressed: _verifyOTP,
                        child: Text('Verify OTP'),
                      ),
                      if (showPasswordFields) ...[
                        SizedBox(height: 20.0),
                        TextFormField(
                          controller: newPasswordController,
                          obscureText: true,
                          decoration: InputDecoration(labelText: 'New Password'),
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          controller: confirmNewPasswordController,
                          obscureText: true,
                          decoration: InputDecoration(labelText: 'Confirm New Password'),
                        ),
                        if (showResetButton) ...[
                          SizedBox(height: 20.0),
                          ElevatedButton(
                            onPressed: _resetPassword,
                            child: Text('Reset Password'),
                          ),
                        ],
                      ],
                    ],
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
