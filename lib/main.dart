import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_lembrete/screens/bill.dart';
import 'package:flutter_lembrete/screens/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(app());
}

MaterialApp app() {
  return MaterialApp(
    title: 'Meus lembretes de contas',
    initialRoute: '/',
    routes: {
      '/': (_) => const HomeScreen(0),
      '/bill': (_) => const BillScreen(),
    },
  );
}
