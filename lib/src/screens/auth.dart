import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_lembrete/src/utils/log.dart';
import 'package:google_sign_in/google_sign_in.dart';

GoogleSignIn _googleSignIn = GoogleSignIn();

Future<UserCredential> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
  log('Linha 12 - ' + googleUser.toString());

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
  log('Linha 16 - ' + googleAuth.toString());

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );
  log('Linha 24 - ' + credential.toString());

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {

  FutureOr<dynamic> refresh(UserCredential userCredential) {
    String displayName = userCredential.user?.displayName ?? 'Não logado';
    log('Linha 40 - ' + displayName);

    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escolha uma conta'),
      ),
      body: Center(child: ElevatedButton(
        onPressed: () {
          signInWithGoogle().then(refresh);
        },
        child: const Text('Logar com uma conta Google'),
      ))

    );
  }
}
