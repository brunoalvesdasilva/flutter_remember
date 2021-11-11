import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_lembrete/src/model/auth.dart';
import 'package:flutter_lembrete/src/model/user.dart';
import 'package:flutter_lembrete/src/repository/user_repository.dart';
import 'package:google_sign_in/google_sign_in.dart';

GoogleSignIn _googleSignIn = GoogleSignIn();

Future<UserCredential> signInWithGoogle() async {
  final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

  final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  return await FirebaseAuth.instance.signInWithCredential(credential);
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  FutureOr<dynamic> refresh(UserCredential userCredential) {
    User? user = userCredential.user;

    if (user != null) {
      AuthModel.instance.register(user);

      Navigator.pushReplacementNamed(context, '/');
    }
  }

  void auth() {
    signInWithGoogle().then(refresh);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Escolha uma conta'),
        ),
        body: body());
  }

  Widget body() {
    return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(children: [heroText(), buttonAuth()]));
  }

  Widget heroText() {
    return const Center(
      child: Text('Lembrete de contas',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
    );
  }

  Widget buttonAuth() {
    return Expanded(
        child: Center(
            child: ElevatedButton(
      onPressed: auth,
      child: const Text('Logar com uma conta Google'),
    )));
  }
}
