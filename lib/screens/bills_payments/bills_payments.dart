import 'package:flutter/material.dart';
import './widget/form_bills/form_bills.dart';

class BillPaymentsScreen extends StatefulWidget {
  final String title;

  const BillPaymentsScreen({Key? key, this.title = "Adicionar nova conta"}) : super(key: key);

  @override
  _BillPaymentsScreenState createState() => _BillPaymentsScreenState();
}

class _BillPaymentsScreenState extends State<BillPaymentsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: const FormBills(),
    );
  }
}
