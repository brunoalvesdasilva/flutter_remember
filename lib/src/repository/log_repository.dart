import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_lembrete/src/model/log.dart';

class LogRepository {
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('log');

  void create(LogModel log) async {
    await collection.add(log.toMap());
  }

  void update(LogModel log) async {
    await collection.doc(log.id()).update(log.toMap());
  }
}
