import 'package:flutter/material.dart';

const kRequiredUsernameLength = 3;
const kRequiredPasswordLength = 6;

abstract class FormValidationScreen extends StatefulWidget {
  const FormValidationScreen({super.key});

  bool isValidUsername(String? value, int requireLength) {
    if (value == null || value.trim().isEmpty) {
      return false;
    }
    return value.trim().length >= requireLength;
  }

  bool isValidEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return false;
    }
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegExp.hasMatch(value);
  }

  bool isValidPassword(String? value, int requireLength) {
    if (value == null || value.trim().isEmpty) {
      return false;
    }
    return value.trim().length >= requireLength;
  }

  bool isValidConfirmPassword(String? value, String password) {
    if (value == null || value.trim().isEmpty) {
      return false;
    }
    return value == password;
  }

  void showSnackBar(BuildContext context, String message) {
    if (!context.mounted) {
      return;
    }
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
