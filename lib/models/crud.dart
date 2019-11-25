import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class CrudMethods {
  bool isLoggedIn() {
    if (FirebaseAuth.instance.currentUser() != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> addData(profileData) async {
    if (isLoggedIn()) {
      Firestore.instance.collection('profile').add(profileData).catchError((e) {
        print(e);
      });
    }
  }

  Future<void> addLetter(letterData) async {
    if (isLoggedIn()) {
      Firestore.instance.collection('letters').add(letterData).catchError((e) {
        print(e);
      });
    }
  }
}