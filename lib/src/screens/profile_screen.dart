import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:volunteers/src/core/viewmodels/app_state.dart';
import 'package:volunteers/src/widgets/app_bar.dart';
import 'package:volunteers/src/widgets/widget.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<AppState>().currentUser;

    if (currentUser == null) {
      Navigator.popUntil(context, ModalRoute.withName('/'));
      return Container();
    }

    return Scaffold(
      appBar: CustomAppBar(title: 'Profile'),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              width: 350,
              padding: const EdgeInsets.all(35.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  currentUser.photoURL != null
                      ? CircleAvatar(
                          radius: 70.0,
                          backgroundImage: NetworkImage(currentUser.photoURL),
                        )
                      : Icon(Icons.account_circle, size: 80.0),
                  SizedBox(height: 25.0),
                  Paragraph(currentUser.displayName ?? ''),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.email_outlined, color: Colors.black54),
                      Paragraph(currentUser.email),
                    ],
                  ),
                  SizedBox(height: 25.0),
                  Divider(
                    height: 8,
                    thickness: 1,
                    indent: 8,
                    endIndent: 8,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 15.0),
                  Header('Interest'),
                  Paragraph('TODO'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
