import 'package:flutter/material.dart';
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(


      body: Container(
        padding: EdgeInsets.only(top:60.0, left: 20.0,),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(gradient: LinearGradient(colors: [Color(0xffe3e6ff),Color(0xfff1f3ff), Colors.white], begin: Alignment.topLeft,end:Alignment.bottomRight )),
        child: Column(
          crossAxisAlignment:  CrossAxisAlignment.start,
          children: [

        Row(
          children: [
            Icon(Icons.location_on_outlined),
            Text("Sylhet", style: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.w500),),
            ],
        ),


            SizedBox(height: 20.0,),
            Text("Hello, XYZ", style: TextStyle(color: Colors.black, fontSize: 25.0, fontWeight: FontWeight.bold),
            ),




            SizedBox(height: 20.0,),
            Container(
              margin: EdgeInsets.only(right: 20.0),
padding: EdgeInsets.only(left: 20.0),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: TextField(

                decoration: InputDecoration(
                    suffixIcon: Icon(Icons.search_off_outlined,),
                    border: InputBorder.none,
                    hintText: "Search a Product"
                ),
              ),
            ),
            SizedBox(height: 30.0,),
            Container(
              height: 180,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Container(
                    margin :EdgeInsets.only(bottom: 5.0),
                    child: Material(
                      elevation :3.0,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width : 190 ,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                                    Image.asset("images/elec.png", height: 50,width: 50,fit: BoxFit.cover,),
                          Text("Mobile & Gadget",style: TextStyle(color: Colors.black,fontSize: 20.0),
                          ),
                        ],),
                      ),
                    ),
                  ),
SizedBox(width: 20.0,),
                  Container(
                    margin :EdgeInsets.only(bottom: 5.0),
                    child: Material(

                      elevation :3.0,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width : 190 ,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            Image.asset("images/laptop-screen.png", height: 50,width: 50,fit: BoxFit.cover,),
                            Text("Tech Essentials",style: TextStyle(color: Colors.black,fontSize: 20.0),
                            ),
                          ],),
                      ),
                    ),
                  ),
                  SizedBox(width: 20.0,),
                  Container(
                    margin :EdgeInsets.only(bottom: 5.0),
                    child: Material(
                      elevation :3.0,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width : 190 ,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            Image.asset("images/plus.png", height: 50,width: 50,fit: BoxFit.cover,),
                            Text("Regular Utility Tools",style: TextStyle(color: Colors.black,fontSize: 20.0),
                            ),
                          ],),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0,),
            Text("All Products",style: TextStyle(color: Colors.black,fontSize: 20.0, fontWeight: FontWeight.bold)),
            ],
        ),
      ),
    );
  }
}
