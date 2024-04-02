import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class StorageMethods {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Future<String> uploadToStorage(
      String childName, Uint8List file, bool isPost) async {
    Reference reference = _firebaseStorage
        .ref()
        .child(childName)
        .child(_firebaseAuth.currentUser!.uid);

    if (isPost) {
      reference = _firebaseStorage
          .ref()
          .child(childName)
          .child(_firebaseAuth.currentUser!.uid)
          .child(Uuid().v1());
    }
    UploadTask uploadTask = reference.putData(file);

    TaskSnapshot taskSnapshot = await uploadTask;

    String downloadURL = await taskSnapshot.ref.getDownloadURL();
    return downloadURL;
  }
}
