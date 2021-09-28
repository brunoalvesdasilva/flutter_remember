import 'package:flutter/material.dart';

class BillsPayments extends StatefulWidget {
  const BillsPayments({Key? key}) : super(key: key);

  @override
  _BillsPaymentsState createState() => _BillsPaymentsState();
}

class _BillsPaymentsState extends State<BillsPayments> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Bills Payment"),
    );
  }
}
