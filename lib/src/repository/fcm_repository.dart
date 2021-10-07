import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_lembrete/src/model/fcm.dart';

class FcmRepository {
  final CollectionReference collection =
  FirebaseFirestore.instance.collection('fcms');

  void create(FcmModel fcm) async {
    await collection.doc(fcm.id()).set(fcm.toMap());
  }

  void update(FcmModel fcm) async {
    await collection.doc(fcm.id()).update(fcm.toMap());
  }

  void delete(FcmModel fcm) async {
    await collection.doc(fcm.id()).delete();
  }
}