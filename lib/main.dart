import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:volunteers/src/core/services/firebase_auth_service.dart';
import 'package:volunteers/src/core/services/firestore_service.dart';
import 'package:volunteers/src/core/viewmodels/app_state.dart';
import 'package:volunteers/src/widgets/authentication.dart';
import 'package:volunteers/src/widgets/nav_drawer.dart';
import 'package:volunteers/src/screens/map_screen.dart';
import 'package:volunteers/src/screens/profile_screen.dart';
import 'package:volunteers/src/screens/feedback_screen.dart';
import 'package:volunteers/src/screens/about_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AppState()),
      Provider(create: (_) => FirebaseAuthService()),
      Provider(create: (_) => FirestoreService()),
    ],
    child: App(),
  ));
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
        '/profile': (context) => ProfileScreen(),
        '/feedback': (context) => FeedbackScreen(),
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
          signInWithGoogle: appState.signInWithGoogle,
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
