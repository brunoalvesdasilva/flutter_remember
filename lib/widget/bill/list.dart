import 'package:flutter/material.dart';
import 'package:flutter_lembrete/bill/model/bill.dart';
import 'package:flutter_lembrete/bill/repository.dart';

import 'item.dart';

final BillRepository repository = BillRepository();

class ListBill extends StatefulWidget {
  final List<BillModel> _bills;

  const ListBill(this._bills, {Key? key}) : super(key: key);

  int _sortingExpire(current, previous) {
    bool firstExpire = current.expire < previous.expire;
    return firstExpire ? 0 : 1;
  }

  int _sortingPaid(current, previous) {
    return current.isPaid ? 1 : 0;
  }

  List<Item> toItem() {
    _bills.sort(_sortingExpire);
    _bills.sort(_sortingPaid);
    return _bills.map((BillModel bill) => Item(bill)).toList();
  }

  @override
  _ListBillState createState() => _ListBillState(toItem());
}

class _ListBillState extends State<ListBill> {
  final List<Item> _bills;
  _ListBillState(this._bills);

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _bills[index].isExpanded = !isExpanded;
        });
      },
      children: _bills.map<ExpansionPanel>(tileBill).toList(),
    );
  }

  void togglePaid(BillModel bill) {
    repository.paid(bill, !bill.isPaid);

    print(context.findRootAncestorStateOfType());
  }

  ExpansionPanel tileBill(Item item) {
    Widget actionPaid = item.bill.isPaid
        ? action(Icons.remove, 'Marcar não pago', () {togglePaid(item.bill);} )
        : action(Icons.check, 'Marcar pago', () {togglePaid(item.bill);} );

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
              action(Icons.edit, 'Editar', () {}),
              action(Icons.photo_camera, 'Comprovante', (){}),
            actionPaid,
            ],
          )),
    );
  }

  Widget action(IconData icon, String text, onPressed) {
    return Expanded(
        child: TextButton(
            onPressed: onPressed,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Icon(icon), Text(text)],
            )));
  }
}
