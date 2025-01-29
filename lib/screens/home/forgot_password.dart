
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qk/utils/utiils.dart';
import 'package:qk/widgets/round_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {

  final emailController = TextEditingController();
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text('Forgot Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(

          children:[

            TextFormField(
              controller: emailController,
              decoration: InputDecoration(

                hintText: 'Email'
              ),

            ),
            SizedBox(height: 40,),
            RoundButton(title: 'Forgot', onTap: (){
auth.sendPasswordResetEmail(email: emailController.text.toString()).then((value){
  Utils().toastMessage('We have sent you an email, please check!');
}).onError((error , stackTrace){

  Utils().toastMessage(error.toString());
});

            })
          ]
        ),
      ),

    );
  }
}

