import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_lembrete/src/model/bill.dart';

class BillRepository {
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('bills');

  void create(BillModel bill) async {
    await collection.add(bill.toMap());
  }

  void update(BillModel bill) async {
    await collection.doc(bill.id()).update(bill.toMap());
  }

  void delete(BillModel bill) async {
    print("Repo");
    print(bill.id());

    await collection.doc(bill.id()).delete();
  }

  void paid(BillModel bill, bool isPaid) async {
    bill.isPaid = isPaid;
    await collection.doc(bill.id()).update(bill.toMap());
  }

  Future<List<BillModel>> getAll() async {
    QuerySnapshot querySnapshot = await collection.get();
    List<QueryDocumentSnapshot<Object?>> docs = querySnapshot.docs;
    return docs.map((document) => BillModel.fromJson(document)).toList();
  }
}
