import 'package:flutter/material.dart';

class FormBills extends StatefulWidget {
  const FormBills({Key? key}) : super(key: key);

  @override
  _FormBillsState createState() => _FormBillsState();
}

class _FormBillsState extends State<FormBills> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text('Go back!'),
      ),
    );
  }
}
