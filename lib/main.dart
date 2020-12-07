import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:volunteers/src/widgets/nav_drawer.dart';
import 'package:volunteers/src/screens/map_screen.dart';
import 'package:volunteers/src/screens/about_screen.dart';
import 'package:volunteers/src/core/services/auth.dart';
import 'package:volunteers/src/core/viewmodels/app_state.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
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
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/map': (context) => MapScreen(),
        '/about': (context) => AboutScreen(),
      },
      builder: (context, child) {
        return Scaffold(
          drawer: NavDrawer(
            navigator: (child.key as GlobalKey<NavigatorState>),
          ),
          body: child,
        );
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Consumer<AppState>(
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
    );
  }
}
