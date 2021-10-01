import 'dart:core';

class BillDTO {
  final String title;
  final double price;
  final int expire;
  final bool isPaid;

  BillDTO(this.title, this.price, this.expire, {this.isPaid = false});

  factory BillDTO.fromJson(Map<String, dynamic> json) => _billFromJson(json);

  Map<String, dynamic> toJson() => _billToJson(this);

  @override
  String toString() => 'Bill<$title, $price, $expire, $isPaid>';
}

BillDTO _billFromJson(Map<String, dynamic> json) {
  String title = json['title'];
  double price = json['price'];
  int expire = json['expire'];
  bool isPaid = json['isPaid'];

  return BillDTO(title, price, expire, isPaid: isPaid);
}

Map<String, dynamic> _billToJson(BillDTO instance) {
  return <String, dynamic>{
    'title': instance.title,
    'price': instance.price,
    'expire': instance.expire,
    'isPaid': instance.isPaid,
  };
}
