import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';

Future<bool> requireLogin(BuildContext context) async {
  if (FirebaseAuth.instance.currentUser != null) {
    return true;
  }

  final ok = await showDialog<bool>(
    context: context,
    builder: (_) => Dialog(
      child: SizedBox(
        width: 420,
        height: 620,
        child: LoginPage(),
      ),
    ),
  );

  return ok ?? false;
}