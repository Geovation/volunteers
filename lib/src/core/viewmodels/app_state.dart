import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:volunteers/src/core/services/auth.dart';

class AppState extends ChangeNotifier {
  AppLoginState _loginState;
  AppLoginState get loginState => _loginState;

  User _currentUser;
  User get currentUser => _currentUser;

  bool _isUserLoggedIn;
  bool get isUserLoggedIn => _isUserLoggedIn;

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
          'isAdmin': false,
        });
      } else {
        _loginState = AppLoginState.loggedOut;
      }
      _currentUser = FirebaseAuth.instance.currentUser;
      _isUserLoggedIn = _currentUser != null;
      notifyListeners();
    });
  }

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

  void signInWithGoogle(
    void Function(FirebaseAuthException e) errorCallback,
  ) async {
    try {
      if (kIsWeb) {
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        googleProvider
            .addScope('https://www.googleapis.com/auth/contacts.readonly');
        googleProvider.setCustomParameters({'login_hint': 'user@example.com'});
        await FirebaseAuth.instance.signInWithPopup(googleProvider);
      } else {
        final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
        // workaround: when user cancels google account selection dialog
        if (googleUser == null) return;
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final GoogleAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await FirebaseAuth.instance.signInWithCredential(credential);
      }
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }

  void signOut() {
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
