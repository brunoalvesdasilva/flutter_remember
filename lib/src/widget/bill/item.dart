import 'package:flutter_lembrete/src/model/bill.dart';

class Item {
  final BillModel bill;
  bool isExpanded;

  Item(this.bill, {this.isExpanded = false});
}
