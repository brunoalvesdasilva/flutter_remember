import 'package:flutter/material.dart';

class Confirm extends StatefulWidget {
  final Function onConfirm;

  const Confirm({Key? key, required this.onConfirm}) : super(key: key);

  @override
  _ConfirmState createState() => _ConfirmState();
}

class _ConfirmState extends State<Confirm> {
  bool isConfirm = false;

  handleConfirm() {
    setState(() {
      isConfirm = true;
    });
  }

  handleCancel() {
  }

  handleOnConfirm() {
    setState(() {
      isConfirm = false;
    });

    widget.onConfirm();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (isConfirm) {
      return await();
    }

    return initial();
  }

  Widget initial() {
    return ElevatedButton(
      onPressed: handleConfirm,
      child: const Text("Deletar?"),
      style: ElevatedButton.styleFrom(
        primary: Colors.redAccent,
        minimumSize: const Size(double.infinity,
            40),
      ),
    );
  }

  Widget await() {
    return Row(
      children: [
        Expanded(
            child: ElevatedButton(
          onPressed: handleOnConfirm,
          child: const Text("Confirmar!"),
          style: ElevatedButton.styleFrom(primary: Colors.redAccent),
        )),
        const SizedBox(width: 10),
        Expanded(
            child: ElevatedButton(
              onPressed: handleCancel,
              child: const Text("Cancelar!"),
              style: ElevatedButton.styleFrom(primary: Colors.grey),
            ))
      ],
    );
  }
}
