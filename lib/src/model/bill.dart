import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_lembrete/src/model/base_model.dart';

class BillModel extends BaseModel {
  late String title;
  late double price;
  late int expire;

  String? _id;
  late DateTime date;
  late bool isPaid;

  BillModel(this.title, this.price, this.expire, {isPaid, id, date}) {
    _id = id ?? '';
    this.isPaid = isPaid ?? false;
    this.date = date ?? DateTime.now();
  }

  factory BillModel.fromJson(DocumentSnapshot document) {
    String id = document.reference.id;

    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    String title = data['title'];
    double price = data['price'];
    int expire = data['expire'];
    bool isPaid = data['isPaid'];
    DateTime date = DateTime.parse(data['date']);

    return BillModel(title, price, expire, isPaid: isPaid, id: id, date: date);
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'price': price,
      'expire': expire,
      'isPaid': isPaid,
      'date': date.toIso8601String(),
    };
  }

  @override
  String id() {
    return _id ?? 'not';
  }

  int statusExpired() {
    DateTime now = DateTime.now();
    int diffDays = expire - now.day;

    if (diffDays < 0) {
      return -1;
    }

    if (diffDays > 0) {
      return 1;
    }

    return 0;
  }
}
