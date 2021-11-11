import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_lembrete/src/model/base_model.dart';
import 'package:flutter_lembrete/src/model/fcm.dart';

class UserModel extends BaseModel {
  late String name;
  late String email;

  String? _id;
  String? reference;
  DateTime? dateCreated;
  DateTime? dateUpdated;

  List<FcmModel> fcm = [];

  UserModel(
      {required this.name,
      required this.email,
      required this.reference,
      id,
      fcm,
      this.dateCreated,
      this.dateUpdated}) {
    _id = id;
    this.fcm = fcm ?? [];
  }

  factory UserModel.fromJson(DocumentSnapshot document) {
    String id = document.reference.id;

    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    String name = data['name'];
    String email = data['email'];

    String reference = data['reference'];

    DateTime? dateCreated = data['dateCreated'] is String
        ? DateTime.parse(data['dateCreated'])
        : null;

    DateTime? dateUpdated = data['dateUpdated'] is String
        ? DateTime.parse(data['dateUpdated'])
        : null;

    List<FcmModel>? fcm = [];

    return UserModel(
        name: name,
        email: email,
        id: id,
        fcm: fcm,
        reference: reference,
        dateCreated: dateCreated,
        dateUpdated: dateUpdated);
  }

  @override
  Map<String, dynamic> toMap() {
    String? _dateCreated =
        dateCreated != null ? dateCreated!.toIso8601String() : null;

    String? _dateUpdated =
        dateUpdated != null ? dateUpdated!.toIso8601String() : null;

    return <String, dynamic>{
      'name': name,
      'email': email,
      'fcm': fcm.map( (current) => current.toMap()).toList(),
      'reference': reference,
      'dateCreated': _dateCreated,
      'dateUpdated': _dateUpdated,
    };
  }

  @override
  String id() {
    return _id ?? 'not';
  }

  void addFcm(FcmModel newFcm) {
    bool notExistsFcm = true;

    fcm.map((current) {
      if (current.id() == newFcm.id()) {
        notExistsFcm = false;
      }
    });

    if (notExistsFcm) {
      fcm.add(newFcm);
    }
  }
}
