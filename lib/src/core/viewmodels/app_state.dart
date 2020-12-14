import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:volunteers/src/core/enums/app_state.dart';
import 'package:volunteers/src/core/models/feedback.dart';
import 'package:volunteers/src/core/models/user.dart' as UserModel;

class AppState extends ChangeNotifier {
  AppLoginState _loginState;
  AppLoginState get loginState => _loginState;

  UserModel.User _currentUser;
  UserModel.User get currentUser => _currentUser;

  bool _isUserLoggedIn;
  bool get isUserLoggedIn => _isUserLoggedIn;

  StreamSubscription<QuerySnapshot> _feedbackSubscription;
  List<FeedbackMessage> _feedbackMessages = [];
  List<FeedbackMessage> get feedbackMessages => _feedbackMessages;

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
        }, SetOptions(merge: true));

        // Set current user
        FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get()
            .then((value) {
          _currentUser = UserModel.User.fromData(value.data());
          _isUserLoggedIn = user != null;

          // Listen to feedback if admin
          if (_currentUser.isAdmin) {
            if (_feedbackSubscription != null) _feedbackSubscription.cancel();
            _feedbackSubscription = FirebaseFirestore.instance
                .collection('feedback')
                .orderBy('timestamp', descending: true)
                .snapshots()
                .listen((snapshot) async {
              _feedbackMessages = [];
              await Future.forEach(snapshot.docs, (document) async {
                print(document.data());
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(document.data()['userId'])
                    .get()
                    .then((value) {
                  _feedbackMessages.add(
                    FeedbackMessage(
                      user: UserModel.User.fromData(value.data()),
                      message: document.data()['message'],
                      sentiment: document.data()['sentiment'],
                      timestamp: document.data()['timestamp'],
                    ),
                  );
                });
              });
              notifyListeners();
            });
          }
        });
      } else {
        _loginState = AppLoginState.loggedOut;
        _currentUser = null;
        _isUserLoggedIn = user != null;
        _feedbackMessages = [];
        _feedbackSubscription?.cancel();
      }
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
        'uid': credential.user.uid,
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'isAdmin': false,
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
