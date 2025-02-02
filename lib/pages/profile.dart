import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qk/screens/auth/login_screen.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  User? user;
  String? profilePicUrl;
  String username = "";
  String phone = "";

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    if (user != null) {
      DocumentSnapshot userData =
      await _firestore.collection("users").doc(user!.uid).get();

      if (userData.exists) {
        setState(() {
          username = userData["username"] ?? "No Name";
          phone = userData["phone"] ?? "No Phone";
          profilePicUrl = userData["profilePic"] ??
              "https://via.placeholder.com/150"; // Default image
        });
      }
    }
  }

  Future<void> _uploadProfilePicture() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File file = File(pickedFile.path);
      String fileName = "profile_${user!.uid}.jpg";

      try {
        TaskSnapshot snapshot =
        await _storage.ref("profile_pictures/$fileName").putFile(file);
        String downloadUrl = await snapshot.ref.getDownloadURL();

        await _firestore.collection("users").doc(user!.uid).update({
          "profilePic": downloadUrl,
        });

        setState(() {
          profilePicUrl = downloadUrl;
        });

        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Profile picture updated")));
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
      }
    }
  }

  void _logout() async {
    await _auth.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  void _deleteAccount() async {
    try {
      await _firestore.collection("users").doc(user!.uid).delete();
      await user!.delete();

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Account deleted successfully")));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error deleting account: ${e.toString()}")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Picture
            GestureDetector(
              onTap: _uploadProfilePicture,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(profilePicUrl ??
                    "https://via.placeholder.com/150"), // Default placeholder
                child: const Align(
                  alignment: Alignment.bottomRight,
                  child: CircleAvatar(
                    radius: 15,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.camera_alt, size: 20, color: Colors.blue),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // User Information
            Text(username,
                style: const TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold)),
            Text(phone,
                style: const TextStyle(
                    fontSize: 16, color: Colors.grey)),

            const SizedBox(height: 30),

            // Logout Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _logout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text("Logout",
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),

            const SizedBox(height: 10),

            // Delete Account Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _deleteAccount,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text("Delete Account",
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
