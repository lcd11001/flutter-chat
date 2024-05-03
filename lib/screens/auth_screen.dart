import 'package:chat/screens/signup_screen.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(
                  top: 30,
                  bottom: 20,
                  left: 20,
                  right: 20,
                ),
                width: 200,
                child: Image.asset(
                  'assets/images/chat.png',
                  fit: BoxFit.cover,
                ),
              ),
              Card(
                margin: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 20,
                  bottom: 30,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Email Address',
                          ),
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          autocorrect: false,
                          textCapitalization: TextCapitalization.none,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Password',
                          ),
                          obscureText: true,
                          keyboardType: TextInputType.visiblePassword,
                          textInputAction: TextInputAction.done,
                          autocorrect: false,
                          textCapitalization: TextCapitalization.none,
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: 200,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorScheme.primary,
                              foregroundColor: colorScheme.onPrimary,
                            ),
                            onPressed: () {},
                            child: const Text('Login'),
                          ),
                        ),
                        SizedBox(
                          width: 200,
                          height: 50,
                          child: TextButton(
                            style: ButtonStyle(
                              overlayColor: MaterialStateProperty.resolveWith(
                                (states) {
                                  if (states.contains(MaterialState.hovered) ||
                                      states.contains(MaterialState.pressed)) {
                                    return Colors.transparent;
                                  }
                                  return null;
                                },
                              ),
                            ),
                            onPressed: _openSignupScreen,
                            child: const Text('Create new account'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _openSignupScreen() {
    Navigator.of(context).push(
      PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return const SignupScreen();
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = const Offset(0.0, 1.0);
            var end = Offset.zero;
            var curve = Curves.easeInOut;
            var tween = Tween(
              begin: begin,
              end: end,
            ).chain(
              CurveTween(
                curve: curve,
              ),
            );
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 500)),
    );
  }
}
