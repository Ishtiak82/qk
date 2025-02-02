import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qk/pages/bottomnav.dart';
import 'package:qk/utils/utiils.dart';
import 'package:qk/widgets/round_button.dart';
import 'fs_screens/fs_homepage.dart';

class VerifyOtp extends StatefulWidget {
  final String verificationId;
  const VerifyOtp({super.key, required this.verificationId});

  @override
  State<VerifyOtp> createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtp> {
  bool loading = false;
  final otpController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? username; // For storing the username

  void verifyOtp() async {
    setState(() {
      loading = true;
    });

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: otpController.text.trim(),
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);
      String uid = userCredential.user!.uid;

      // Check if user already exists in Firestore
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(uid).get();

      if (!userDoc.exists) {
        // New user: Ask for username
        await _showUsernameDialog(uid);
      }

      Utils().toastMessage("Login successful!");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BottomNav()),
      );
    } catch (e) {
      Utils().toastMessage(e.toString());
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> _showUsernameDialog(String uid) async {
    TextEditingController usernameController = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Enter Username"),
        content: TextField(
          controller: usernameController,
          decoration: const InputDecoration(hintText: "Enter your username"),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              if (usernameController.text.trim().isNotEmpty) {
                username = usernameController.text.trim();
                await _firestore.collection('users').doc(uid).set({
                  'uid': uid,
                  'username': username,
                  'phone': _auth.currentUser?.phoneNumber,
                  'createdAt': FieldValue.serverTimestamp(),
                });

                Navigator.pop(context);
              } else {
                Utils().toastMessage("Username cannot be empty.");
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify OTP')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              keyboardType: TextInputType.number,
              controller: otpController,
              decoration: const InputDecoration(
                hintText: 'Enter OTP',
                labelText: 'OTP',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            RoundButton(
              title: 'Verify',
              loading: loading,
              onTap: verifyOtp,
            ),
          ],
        ),
      ),
    );
  }
}




// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
// import 'package:qk/utils/utiils.dart';
//
// import '../widgets/round_button.dart';
// import 'fs_screens/fs_homepage.dart';
// import 'home/homepage.dart';
//
// class VerifyOtp extends StatefulWidget {
//
//   final String verificationId ;
//   const VerifyOtp({Key? key, required this.verificationId }):super(key:key);
//
//   @override
//   State<VerifyOtp> createState() => _VerifyOtpState();
// }
//
// class _VerifyOtpState extends State<VerifyOtp> {
//   bool loading = false ;
//   final OtpNumberController = TextEditingController();
//   final auth = FirebaseAuth.instance ;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//
//       appBar: AppBar(
//
//         title: Text('Verify'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20),
//         child: Column(
//
//           children: [
//
//             SizedBox(height: 70,
//             ),
//             TextFormField(
//               keyboardType: TextInputType.number,
//               controller: OtpNumberController,
//               decoration: InputDecoration(
//                   hintText: '6 Digit OTP'
//               ),
//
//
//             ),
//             SizedBox(height: 30,),
//             RoundButton(title: 'Verify',loading: loading, onTap: ()async{
//
//               setState(() {
//                 loading = true;
//               });
//            final  crendital = PhoneAuthProvider.credential(
//                verificationId: widget.verificationId,
//                smsCode: OtpNumberController.text.toString());
//
//
//            try{
//              await auth.signInWithCredential(crendital);
//             // Navigator.push(context, MaterialPageRoute(builder: (context)=> HomePage()));
//              Navigator.push(context, MaterialPageRoute(builder: (context)=> FireStoreHomePage()));
//            }catch(e){
//
//              setState(() {
//                loading = false;
//              });
//              Utils().toastMessage(e.toString());
//            }
//             })
//
//           ],
//         ),
//       ),
//     );
//   }
// }
