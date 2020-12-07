import 'package:flutter/material.dart';

class RootScaffold {
  static openDrawer(BuildContext context) {
    final ScaffoldState scaffoldState = context.findRootAncestorStateOfType();
    scaffoldState.openDrawer();
  }

  static ScaffoldState of(BuildContext context) {
    final ScaffoldState scaffoldState = context.findRootAncestorStateOfType();
    return scaffoldState;
  }
}

class RootDrawer {
  static close(BuildContext context) {
    final DrawerControllerState drawerControllerState =
        context.findRootAncestorStateOfType();
    drawerControllerState.close();
  }

  static DrawerControllerState of(BuildContext context) {
    final DrawerControllerState drawerControllerState =
        context.findRootAncestorStateOfType();
    return drawerControllerState;
  }
}
