import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_lembrete/dto/bill.dart';

class BillRepository {
  final CollectionReference collection =
  FirebaseFirestore.instance.collection('bills');

  Stream<QuerySnapshot> getStream() {
    return collection.snapshots();
  }

  Future<DocumentReference> add(Bill bill) {
    return collection.add(bill.toJson());
  }

  // void update(Bill bill) async {
  //   await collection.doc(bill.referenceId).update(bill.toJson());
  // }
  //
  // void delete(Bill bill) async {
  //   await collection.doc(bill.referenceId).delete();
  // }
}