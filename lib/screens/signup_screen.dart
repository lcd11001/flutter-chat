import 'dart:io';

import 'package:chat/firebase/firebase_auth_helper.dart';
import 'package:chat/firebase/firebase_firestore_helper.dart';
import 'package:chat/firebase/firebase_storage_helper.dart';
import 'package:chat/models/user_avatars.dart';
import 'package:chat/screens/form_validation_screen.dart';
import 'package:chat/widgets/user_image_picker.dart';
import 'package:chat/models/user_info.dart';

import 'package:flutter/material.dart';

class SignupScreen extends FormValidationScreen {
  final bool forceValidateEmail;
  const SignupScreen({
    super.key,
    required this.forceValidateEmail,
  });

  @override
  State<StatefulWidget> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  File? _avatarImage;
  UserInfo? _userInfo;
  bool _isUploading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

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
                  _avatarImage = image;
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
                            labelText: 'Username',
                          ),
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          autocorrect: false,
                          textCapitalization: TextCapitalization.none,
                          validator: (value) {
                            if (!widget.isValidUsername(
                                value, kRequiredUsernameLength)) {
                              return 'Username must be at least $kRequiredUsernameLength characters long.';
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: _usernameController,
                        ),
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
                              kRequiredPasswordLength,
                            )) {
                              return 'Password must be at least $kRequiredPasswordLength characters long.';
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
                              kRequiredPasswordLength,
                            )) {
                              return 'Password must be at least $kRequiredPasswordLength characters long.';
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
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorScheme.primaryContainer,
                              foregroundColor: colorScheme.onPrimaryContainer,
                            ),
                            onPressed: _onSignUp,
                            icon: _isUploading
                                ? SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: colorScheme.onPrimaryContainer,
                                    ),
                                  )
                                : const Icon(Icons.person_add),
                            label: const Text('Sign Up'),
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

    if (_avatarImage == null) {
      widget.showSnackBar(context, 'Please pick an avatar image');
      return;
    }

    bool isSuccess = true;

    setState(() {
      _isUploading = true;
    });

    FirebaseAuthHelper()
        .createUserWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
      forceVerifyEmail: widget.forceValidateEmail,
    )
        .then(
      (user) {
        if (user != null) {
          _userInfo = UserInfo(
            id: user.uid,
            name: _usernameController.text,
            email: _emailController.text,
            avatarUrl: '',
          );
          widget.showSnackBar(context, 'Sign up successful: ${user.email}');
          return FirebaseStorageHelper().upload(
            UserAvatars.collectionId,
            '${user.uid}.jpg',
            _avatarImage!,
          );
        } else {
          throw ErrorDescription('Sign up failed');
        }
      },
    ).then(
      (url) {
        if (url.isEmpty) {
          throw ErrorDescription('Upload avatar image failed');
        }
        _userInfo = _userInfo!.copyWith(avatarUrl: url);

        return FirebaseFirestoreHelper().setData(
          UserInfo.collectionId,
          _userInfo!.id,
          _userInfo!.toJson(),
        );
      },
    ).then((value) {
      isSuccess = value;
    }).catchError((error) {
      widget.showSnackBar(context, 'Sign up error: $error');
      isSuccess = false;
    }).whenComplete(() {
      setState(() {
        _isUploading = false;
      });

      if (isSuccess) {
        Navigator.of(context).pop<UserInfo>(
          _userInfo!,
        );
      }
    });
  }
}
