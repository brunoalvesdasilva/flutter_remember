import 'package:flutter/material.dart';
import 'package:flutter_lembrete/bill/dto/bill.dart';

class Item {
  final BillDTO bill;
  bool isExpanded;

  Item(this.bill, {this.isExpanded = false});

  Text buildTile() {
    TextDecoration _style = TextDecoration.none;
    return Text(bill.title, style: TextStyle(decoration: _style));
  }
}
