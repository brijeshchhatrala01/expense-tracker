// ignore_for_file: unused_local_variable, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../model/usermodel.dart';

class AuthenticationService {
  //instance of firebaseauth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  //instance of firestore
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);
  //signup a user
  Future<void> signUpUser(String email, String password, String name) async {

    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        UserModel newUser = UserModel(
          uid: user.uid,
          name: name,
          email: email,
        );

        // Store user in Firestore
        await _firestore.collection("users").doc(user.uid).set(newUser.toMap());
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
  //logout
  Future<void> logoutUser() async {
    googleSignIn.signOut();
    return _firebaseAuth.signOut();
  }

  //allow existing user to signin
  Future<UserCredential> signInUser(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      //add user collection in database
      _firebaseFirestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
      }, SetOptions(merge: true));
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  //forgot password
  Future<void> sendLinkToResetPassword(String email) async {
    try {
      return _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  //signin with google
  Future<void> googleSignin(BuildContext context) async {
    try {
      GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        if (googleSignInAuthentication.accessToken != null) {
          AuthCredential authCredential = GoogleAuthProvider.credential(
            accessToken: googleSignInAuthentication.accessToken,
            idToken: googleSignInAuthentication.idToken,
          );
          UserCredential userCredential =
              await FirebaseAuth.instance.signInWithCredential(authCredential);
          User user = userCredential.user!;
          //add user collection in database
          UserModel googleUser = UserModel(
            uid: user.uid,
            name: user.displayName ?? '',
            email: user.email ?? '',
            photoUrl: user.photoURL,
          );

          // Save/update in Firestore
          await FirebaseFirestore.instance.collection('users').doc(user.uid).set(
            googleUser.toMap(),
            SetOptions(merge: true), // prevents overwriting
          );
                }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }
}
