import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:volunteers/src/core/viewmodels/app_state.dart';
import 'package:volunteers/src/utils/helpers/scaffold_helper.dart';

class NavDrawer extends StatelessWidget {
  final GlobalKey<NavigatorState> navigator;

  NavDrawer({Key key, this.navigator}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<AppState>().currentUser;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
              accountName: Text(currentUser.displayName ?? 'Not Provided'),
              accountEmail: Text(currentUser.email),
              currentAccountPicture: currentUser.photoURL != null
                  ? CircleAvatar(
                      backgroundImage: NetworkImage(currentUser.photoURL),
                    )
                  : Icon(Icons.account_circle, size: 80.0)),
          ListTile(
            leading: Icon(Icons.map),
            title: Text('Map'),
            onTap: () {
              navigator.currentState.pushNamed('/map');
              RootDrawer.close(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Profile'),
            onTap: () {
              navigator.currentState.pushNamed('/profile');
              RootDrawer.close(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.message),
            title: Text('Feedback'),
            onTap: () {
              navigator.currentState.pushNamed('/feedback');
              RootDrawer.close(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('About'),
            onTap: () {
              navigator.currentState.pushNamed('/about');
              RootDrawer.close(context);
            },
          ),
        ],
      ),
    );
  }
}
