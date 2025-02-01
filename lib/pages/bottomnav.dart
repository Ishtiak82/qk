import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:qk/pages/profile.dart';

import 'booking.dart';
import 'home.dart';
class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  late List<Widget>pages;
  late Home home ;
  late Booking booking;
  late Profile profile;
  int currentTabindex =0;


  @override
  void initState() {
   home = Home();
   booking = Booking();
   profile = Profile();
   pages= [home,booking,profile];
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

     bottomNavigationBar: CurvedNavigationBar(
         height: 65,
         backgroundColor: Colors.white,
         color: Colors.black,
         animationDuration: Duration(milliseconds: 500),
         onTap: (int index){
           setState(() {
             currentTabindex=index;
           });
         },
         items:[
           Icon(Icons.home_outlined, color: Colors.white,size: 30.0,),
           Icon(Icons.book, color: Colors.white,size: 30.0,),
           Icon(Icons.person_outlined, color: Colors.white,size: 30.0,),

         ]),

body:pages[currentTabindex] ,

    );
  }
}
