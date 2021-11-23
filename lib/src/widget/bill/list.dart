import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lembrete/src/model/bill.dart';

import 'item.dart';

class ListBill extends StatefulWidget {
  final Function handleEdit;
  final Function handleDelete;
  final Function handleToggle;
  final Function handleAttachment;
  final List<BillModel> bills;

  const ListBill(
      {required this.bills,
      required this.handleEdit,
      required this.handleDelete,
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
      children: _items.map<ExpansionPanel>(tileBill).toList()
    );
  }

  ExpansionPanel tileBill(Item item) {
    Color background = item.bill.isPaid ? Colors.white.withOpacity(0.80) : Colors.white;

    return ExpansionPanel(
      isExpanded: item.isExpanded,
      backgroundColor: background,
      headerBuilder: (BuildContext context, bool isExpanded) => buildTile(item.bill),
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

  Widget buildTile(BillModel bill) {
    TextDecoration _style =
    bill.isPaid ? TextDecoration.lineThrough : TextDecoration.none;
    NumberFormat numberFormat = NumberFormat.currency(locale: "pt_BR", symbol: "R\$");
    String expire = bill.expire.toString();
    String price = numberFormat.format(bill.price);
    int statusExpired = bill.statusExpired();
    String subtitle = 'Vence hoje ($expire) - Valor de: $price';

    if (statusExpired == -1) {
      subtitle = 'Venceu dia $expire - Valor de: $price';
    }

    if (statusExpired == 1) {
      subtitle = 'Vence dia $expire - Valor de: $price';
    }

    return Dismissible(
        key: ValueKey<String>(bill.id()),
        direction: DismissDirection.startToEnd,
        onDismissed: (DismissDirection direction) {
            setState(() {
              _items.removeWhere((element) => element.bill.id() == bill.id());
              widget.handleDelete(bill);
            });
        },
        confirmDismiss: (DismissDirection direction) async {
          return await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Deletar lembrete?"),
                content: const Text("Essa ação não pode ser desfeita!"),
                actions: <Widget>[
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.redAccent),
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text("Sim, deletar")
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.grey),
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text("Cancelar"),
                  ),
                ],
              );
            },
          );
        },
        background: Container(
          alignment: AlignmentDirectional.centerStart,
          color: Colors.red,
          child: const Padding(
            padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
        ),
        child: ListTile(
          title: Text(bill.title, style: TextStyle(decoration: _style)),
          subtitle: Text(subtitle),
        ));
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