import 'package:flutter/material.dart';
import 'package:flutter_lembrete/src/model/bill.dart';
import 'package:flutter_lembrete/src/repository/bill_repository.dart';
import 'package:flutter_lembrete/src/screens/bill.dart';

import 'item.dart';

final BillRepository repository = BillRepository();

class ListBill extends StatefulWidget {
  List<Item> _items = [];

  ListBill(List<BillModel> bills, {Key? key}) : super(key: key) {
    _items = bills.map((BillModel bill) => Item(bill)).toList();
  }

  @override
  _ListBillState createState() => _ListBillState(_items);
}

class _ListBillState extends State<ListBill> {
  final List<Item> _items;

  _ListBillState(this._items);

  void togglePaid(Item item) {
    repository.paid(item.bill, !item.bill.isPaid);
    int index = _items.indexOf(item);

    setState(() {
      _items[index].isExpanded = false;
    });
  }

  void gotoEdit(BillModel bill) async {
    await Navigator.pushNamed(context, '/bill', arguments: BillScreenArguments(bill));
  }

  Widget action(IconData icon, String text, onPressed) {
    Widget _text = Text(text, textAlign: TextAlign.center);

    return Expanded(
        child: TextButton(
            onPressed: onPressed,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [Icon(icon), _text],
            )));
  }

  ExpansionPanel tileBill(Item item) {
    Widget actionPaid = item.bill.isPaid
        ? action(Icons.warning_sharp, 'Marcar\nnão pago', () {
            togglePaid(item);
          })
        : action(Icons.check, 'Marcar pago', () {
            togglePaid(item);
          });

    return ExpansionPanel(
      isExpanded: item.isExpanded,
      backgroundColor: item.buildBackground(),
      headerBuilder: (BuildContext context, bool isExpanded) {
        return item.buildTile();
      },
      body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              action(Icons.edit, 'Editar', () => gotoEdit(item.bill)),
              action(Icons.photo_camera, 'Comprovante', () {}),
              actionPaid,
            ],
          )),
    );
  }

  int sorting(Item current, Item previous) {
    int diff = current.bill.expire - previous.bill.expire;

    if (diff < 0) {
      return -1;
    }

    if (diff > 0) {
      return 1;
    }

    return 0;
  }

  @override
  Widget build(BuildContext context) {
    _items.sort(sorting);
    _items.sort((c, p) => c.bill.isPaid ? 1 : 0);

    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _items[index].isExpanded = !isExpanded;
        });
      },
      children: _items.map<ExpansionPanel>(tileBill).toList(),
    );
  }
}
