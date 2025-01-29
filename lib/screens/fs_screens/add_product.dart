import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:qk/utils/utiils.dart';
import 'package:qk/widgets/round_button.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final postContriller = TextEditingController();
  bool loading = false;
  final firestore = FirebaseFirestore.instance.collection('products');

  @override
  Widget build(BuildContext context) {
    return  Scaffold(

      appBar: AppBar(
        title:  Text('Add Product'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(

          children: [
            SizedBox(

              height: 30,
            ),
            TextFormField(
              maxLines: 3,

              controller: postContriller,
              decoration: InputDecoration(
                hintText: 'List Product',
                border: OutlineInputBorder(),
              ),

            ),
            SizedBox(

              height: 30,
            ),
            RoundButton(title: 'Add ',loading: loading,onTap: (){
              setState(() {
                loading= true;
              });
              String id =DateTime.now().millisecondsSinceEpoch.toString();
        firestore.doc(id).set({
          'title' : postContriller.text.toString(),
          'id': id
        }).then((value){
          setState(() {
            loading= false;
          });
          Utils().toastMessage('Added');
              }).onError((error, stackTrace){
          setState(() {
            loading= false;
          });
                Utils().toastMessage(error.toString());
              });

              })


          ],
        ),
      ),


    );
  }
}
