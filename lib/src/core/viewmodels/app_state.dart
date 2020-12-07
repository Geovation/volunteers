import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:volunteers/src/core/services/auth.dart';

class AppState extends ChangeNotifier {
  AppState() {
    init();
  }

  Future<void> init() async {
    await Firebase.initializeApp();

    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loginState = AppLoginState.loggedIn;

        // Update user data
        FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'displayName': user.displayName,
          'email': user.email,
          'photoURL': user.photoURL,
          'lastSeen': DateTime.now(),
        });
      } else {
        _loginState = AppLoginState.loggedOut;
      }
      notifyListeners();
    });
  }

  AppLoginState _loginState;
  AppLoginState get loginState => _loginState;

  void signInWithEmailAndPassword(
    String email,
    String password,
    void Function(FirebaseAuthException e) errorCallback,
  ) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }

  void signOut() {
    print('signOut...');
    FirebaseAuth.instance.signOut();
  }

  void startResetFlow() {
    _loginState = AppLoginState.resetPassword;
    notifyListeners();
  }

  void sendPasswordResetEmail(
    String email,
    void Function(FirebaseAuthException e) errorCallback,
  ) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }

  void startRegisterFlow() {
    _loginState = AppLoginState.register;
    notifyListeners();
  }

  void registerAccount(
      String email,
      String firstName,
      String lastName,
      String password,
      void Function(FirebaseAuthException e) errorCallback) async {
    try {
      var credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await credential.user
          .updateProfile(displayName: firstName + ' ' + lastName);
      FirebaseFirestore.instance
          .collection('users')
          .doc(credential.user.uid)
          .set({
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
      });
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }

  void cancel() {
    _loginState = AppLoginState.loggedOut;
    notifyListeners();
  }
}
