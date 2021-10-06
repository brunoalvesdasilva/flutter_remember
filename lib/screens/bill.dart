import 'package:flutter/material.dart';
import 'package:flutter_lembrete/bill/model/bill.dart';
import 'package:flutter_lembrete/bill/repository.dart';
import 'package:flutter_lembrete/widget/bill/form.dart';

final BillRepository repository = BillRepository();

class BillScreen extends StatefulWidget {
  final String title;

  const BillScreen({Key? key, this.title = "Adicionar nova conta"}) : super(key: key);

  @override
  _BillScreenState createState() => _BillScreenState();
}

class _BillScreenState extends State<BillScreen> {

  void onSave(BillModel bill) {
    repository.add(bill);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FormBill(onSave),
    );
  }
}