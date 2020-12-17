import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as AuthUser;
import 'package:volunteers/src/core/models/user.dart' as CustomUser;

class FirestoreService {
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> createUser(
      String uid, String email, String firstName, String lastName) {
    return db.collection('users').doc(uid).set({
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'isAdmin': false,
    });
  }

  Future<void> updateUser(AuthUser.User user) {
    return db.collection('users').doc(user.uid).set({
      'displayName': user.displayName,
      'email': user.email,
      'photoURL': user.photoURL,
      'lastSeen': DateTime.now(),
    }, SetOptions(merge: true));
  }

  Future<CustomUser.User> getUser(String uid) {
    return db
        .collection('users')
        .doc(uid)
        .get()
        .then((value) => CustomUser.User.fromJson(value.data()));
  }

  Stream<QuerySnapshot> onFeedbackChanged() {
    return db
        .collection('feedback')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<DocumentReference> addFeedbackMessage(
      String uid, String sentiment, String message) {
    return db.collection('feedback').add({
      'userId': uid,
      'sentiment': sentiment,
      'message': message,
      'timestamp': DateTime.now(),
    });
  }
}
