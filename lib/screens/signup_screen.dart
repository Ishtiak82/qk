import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qk/screens/auth/login_screen.dart';
import 'package:qk/utils/utiils.dart';
import 'package:qk/widgets/round_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController(); // Username field
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Firestore instance

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void signup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      loading = true;
    });

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Save user info to Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'username': usernameController.text.trim(), // Store username
        'email': emailController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      Utils().toastMessage("Signup successful!");

      // Navigate to login screen after 2 seconds
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      });
    } catch (e) {
      Utils().toastMessage(e.toString());
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Signup to QuarK',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFormField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    hintText: 'Username',
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a username';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'Email',
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: 'Password',
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 40),
                RoundButton(
                  title: 'Signup',
                  loading: loading,
                  onTap: signup,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()),
                        );
                      },
                      child: const Text('Login'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}




// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:qk/screens/auth/login_screen.dart';
// import 'package:qk/utils/utiils.dart';
// import 'package:qk/widgets/round_button.dart'; // Ensure this path is correct
//
// class SignupScreen extends StatefulWidget {
//   const SignupScreen({super.key});
//
//   @override
//   State<SignupScreen> createState() => _SignupScreenState();
// }
//
// class _SignupScreenState extends State<SignupScreen> {
//   bool loading = false;
//   final _formKey = GlobalKey<FormState>();
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   @override
//   void dispose() {
//     emailController.dispose();
//     passwordController.dispose();
//     super.dispose();
//   }
//
//   void signup() {
//     setState(() {
//       loading = true;
//     });
//     _auth
//         .createUserWithEmailAndPassword(
//         email: emailController.text.trim(),
//         password: passwordController.text.trim())
//         .then((value) {
//       Utils().toastMessage("Signup successful!");
//
//       // Navigate to login page after 2 seconds
//       Future.delayed(const Duration(seconds: 2), () {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const LoginScreen()),
//         );
//       });
//
//       setState(() {
//         loading = false;
//       });
//     }).onError((error, stackTrace) {
//       Utils().toastMessage(error.toString());
//       setState(() {
//         loading = false;
//       });
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         title: const Text(
//           'Signup to QuarK',
//           style: TextStyle(color: Colors.white),
//         ),
//
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 TextFormField(
//                   controller: emailController,
//                   keyboardType: TextInputType.emailAddress,
//                   decoration: const InputDecoration(
//                     hintText: 'Email',
//                     labelText: 'Email',
//                     border: OutlineInputBorder(),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your email';
//                     }
//                     if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
//                       return 'Please enter a valid email';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 20),
//                 TextFormField(
//                   controller: passwordController,
//                   obscureText: true,
//                   decoration: const InputDecoration(
//                     hintText: 'Password',
//                     labelText: 'Password',
//                     border: OutlineInputBorder(),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your password';
//                     }
//                     if (value.length < 6) {
//                       return 'Password must be at least 6 characters long';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 40),
//                 RoundButton(
//                   title: 'Signup',
//                   loading: loading,
//                   onTap: () {
//                     if (_formKey.currentState!.validate()) {
//                       signup();
//                     }
//                   },
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Text("Already have an account?"),
//                     TextButton(
//                       onPressed: () {
//                         Navigator.pushReplacement(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => const LoginScreen()),
//                         );
//                       },
//                       child: const Text('Login'),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
