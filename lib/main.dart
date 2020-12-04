import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'authentication.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ApplicationState(),
      builder: (context, _) => App(),
    ),
  );
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Volunteers',
      theme: ThemeData(
        primaryColor: Color(0Xfff5a62b),
        textTheme: GoogleFonts.robotoTextTheme(
          Theme.of(context).textTheme,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isLogin = context.watch<ApplicationState>().loginState ==
        ApplicationLoginState.loggedIn;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: isLogin ? true : false,
        title: Text('Volunteers'),
        actions: <Widget>[
          if (isLogin)
            IconButton(
                icon: Icon(Icons.logout),
                tooltip: 'Log out',
                onPressed: () => context.read<ApplicationState>().signOut())
        ],
      ),
      body: Container(
        child: Consumer<ApplicationState>(
          builder: (context, appState, _) => Authentication(
            loginState: appState.loginState,
            signInWithEmailAndPassword: appState.signInWithEmailAndPassword,
            signOut: appState.signOut,
            startResetFlow: appState.startResetFlow,
            sendPasswordResetEmail: appState.sendPasswordResetEmail,
            startRegisterAccountFlow: appState.startRegisterFlow,
            registerAccount: appState.registerAccount,
            cancel: appState.cancel,
          ),
        ),
      ),
      drawer: isLogin
          ? Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  UserAccountsDrawerHeader(
                      accountName: Text(
                          FirebaseAuth.instance.currentUser.displayName ??
                              'Not Provided'),
                      accountEmail:
                          Text(FirebaseAuth.instance.currentUser.email),
                      currentAccountPicture: FirebaseAuth
                                  .instance.currentUser.photoURL !=
                              null
                          ? CircleAvatar(
                              backgroundImage: NetworkImage(
                                  FirebaseAuth.instance.currentUser.photoURL),
                            )
                          : Icon(Icons.account_circle, size: 80.0)),
                  ListTile(
                    leading: Icon(Icons.message),
                    title: Text('Feedback'),
                  ),
                  ListTile(
                    leading: Icon(Icons.account_circle),
                    title: Text('Profile'),
                  ),
                  ListTile(
                    leading: Icon(Icons.info),
                    title: Text('About'),
                  ),
                ],
              ),
            )
          : null,
    );
  }
}

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  Future<void> init() async {
    await Firebase.initializeApp();

    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loginState = ApplicationLoginState.loggedIn;

        // Update user data
        FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'displayName': user.displayName,
          'email': user.email,
          'photoURL': user.photoURL,
          'lastSeen': DateTime.now(),
        });
      } else {
        _loginState = ApplicationLoginState.loggedOut;
      }
      notifyListeners();
    });
  }

  ApplicationLoginState _loginState;
  ApplicationLoginState get loginState => _loginState;

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
    FirebaseAuth.instance.signOut();
  }

  void startResetFlow() {
    _loginState = ApplicationLoginState.resetPassword;
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
    _loginState = ApplicationLoginState.register;
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
    _loginState = ApplicationLoginState.loggedOut;
    notifyListeners();
  }
}
