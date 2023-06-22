import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reals/model/user_model.dart' as model;
import 'package:reals/resources/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.UserModel> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snapshot =
        await _firestore.collection('users').doc(currentUser.uid).get();
    return model.UserModel.fromSnap(snapshot);
  }

  // Signup user
  Future<String> signupUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = "error occurred";
    try {
      if (email.isNotEmpty &&
          password.isNotEmpty &&
          username.isNotEmpty &&
          bio.isNotEmpty) {
        // Register user with email and password
        UserCredential credentials = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        if (kDebugMode) {
          print(credentials.user!.uid);
        }

        // Upload profile picture to storage
        String photoUrl = await StorageMethods()
            .uploadImageToStorage("profilePicture", file, false);

        // Create a user model
        model.UserModel user = model.UserModel(
          username: username,
          uid: credentials.user!.uid,
          email: email,
          bio: bio,
          photoUrl: photoUrl,
          followers: [],
          following: [],
        );

        // Save user to Firestore database
        await _firestore
            .collection('users')
            .doc(credentials.user?.uid)
            .set(user.toJson());
        res = 'success';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  // Login user
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        // Sign in user with email and password
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = "success";
      } else {
        res = "enter all required fields";
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
