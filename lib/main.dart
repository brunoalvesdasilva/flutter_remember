import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_lembrete/src/model/fcm.dart';
import 'package:flutter_lembrete/src/repository/fcm_repository.dart';
import 'package:flutter_lembrete/src/screens/bill.dart';
import 'package:flutter_lembrete/src/screens/home.dart';

FcmRepository _fcmRepository = FcmRepository();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  _fcmRepository.create(FcmModel('homogacao'));

  runApp(app());
}

MaterialApp app() {
  return MaterialApp(
    title: 'Meus lembretes de contas',
    initialRoute: '/',
    routes: {
      '/': (context) => const HomeScreen(),
      BillScreen.routeName: (context) => const BillScreen(),
    },
  );
}
