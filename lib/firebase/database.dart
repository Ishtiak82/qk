import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class DatabaseMethods {





  Future addProduct (Map<String, dynamic>userInfoMap, String category)async{

    return await FirebaseFirestore.instance
        .collection(category)
        .add(userInfoMap);
  }


Future<Stream<QuerySnapshot>>getProducts(String category)async{

    return await FirebaseFirestore.instance.collection(category).snapshots();
}

}