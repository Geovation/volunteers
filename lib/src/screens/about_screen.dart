import 'package:flutter/material.dart';
import 'package:volunteers/src/widgets/app_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'About'),
      body:
          Container(child: Text(FirebaseAuth.instance.currentUser.displayName)),
    );
  }
}
