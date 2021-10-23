import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_lembrete/src/model/bill.dart';

class Item {
  final BillModel bill;
  bool isExpanded;

  Item(this.bill, {this.isExpanded = false});

  ListTile buildTile() {
    TextDecoration _style = bill.isPaid ? TextDecoration.lineThrough : TextDecoration.none;

    return ListTile(
        title: Text(bill.title, style: TextStyle(decoration: _style)),
            subtitle: Text(buildSubtitle()),
    );
  }

  Color buildBackground() {
    if (bill.isPaid) {
      return Colors.white.withOpacity(0.80);
    }

    return Colors.white;
  }

  String buildSubtitle() {
    NumberFormat numberFormat = NumberFormat.currency(locale: "pt_BR", symbol: "R\$");
    String expire = bill.expire.toString();
    String price = numberFormat.format(bill.price);
    int statusExpired = bill.statusExpired();

    if (statusExpired == -1) {
      return 'Venceu dia $expire - Valor de: $price';
    }

    if (statusExpired == 1) {
      return 'Vence dia $expire - Valor de: $price';
    }

    return 'Vence hoje ($expire) - Valor de: ${price}';
  }
}
