import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qk/screens/verify_otp.dart';
import 'package:qk/utils/utiils.dart';
import 'package:qk/widgets/round_button.dart';

class LoginWithPhone extends StatefulWidget {
  const LoginWithPhone({super.key});

  @override
  State<LoginWithPhone> createState() => _LoginWithPhoneState();
}

class _LoginWithPhoneState extends State<LoginWithPhone> {
  bool loading = false;
  final phoneNumberController = TextEditingController();
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 70),
            TextFormField(
              keyboardType: TextInputType.phone,
              controller: phoneNumberController,
              decoration: const InputDecoration(
                hintText: 'Enter phone number (e.g., 1712345678)',
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            RoundButton(
              title: 'Login',
              loading: loading,
              onTap: () {
                setState(() {
                  loading = true;
                });

                String phoneNumber = '+880' + phoneNumberController.text.trim();

                // Validation for phone number
                if (phoneNumberController.text.isEmpty ||
                    phoneNumberController.text.length != 10) {
                  Utils().toastMessage("Please enter a valid phone number.");
                  setState(() {
                    loading = false;
                  });
                  return;
                }

                auth.verifyPhoneNumber(
                  phoneNumber: phoneNumber,
                  verificationCompleted: (PhoneAuthCredential credential) async {
                    setState(() {
                      loading = false;
                    });
                    try {
                      await auth.signInWithCredential(credential);
                      Utils().toastMessage("Phone number verified successfully!");
                    } catch (e) {
                      Utils().toastMessage(e.toString());
                    }
                  },
                  verificationFailed: (FirebaseAuthException e) {
                    setState(() {
                      loading = false;
                    });
                    Utils().toastMessage(e.message ?? "Verification failed.");
                  },
                  codeSent: (String verificationId, int? resendToken) {
                    setState(() {
                      loading = false;
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            VerifyOtp(verificationId: verificationId),
                      ),
                    );
                  },
                  codeAutoRetrievalTimeout: (String verificationId) {
                    Utils().toastMessage("Auto-retrieval timed out.");
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}






