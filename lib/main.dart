import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import './screens/home/home.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MaterialApp(
    title: 'Meus lembretes de contas',
    home: HomeScreen()
  ));
}