import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_lembrete/src/screens/auth.dart';
import 'package:flutter_lembrete/src/screens/bill.dart';
import 'package:flutter_lembrete/src/screens/home.dart';
import 'package:flutter_lembrete/src/utils/log.dart';

void main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();

    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

    log('init app');

    runApp(app());
  }, (error, stackTrace) {
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
  });
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