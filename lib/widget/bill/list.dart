import 'package:flutter/material.dart';
import 'package:flutter_lembrete/bill/dto/bill.dart';
import 'package:flutter_lembrete/bill/repository.dart';

import 'dto/item.dart';

final BillRepository repository = BillRepository();

class ListBill extends StatefulWidget {
  final List<BillDTO> _bills;

  const ListBill(this._bills, {Key? key}) : super(key: key);

  int _sortingPaid(current, previous) {
    return current.isPaid ? 1 : 0;
  }

  List<Item> toItem() {
    _bills.sort(_sortingPaid);
    return _bills.map((BillDTO bill) => Item(bill)).toList();
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
      children: _bills.map<ExpansionPanel>((Item item) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: item.buildTile(),
            );
          },
          body: ListTile(
              title: Text(item.bill.title),
              subtitle:
                  const Text('To delete this panel, tap the trash can icon'),
              trailing: const Icon(Icons.edit),
              onTap: () {}),
          isExpanded: item.isExpanded,
        );
      }).toList(),
    );
    ;
  }
}
