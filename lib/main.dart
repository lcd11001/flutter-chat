import 'package:chat/firebase/firebase_auth_helper.dart';
import 'package:chat/screens/auth_screen.dart';
import 'package:chat/screens/main_screen.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StreamBuilder(
        stream: FirebaseAuthHelper().authStateChanges,
        builder: (ctx, snapshot) {
          debugPrint('authStateChanges: state ${snapshot.connectionState}');

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          debugPrint('authStateChanges: hasData ${snapshot.hasData}');
          debugPrint('authStateChanges: data ${snapshot.data}');

          if (snapshot.hasData) {
            final user = snapshot.data;
            if (user != null && user.emailVerified) {
              return const MainScreen();
            }
          }
          return const AuthScreen();
        },
      ),
    );
  }
}
