import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qk/pages/bottomnav.dart';


import '../screens/auth/login_screen.dart';
import '../screens/fs_screens/fs_homepage.dart';
import '../screens/home/homepage.dart';


class SplashServices {
  void isLogin(BuildContext context) {

    final auth = FirebaseAuth.instance;
    final user= auth.currentUser;

    if( user != null){

      Timer(const Duration(seconds: 2), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BottomNav()),
         // MaterialPageRoute(builder: (context) => const HomePage()),
        );

      });
    } else{


      Timer(const Duration(seconds: 2), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );

      });
    }



  }
}