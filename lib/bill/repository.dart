import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_lembrete/bill/model/bill.dart';

class BillRepository {
  final CollectionReference collection =
  FirebaseFirestore.instance.collection('bills');

  Future<List<BillModel>> getAll() async {
    QuerySnapshot querySnapshot = await collection.get();

    return querySnapshot.docs.map(buildBill).toList();
  }

  Future<DocumentReference> add(BillModel bill) {
    return collection.add(bill.toJson());
  }

// void update(Bill bill) async {
//   await collection.doc(bill.referenceId).update(bill.toJson());
// }

  void paid(BillModel bill, bool isPaid) async {
    bill.isPaid = isPaid;
    await collection.doc(bill.id).update(bill.toJson());
  }

//
// void delete(Bill bill) async {
//   await collection.doc(bill.referenceId).delete();
// }

  BillModel buildBill (doc) {
    BillModel billDTO = BillModel.fromJson(doc.reference.id, doc.data() as Map<String, dynamic>);

    return billDTO;
  }
}