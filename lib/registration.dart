import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  final List<File> _selectedImages = []; // List to store multiple images

  // Function to pick multiple images
  Future<void> pickImages() async {
    final pickedFiles = await ImagePicker().pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        _selectedImages.addAll(pickedFiles.map((e) => File(e.path)).toList());
      });
    }
  }

  // Upload images and get URLs
  Future<List<String?>> uploadImages(List<File> images) async {
    List<String?> imageUrls = [];
    try {
      for (var image in images) {
        String filePath = 'user_doc/${DateTime.now().millisecondsSinceEpoch}.png';
        UploadTask uploadTask = _storage.ref().child(filePath).putFile(image);
        TaskSnapshot snapshot = await uploadTask;
        String? downloadURL = await snapshot.ref.getDownloadURL();
        imageUrls.add(downloadURL);
      }
      return imageUrls;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload images: $e')),
      );
      return [];
    }
  }

  // Register user in Firebase Auth and Firestore
  Future<void> registerUser() async {
    if (_selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add your License.')),
      );
      return;
    }

    try {
      showDialog(
        context: context,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // Upload images and get URLs
      List<String?> imageUrls = await uploadImages(_selectedImages);

      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      await _firestore.collection("Users").doc(userCredential.user!.email).set({
        'email': _emailController.text,
        'name': _nameController.text,
        'role1': 'client',
        'imageURLs': imageUrls, // Storing image URLs in Firestore
      });

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration Successful. Press Back.')),
      );
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      String errorMessage;

      if (e.code == 'email-already-in-use') {
        errorMessage = 'This email is already registered.';
      } else if (e.code == 'weak-password') {
        errorMessage = 'The password provided is too weak.';
      } else {
        errorMessage = 'Registration failed. Please try again.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred. Please try again.')),
      );
    }
  }

  // Sign up with Google
  Future<void> signUpWithGoogle() async {
    if (_selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add your License.')),
      );
      return;
    }

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      // Upload images and get URLs
      List<String?> imageUrls = await uploadImages(_selectedImages);

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      if (userCredential.additionalUserInfo!.isNewUser) {
        await _firestore.collection('Users').doc(userCredential.user!.email).set({
          'email': userCredential.user!.email,
          'name': userCredential.user!.displayName,
          'role1': 'client',
          'imageURLs': imageUrls, // Storing image URLs in Firestore
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Google Sign-Up Successful!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        title: Text(
          'Registration Page',
          style: GoogleFonts.mulish(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    } else if (RegExp(r'[0-9]').hasMatch(value)) {
                      return 'Name should not contain numbers';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty || !value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    } else if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    } else if (!RegExp(r'(?=.*[A-Z])').hasMatch(value)) {
                      return 'Password must contain at least one uppercase letter';
                    } else if (!RegExp(r'(?=.*[a-z])').hasMatch(value)) {
                      return 'Password must contain at least one lowercase letter';
                    } else if (!RegExp(r'(?=.*\d)').hasMatch(value)) {
                      return 'Password must contain at least one number';
                    } else if (!RegExp(r'(?=.*[!@#$%^&*(),.?":{}|<>])').hasMatch(value)) {
                      return 'Password must contain at least one special character';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Confirm Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 25),
                _selectedImages.isEmpty
                    ? Text(
                        'Please add your License (Front & Back)',
                        style: GoogleFonts.mulish(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : Column(
                        children: _selectedImages
                            .map((image) => Image.file(image, height: 150))
                            .toList(),
                      ),
                const SizedBox(height: 5),
                ElevatedButton(
                  onPressed: pickImages,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent, // Background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Rounded corners
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16), // Vertical padding
                  ),
                  child: Text(
                    'Upload Images',
                    style: GoogleFonts.mulish(
                      color: Colors.white, // Text color
                      fontWeight: FontWeight.bold,
                      fontSize: 16, // Font size
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      registerUser();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey, // Background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Rounded corners
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16), // Vertical padding
                  ),
                  child: Text(
                    'Register',
                    style: GoogleFonts.mulish(
                      color: Colors.white, // Text color
                      fontWeight: FontWeight.bold,
                      fontSize: 16, // Font size
                    ),
                  ),
                ),

                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 1.5,
                          color: Colors.grey[400],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'OR',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 1.5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                ElevatedButton(
                  onPressed: signUpWithGoogle,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // Background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Rounded corners
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16), // Vertical padding
                  ),
                  child: Text(
                    'Sign Up with Google',
                    style: GoogleFonts.mulish(
                      color: Colors.white, // Text color
                      fontWeight: FontWeight.bold,
                      fontSize: 16, // Font size
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
