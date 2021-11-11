import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_lembrete/src/model/user.dart';

class UserRepository {
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('users');

  Future<UserModel> register(UserModel user) async {

    UserModel? existingUser = await searchByEmail(user.email);

    if (existingUser != null) {
      return existingUser;
    }

    user.dateCreated = DateTime.now();
    await collection.doc(user.id()).set(user.toMap());
    UserModel? userModel = await searchByEmail(user.email);

    return userModel!;
  }

  void update(UserModel user) async {
    user.dateUpdated = DateTime.now();
    await collection.doc(user.id()).update(user.toMap());
  }

  void delete(UserModel user) async {
    await collection.doc(user.id()).delete();
  }

  Future<List<UserModel>> getAll() async {
    QuerySnapshot querySnapshot = await collection.get();
    List<QueryDocumentSnapshot<Object?>> docs = querySnapshot.docs;
    return docs.map((document) => UserModel.fromJson(document)).toList();
  }

  Future<UserModel?> searchByEmail(String email) async {
    QuerySnapshot querySnapshot = await collection.where('email', isEqualTo: email).get();
    List<QueryDocumentSnapshot<Object?>> docs = querySnapshot.docs;
    List? finding = docs.toList();
    return docs.isNotEmpty ? UserModel.fromJson(finding[0]) : null;
  }
}
