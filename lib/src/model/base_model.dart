import 'package:cloud_firestore/cloud_firestore.dart';

abstract class BaseModel {
  BaseModel();
  BaseModel.fromMap(DocumentSnapshot document);

  Map<String, dynamic> toMap();
  String id();
}