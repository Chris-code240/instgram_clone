import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instgram_clone/resources/storage_methods.dart';
import 'package:instgram_clone/models/user.dart' as model;

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserdetails() async {
    User currentUser =
        _auth.currentUser!; // Non-null assertion operator used here
    String id = currentUser.uid;
    DocumentSnapshot documentSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(id).get();
    return model.User.fromSnapshotToUser(documentSnapshot);
  }

  //Signup function
  Future<String> signUpUser(
      {required String email,
      required String password,
      required String bio,
      required String username,
      required Uint8List file}) async {
    String res = "";

    try {
      if (file.isNotEmpty &&
          email.isNotEmpty &&
          password.isNotEmpty &&
          bio.isNotEmpty &&
          username.isNotEmpty) {
        //register user

        UserCredential userCredential = await _auth
            .createUserWithEmailAndPassword(email: email, password: password);

        String imageURL = await StorageMethods()
            .uploadToStorage('profilePictures', file, false);

        model.User user = model.User(
            username: username,
            uid: userCredential.user!.uid,
            bio: bio,
            email: email,
            followers: [],
            following: [],
            imageURL: imageURL);

        //add user to firestore database
        await _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(user.toJson());
        res = 'success';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> loginUser(
      {required String email, required String password}) async {
    String response = "";

    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);

        response = "success";
      }
    } on FirebaseAuthException catch (er) {
      if (er.code == 'wrong-password') {
        response = "Wrong Password";
      }
    } catch (e) {
      response = e.toString();
    }
    return response;
  }
}
