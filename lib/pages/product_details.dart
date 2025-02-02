

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProductDetailsPage extends StatefulWidget {
  final DocumentSnapshot ds;

  ProductDetailsPage({required this.ds});

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  bool isSaved = false;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    checkIfSaved();
  }

  // Check if the product is already saved
  void checkIfSaved() async {
    String userId = auth.currentUser!.uid;
    String productId = widget.ds.id;

    var doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("Saved")
        .doc(productId)
        .get();

    if (doc.exists) {
      setState(() {
        isSaved = true;
      });
    }
  }

  // Save or Unsave Product
  void toggleSaveProduct() async {
    String userId = auth.currentUser!.uid;
    String productId = widget.ds.id;
    DocumentReference savedProductRef = FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("Saved")
        .doc(productId);

    if (isSaved) {
      // If already saved, remove it
      await savedProductRef.delete();
      setState(() {
        isSaved = false;
      });
    } else {
      // Save product details
      await savedProductRef.set({
        "Name": widget.ds["Name"],
        "Image": widget.ds["Image"],
        "Price": widget.ds["Price"],
        "Location": widget.ds["Location"],
        "Product Details": widget.ds["Product Details"],
        "Timestamp": FieldValue.serverTimestamp(),
      });
      setState(() {
        isSaved = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Product"),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              isSaved ? Icons.favorite : Icons.favorite_border,
              color: Colors.red,
            ),
            onPressed: toggleSaveProduct,
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              child: Image.network(
                widget.ds["Image"],
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Icon(Icons.image_not_supported, size: 100),
              ),
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xffe3e6ff), Color(0xfff1f3ff), Colors.white],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 5.0,
                    spreadRadius: 2.0,
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.ds["Name"],
                      style:
                      TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text("Location: ${widget.ds["Location"]}",
                      style: TextStyle(fontSize: 16, color: Colors.grey)),
                  SizedBox(height: 10),
                  Text(
                    widget.ds["Product Details"],
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("\৳${widget.ds["Price"]}",
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.green)),
                      ElevatedButton.icon(
                        onPressed: toggleSaveProduct,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isSaved ? Colors.red : Colors.blue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                        icon: Icon(
                          isSaved ? Icons.bookmark : Icons.bookmark_border,
                          color: Colors.white,
                        ),
                        label: Text(
                          isSaved ? "Unsave" : "Save",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
