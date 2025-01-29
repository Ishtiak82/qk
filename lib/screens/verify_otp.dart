import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:qk/utils/utiils.dart';

import '../widgets/round_button.dart';
import 'fs_screens/fs_homepage.dart';
import 'home/homepage.dart';

class VerifyOtp extends StatefulWidget {

  final String verificationId ;
  const VerifyOtp({Key? key, required this.verificationId }):super(key:key);

  @override
  State<VerifyOtp> createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtp> {
  bool loading = false ;
  final OtpNumberController = TextEditingController();
  final auth = FirebaseAuth.instance ;
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(

        title: Text('Verify'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(

          children: [

            SizedBox(height: 70,
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              controller: OtpNumberController,
              decoration: InputDecoration(
                  hintText: '6 Digit OTP'
              ),


            ),
            SizedBox(height: 30,),
            RoundButton(title: 'Verify',loading: loading, onTap: ()async{

              setState(() {
                loading = true;
              });
           final  crendital = PhoneAuthProvider.credential(
               verificationId: widget.verificationId,
               smsCode: OtpNumberController.text.toString());


           try{
             await auth.signInWithCredential(crendital);
            // Navigator.push(context, MaterialPageRoute(builder: (context)=> HomePage()));
             Navigator.push(context, MaterialPageRoute(builder: (context)=> FireStoreHomePage()));
           }catch(e){

             setState(() {
               loading = false;
             });
             Utils().toastMessage(e.toString());
           }
            })

          ],
        ),
      ),
    );
  }
}
