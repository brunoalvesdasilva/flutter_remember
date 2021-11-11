import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_lembrete/src/model/auth.dart';
import 'package:flutter_lembrete/src/screens/auth.dart';
import 'package:flutter_lembrete/src/screens/bill.dart';
import 'package:flutter_lembrete/src/screens/home.dart';

void main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    await AuthModel.instance.tryAuth();

    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

    runApp(app());
  }, (error, stackTrace) {
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
  });
}

protected(Widget screen) {
  return (BuildContext context) {

    if (AuthModel.instance.isAuth()) {
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