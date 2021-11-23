import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_lembrete/src/model/auth.dart';
// ignore: import_of_legacy_library_into_null_safe
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

showAlertDialog(BuildContext context, String message) {

  // set up the button
  Widget okButton = ElevatedButton(
    child: const Text("Tentar novamente"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text("Atenção"),
    content: Text(message),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isFetch = false;

  Future<FutureOr> refresh(UserCredential userCredential) async {
    isFetch = false;
    User? user = userCredential.user;

    if (user != null) {
      await AuthModel.instance.register(user);

      if (AuthModel.instance.isAuth()) {
        Navigator.pushReplacementNamed(context, '/');
        setState(() => {});
        return true;
      }
    }

    setState(() => showAlertDialog(context, 'Não foi possível autenticar o usuário'));
    return false;
  }

  void auth() {
    isFetch = true;
    setState(() => signInWithGoogle().then(refresh));
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
    return Column(children: [loading(), heroText(), buttonAuth()]);
  }

  Widget loading() {
    return Container(child: isFetch ? const LinearProgressIndicator() : null);
  }

  Widget heroText() {
    return const Padding(
        padding: EdgeInsets.all(20.0),
        child: Center(
      child: Text('Lembrete de contas',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
    ));
  }

  Widget buttonAuth() {
    return Expanded(
        child: Center(
            child: ElevatedButton(
      onPressed: isFetch ? null : auth,
      child: Text(isFetch ? 'Aguarde...': 'Logar com uma conta Google'),
    )));
  }
}
