import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:volunteers/src/core/viewmodels/app_state.dart';
import 'package:volunteers/src/utils/helpers/scaffold_helper.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  CustomAppBar({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () => RootScaffold.openDrawer(context)),
      actions: <Widget>[
        if (context.watch<AppState>().currentUser != null)
          IconButton(
              icon: Icon(Icons.logout),
              tooltip: 'Log out',
              onPressed: () {
                context.read<AppState>().signOut();
                Navigator.popUntil(context, ModalRoute.withName('/'));
              })
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
