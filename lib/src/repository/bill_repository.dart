import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_lembrete/src/model/auth.dart';
import 'package:flutter_lembrete/src/model/bill.dart';

class BillRepository {
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('bills');

  void create(BillModel bill) async {
    bill.referenceId = AuthModel.instance.userModel!.reference;
    await collection.add(bill.toMap());
  }

  void update(BillModel bill) async {
    bill.referenceId = AuthModel.instance.userModel!.reference;
    await collection.doc(bill.id()).update(bill.toMap());
  }

  void delete(BillModel bill) async {
    await collection.doc(bill.id()).delete();
  }

  void paid(BillModel bill, bool isPaid) async {
    bill.isPaid = isPaid;
    update(bill);
  }

  Future<List<BillModel>> getAll() async {
    String referenceId = AuthModel.instance.userModel!.reference!;
    QuerySnapshot querySnapshot =
        await collection.where('referenceId', isEqualTo: referenceId).get();
    List<QueryDocumentSnapshot<Object?>> docs = querySnapshot.docs;
    return docs.map((document) => BillModel.fromJson(document)).toList();
  }
}
