import 'package:chat/firebase/firebase_auth_helper.dart';
import 'package:chat/screens/auth_screen.dart';
import 'package:chat/screens/main_screen.dart';
import 'package:chat/utils/page_route_helper.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const MainApp(
      forceValidateEmail: kReleaseMode,
    ),
  );
}

class MainApp extends StatelessWidget {
  final bool forceValidateEmail;
  const MainApp({
    super.key,
    required this.forceValidateEmail,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StreamBuilder(
        stream: FirebaseAuthHelper().authStateChanges,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // debugPrint('snapshot.hasData: ${snapshot.hasData}');
          // debugPrint('snapshot.data: ${snapshot.data}');

          if (snapshot.hasData) {
            final user = snapshot.data;
            if (user != null && (!forceValidateEmail || user.emailVerified)) {
              // return const MainScreen();
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (child, animation) {
                  return PageRouteHelper.slideIn(child, animation);
                },
                child: const MainScreen(),
              );
            }
          }
          // return const AuthScreen();
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (child, animation) {
              return PageRouteHelper.slideIn(child, animation);
            },
            child: AuthScreen(
              forceValidateEmail: forceValidateEmail,
            ),
          );
        },
      ),
    );
  }
}
