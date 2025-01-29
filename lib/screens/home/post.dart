import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:qk/utils/utiils.dart';
import 'package:qk/widgets/round_button.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final postContriller = TextEditingController();
  bool loading = false;
  final databaseref = FirebaseDatabase.instance.ref('Products');
  @override
  Widget build(BuildContext context) {
    return  Scaffold(

      appBar: AppBar(
        title:  Text('Add'),
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
               hintText: 'add product',
               border: OutlineInputBorder(),
             ),

           ),
            SizedBox(

              height: 30,
            ),
            RoundButton(title: 'Add Product',loading: loading,onTap: (){
setState(() {
  loading= true;
});

String id =DateTime.now().millisecondsSinceEpoch.toString();
databaseref.child(id).set({
  'title': postContriller.text.toString(),
  'id': id,
}).then((value){
  setState(() {
    loading= false;
  });
  Utils().toastMessage('product added');

}).onError((error,stackTrace){
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
