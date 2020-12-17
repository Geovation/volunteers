import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:volunteers/src/core/enums/app_state.dart';
import 'package:volunteers/src/core/models/feedback.dart';
import 'package:volunteers/src/core/models/user.dart' as UserModel;
import 'package:volunteers/src/core/services/firestore_service.dart';

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

  final _firestoreService = FirestoreService();

  AppState() {
    init();
  }

  void init() {
    FirebaseAuth.instance.userChanges().listen((user) async {
      if (user != null) {
        _loginState = AppLoginState.loggedIn;

        // Update user data
        _firestoreService.updateUser(user);

        // Set current user
        _currentUser = await _firestoreService.getUser(user.uid);
        _isUserLoggedIn = user != null;
        notifyListeners();

        // Listen to feedback if admin
        if (_currentUser.isAdmin) {
          if (_feedbackSubscription != null) _feedbackSubscription.cancel();
          _feedbackSubscription =
              _firestoreService.onFeedbackChanged().listen((snapshot) async {
            _feedbackMessages = [];
            await Future.forEach(snapshot.docs, (document) async {
              final feedbackUser =
                  await _firestoreService.getUser(document.data()['userId']);
              _feedbackMessages.add(
                FeedbackMessage(
                  user: feedbackUser,
                  message: document.data()['message'],
                  sentiment: document.data()['sentiment'],
                  timestamp: document.data()['timestamp'],
                ),
              );
            });
            notifyListeners();
          });
        }
      } else {
        _loginState = AppLoginState.loggedOut;
        _currentUser = null;
        _isUserLoggedIn = user != null;
        _feedbackMessages = [];
        _feedbackSubscription?.cancel();
        notifyListeners();
      }
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
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: email,
      );
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
      UserCredential credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await credential.user
          .updateProfile(displayName: firstName + ' ' + lastName);
      _firestoreService.createUser(
          credential.user.uid, email, firstName, lastName);
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }

  void cancel() {
    _loginState = AppLoginState.loggedOut;
    notifyListeners();
  }
}
