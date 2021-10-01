import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_lembrete/screens/bill.dart';
import 'package:flutter_lembrete/screens/home/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  MaterialApp materialApp = MaterialApp(
    title: 'Meus lembretes de contas',
    initialRoute: '/',
    routes: {
      '/': (context) => const HomeScreen(),
      '/bill': (context) => const BillScreen(),
    },
  );

  runApp(materialApp);
}