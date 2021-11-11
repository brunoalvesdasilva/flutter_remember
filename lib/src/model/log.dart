import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_lembrete/src/model/base_model.dart';

class LogModel extends BaseModel {
  late String message;

  String? _id;
  late String? groupId;
  late DateTime date;

  LogModel(this.message, {id, groupId, date}) {
    _id = id ?? '';
    this.groupId = groupId ?? '';
    this.date = date ?? DateTime.now();
  }

  factory LogModel.fromJson(DocumentSnapshot document) {
    String id = document.reference.id;

    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    String message = data['message'];
    String groupId = data['groupId'];
    DateTime date = DateTime.parse(data['date']);

    return LogModel(message, id: id, groupId: groupId, date: date);
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
      'groupId': groupId,
      'date': date.toIso8601String(),
    };
  }

  @override
  String id() {
    return _id ?? 'not';
  }
}
