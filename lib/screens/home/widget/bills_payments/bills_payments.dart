import 'package:flutter/material.dart';
import '../../../bills_payments/bills_payments.dart';

class BillsPayments extends StatefulWidget {
  const BillsPayments({Key? key}) : super(key: key);

  @override
  _BillsPaymentsState createState() => _BillsPaymentsState();
}

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
  final List<Item> _bills = [
    Item(title: 'Conta de aluguel', isPaid: true),
    Item(title: 'Conta de luz'),
    Item(title: 'Conta de escola', isPaid: true),
    Item(title: 'Conta de gás'),
    Item(title: 'Conta de internet'),
    Item(title: 'Conta de celular TIM', isPaid: true),
    Item(title: 'Conta de internet'),
    Item(title: 'Conta de internet'),
    Item(title: 'Conta de internet'),
    Item(title: 'Conta de internet'),
    Item(title: 'Conta de internet'),
    Item(title: 'Conta de internet'),
    Item(title: 'Conta de internet'),
    Item(title: 'Conta de internet'),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: _buildPanel(),
      ),
    );
  }

  Widget _buildPanel() {
    // _bills.sort(_sortingBills);

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
    );
  }
}
