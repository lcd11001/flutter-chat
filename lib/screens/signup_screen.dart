import 'package:chat/firebase/firebase_auth_helper.dart';
import 'package:chat/screens/form_validation_screen.dart';
import 'package:chat/widgets/user_image_picker.dart';

import 'package:flutter/material.dart';

class SignupScreen extends FormValidationScreen {
  const SignupScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

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
              UserImagePicker(
                radius: 80,
                pickedImage: (image) {
                  // ignore: avoid_print
                  print('pickedImage: ${image.path}');
                },
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
                          textInputAction: TextInputAction.next,
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
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Confirm Password',
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
                            if (!widget.isValidConfirmPassword(
                                value, _passwordController.text)) {
                              return 'Passwords do not match.';
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: _confirmPasswordController,
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
                            onPressed: _onSignUp,
                            child: const Text('Sign Up'),
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
                            onPressed: _openAuthScreen,
                            child: const Text('I have an account'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openAuthScreen() {
    Navigator.of(context).pop();
  }

  void _onSignUp() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    FirebaseAuthHelper()
        .createUserWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
      forceVerifyEmail: true,
    )
        .then(
      (user) {
        if (user != null) {
          widget.showSnackBar(context, 'Sign up successful: ${user.email}');
          Navigator.of(context).pop<Map<String, String>>(
            <String, String>{
              'email': _emailController.text,
              'password': _passwordController.text,
            },
          );
        } else {
          widget.showSnackBar(context, 'Sign up failed');
        }
      },
      onError: (e) {
        widget.showSnackBar(context, 'Sign up error: ${e.message ?? e}');
      },
    );
  }
}
