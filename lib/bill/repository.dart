import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_lembrete/bill/dto/bill.dart';

class BillRepository {
  final CollectionReference collection =
  FirebaseFirestore.instance.collection('bills');

  Future<List<BillDTO>> getAll() async {
    QuerySnapshot querySnapshot = await collection.get();

    return querySnapshot.docs.map((doc) => BillDTO.fromJson(doc.data() as Map<String, dynamic>)).toList();
  }

  Future<DocumentReference> add(BillDTO bill) {
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