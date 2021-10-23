import 'package:flutter/material.dart';
import 'package:flutter_lembrete/src/model/bill.dart';

import 'item.dart';

class ListBill extends StatefulWidget {
  final Function handleEdit;
  final Function handleToggle;
  final Function handleAttachment;
  final List<BillModel> bills;

  const ListBill(
      {required this.bills,
      required this.handleEdit,
      required this.handleToggle,
      required this.handleAttachment,
      Key? key})
      : super(key: key);

  @override
  _ListBillState createState() => _ListBillState();
}

class _ListBillState extends State<ListBill> {
  late List<Item> _items;

  @override
  void initState() {
    super.initState();
    _items = widget.bills.map((BillModel bill) => Item(bill)).toList();
  }

  void togglePaid(Item item) {
    widget.handleToggle(item.bill);

    setState(() {
      int index = _items.indexOf(item);
      _items[index].isExpanded = false;
    });
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

  Widget actionPaid(Item item) {
    return item.bill.isPaid
        ? action(Icons.warning_sharp, 'Marcar\nnão pago', () {
            togglePaid(item);
          })
        : action(Icons.check, 'Marcar pago', () {
            togglePaid(item);
          });
  }

  Widget actionEdit(Item item) {
    return action(Icons.edit, 'Editar', () => widget.handleEdit(item.bill));
  }

  Widget actionAttachment(Item item) {
    return action(Icons.photo_camera, 'Comprovante', () {});
  }

  ExpansionPanel tileBill(Item item) {
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
              actionEdit(item),
              actionAttachment(item),
              actionPaid(item),
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    _items.sort(sortingItem);
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


int sortingItem(Item current, Item previous) {
  int diff = current.bill.expire - previous.bill.expire;

  if (diff < 0) {
    return -1;
  }

  if (diff > 0) {
    return 1;
  }

  return 0;
}