import 'package:base/loginPage.dart';
import 'package:flutter/material.dart';
import 'firstPage.dart';
import 'routes.dart';
import 'homePage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:base/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: MyRoutes.firstRoute,
      routes: {
        "/": (context) => FirstPage(),
        MyRoutes.loginPage: (context) => LoginPage(),
        MyRoutes.homePage: (context) =>  HomePage(),
      },
    );
  }
}