import 'dart:core';
import 'package:uuid/uuid.dart';

Uuid uuid = const Uuid();

class BillModel {
  final String title;
  final double price;
  final int expire;
  String? id;
  DateTime? date;
  bool isPaid;

  BillModel(this.title, this.price, this.expire,
      {this.isPaid = false, id, date}) {
    this.id = id ?? uuid.v1();
    this.date = date ?? DateTime.now();
  }

  factory BillModel.fromJson(id, Map<String, dynamic> json) {
    BillModel billModel = _billFromJson(json);
    billModel.id = id;
    return billModel;
  }

  Map<String, dynamic> toJson() => _billToJson(this);

  @override
  String toString() => 'Bill<$id, $title, $price, $expire, $isPaid>';

  int statusExpired() {
    var now = DateTime.now();
    if (expire < now.day) {
      return -1;
    }

    if (expire > now.day) {
      return 1;
    }

    return 0;
  }
}

BillModel _billFromJson(Map<String, dynamic> json) {
  DateTime date = DateTime.parse(json['date']);
  String title = json['title'];
  double price = json['price'];
  int expire = json['expire'];
  bool isPaid = json['isPaid'];

  return BillModel(title, price, expire, isPaid: isPaid, date: date);
}

Map<String, dynamic> _billToJson(BillModel instance) {
  return <String, dynamic>{
    'title': instance.title,
    'price': instance.price,
    'expire': instance.expire,
    'date': instance.date?.toIso8601String(),
    'isPaid': instance.isPaid,
  };
}
