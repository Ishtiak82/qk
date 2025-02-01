import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:qk/admin/upload_product.dart';
import 'package:qk/pages/bottomnav.dart';
import 'package:qk/pages/home.dart';
import 'package:qk/screens/signup_screen.dart';
import 'screens/splash_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        primarySwatch: Colors.deepPurple
      ),
      home: UploadProduct(),
    );
  }
}




