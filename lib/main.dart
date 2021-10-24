import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_lembrete/src/screens/auth.dart';
import 'package:flutter_lembrete/src/screens/bill.dart';
import 'package:flutter_lembrete/src/screens/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(app());
}

protected(Widget screen) {
  return (BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      return screen;
    }

    return const AuthScreen();
  };
}

MaterialApp app() {
  return MaterialApp(
    title: 'Meus lembretes de contas',
    initialRoute: '/',
    routes: {
      '/': protected(const HomeScreen()),
      BillScreen.routeName: protected(const BillScreen()),
    },
  );
}