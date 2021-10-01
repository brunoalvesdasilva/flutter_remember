import 'package:flutter/material.dart';
import 'package:flutter_lembrete/bill/dto/bill.dart';
import 'package:flutter_lembrete/bill/repository.dart';
import 'package:flutter_lembrete/widget/bill/list.dart';

final BillRepository repository = BillRepository();

class Bills extends StatefulWidget {
  const Bills({Key? key}) : super(key: key);

  @override
  _BillsState createState() => _BillsState();
}

class _BillsState extends State<Bills> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child:
        FutureBuilder<List<BillDTO>>(
           future: repository.getAll(),
            builder: (context, AsyncSnapshot<List<BillDTO>> snapshot) {
             if (snapshot.connectionState != ConnectionState.done ) {
               return const LinearProgressIndicator();
             }

              return ListBill(snapshot.data ?? []);
            }
        )
    );
  }
}
