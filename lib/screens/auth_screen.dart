import 'package:chat/firebase/firebase_auth_helper.dart';
import 'package:chat/screens/form_validation_screen.dart';
import 'package:chat/screens/signup_screen.dart';
import 'package:chat/utils/page_route_helper.dart';

import 'package:flutter/material.dart';

class AuthScreen extends FormValidationScreen {
  const AuthScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

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
                    key: _formKey,
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
                          validator: (value) {
                            if (!widget.isValidEmail(value)) {
                              return 'Please enter a valid email address.';
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: _emailController,
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
                          validator: (value) {
                            if (!widget.isValidPassword(
                              value,
                              kRequiredLength,
                            )) {
                              return 'Password must be at least $kRequiredLength characters long.';
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: _passwordController,
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: 200,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorScheme.primaryContainer,
                              foregroundColor: colorScheme.onPrimaryContainer,
                            ),
                            onPressed: _onLogin,
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

  void _openSignupScreen() async {
    final signUpInfo = await Navigator.of(context).push(
      PageRouteHelper.slideInRoute<Map<String, String>>(
        const SignupScreen(),
        transitionType: PageTransitionType.slideInFromRight,
      ),
    );

    // debugPrint('signUpInfo: $signUpInfo');

    if (signUpInfo != null) {
      setState(() {
        _emailController.text = signUpInfo['email'] ?? '';
        _passwordController.text = signUpInfo['password'] ?? '';
      });
    }
  }

  void _onLogin() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    FirebaseAuthHelper()
        .signInWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
      forceVerifyEmail: true,
    )
        .then(
      (user) {
        if (user == null) {
          widget.showSnackBar(context, 'Login failed');
        }
      },
      onError: (e) {
        widget.showSnackBar(context, 'Login error: ${e.message ?? e}');
      },
    );
  }
}
