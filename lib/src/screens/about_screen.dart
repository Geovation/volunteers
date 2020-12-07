import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:volunteers/src/utils/helpers/scaffold_helper.dart';
import 'package:volunteers/src/core/viewmodels/app_state.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
        leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => RootScaffold.openDrawer(context)),
        actions: <Widget>[
          if (FirebaseAuth.instance.currentUser != null)
            IconButton(
                icon: Icon(Icons.logout),
                tooltip: 'Log out',
                onPressed: () {
                  context.read<AppState>().signOut();
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                })
        ],
      ),
      body:
          Container(child: Text(FirebaseAuth.instance.currentUser.displayName)),
    );
  }
}
