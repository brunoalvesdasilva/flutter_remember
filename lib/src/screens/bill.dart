import 'package:flutter/material.dart';
import 'package:flutter_lembrete/src/model/bill.dart';
import 'package:flutter_lembrete/src/repository/bill_repository.dart';
import 'package:flutter_lembrete/src/widget/bill/form.dart';

final BillRepository repository = BillRepository();

class BillScreenArguments {
  final BillModel? bill;

  BillScreenArguments(this.bill);
}

class BillScreen extends StatelessWidget {
  const BillScreen({Key? key}) : super(key: key);

  static const routeName = '/bill';

  @override
  Widget build(BuildContext context) {
    final _args = ModalRoute.of(context)!.settings.arguments as BillScreenArguments;
    bool _hasBill = _args is BillScreenArguments;
    final _bill = _hasBill ? _args.bill : null;

    void onSave(BillModel bill) {
      if (_hasBill) {
        repository.update(bill);
      } else {
        repository.create(bill);
      }

      Navigator.pop(context);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_hasBill ? "Editar conta" : "Adicionar nova conta"),
      ),
      body: FormBill(onSave, bill: _bill),
    );
  }
}