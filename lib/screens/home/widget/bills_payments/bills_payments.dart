import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_lembrete/repository/bill.dart';
import 'package:flutter_lembrete/screens/bills_payments/bills_payments.dart';

final BillRepository repository = BillRepository();

class Item {
  Item(
      {required this.title,
        this.body = "",
        this.isExpanded = false,
        this.isPaid = false});

  String title;
  String body;
  bool isExpanded;
  bool isPaid;
}

class BillsPayments extends StatefulWidget {
  const BillsPayments({Key? key}) : super(key: key);

  @override
  _BillsPaymentsState createState() => _BillsPaymentsState();
}

Color _colorByPaid(bool isPaid) {
  if (isPaid) {
    return Colors.white.withOpacity(0.95);
  }

  return Colors.white;
}

int _sortingBills(current, previous) {
  return current.isPaid ? 1 : 0;
}

void gotoEdit(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
        builder: (context) => const BillPaymentsScreen(
              title: "Editar conta",
            )),
  );
}

class _BillsPaymentsState extends State<BillsPayments> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: StreamBuilder(
          stream: repository.getStream(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) return LinearProgressIndicator();

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }

            List<Item> _bills = snapshot.data!.docs.map( (DocumentSnapshot document) {
              Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

              return Item(title: data['title'], isPaid: data['isPaid']);
            }).toList();

            _bills.sort(_sortingBills);

            return ListBill(_bills);
          },
        ),
      ),
    );
  }
}


class ListBill extends StatefulWidget {
  List<Item> _bills;

  ListBill(this._bills, {Key? key}) : super(key: key);

  @override
  _ListBillState createState() => _ListBillState(_bills);
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
          backgroundColor: _colorByPaid(item.isPaid),
          headerBuilder: (BuildContext context, bool isExpanded) {
            TextDecoration _textDecoration = item.isPaid ? TextDecoration.lineThrough : TextDecoration.none;

            return ListTile(
              title: Text(item.title, style: TextStyle(decoration: _textDecoration)),
            );
          },
          body: ListTile(
              title: Text(item.title),
              subtitle:
              const Text('To delete this panel, tap the trash can icon'),
              trailing: const Icon(Icons.edit),
              onTap: () {
                gotoEdit(context);
              }),
          isExpanded: item.isExpanded,
        );
      }).toList(),
    );;
  }
}
