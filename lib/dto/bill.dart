import 'dart:core';

class Bill {
  final String title;
  final double price;
  final int expire;
  final bool isPaid;

  Bill(
      {required this.title,
      required this.price,
      this.expire = 1,
      this.isPaid = false});

  factory Bill.fromJson(Map<String, dynamic> json) =>
      _billFromJson(json);

  Map<String, dynamic> toJson() => _billToJson(this);

  @override
  String toString() => 'Bill<$title>';
}

Bill _billFromJson(Map<String, dynamic> json) {
  return Bill(
      title: json['title'] as String,
      price: json['price'] as double,
      expire: json['expire'] as int,
      isPaid: json['isPaid'] as bool);
}

Map<String, dynamic> _billToJson(Bill instance) => <String, dynamic>{
      'title': instance.title,
      'price': instance.price,
      'expire': instance.expire,
      'isPaid': instance.isPaid,
    };
