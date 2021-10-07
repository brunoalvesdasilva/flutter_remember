import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_lembrete/src/model/bill.dart';

class FormBill extends StatefulWidget {
  final Function onSave;
  final BillModel? bill;

  const FormBill(this.onSave, {Key? key, this.bill}) : super(key: key);

  @override
  _FormBillState createState() => _FormBillState(onSave, bill);
}

class _FormBillState extends State<FormBill> {
  static const double _spaceInputs = 20;

  late BillModel _bill = BillModel('', 0.0, 1);
  late String labelButton;
  final Function onSave;

  final TextEditingController _title = TextEditingController();
  final TextEditingController _price = MoneyMaskedTextController(decimalSeparator: ',', thousandSeparator: '.');
  final TextEditingController _expire = TextEditingController();

  final GlobalKey<FormState> _keyForm = GlobalKey<FormState>();

  _FormBillState(this.onSave, bill) {
    labelButton = 'Salvar lembrete';

    if (bill is BillModel) {
      _bill = bill;
      labelButton = 'Editar lembrete';
    }

    _title.text = _bill.title;
    _price.text = _bill.price.toStringAsFixed(2);
    _expire.text = _bill.expire.toString();
  }

  double toDouble(String raw) {
    String text = raw.replaceAll('.', '').replaceAll(',', '.');
    return double.parse(text);
  }

  void save() {
    if (!_keyForm.currentState!.validate()) {
      return;
    }

    _bill.title = _title.text;
    _bill.price = toDouble(_price.text);
    _bill.expire = int.parse(_expire.text);

    onSave(_bill);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _keyForm,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Qual conta deseja lembrar:"),
              Padding(
                padding: const EdgeInsets.only(bottom: _spaceInputs),
                child: TextFormField(
                  controller: _title,
                  decoration: const InputDecoration(
                    hintText: 'Conta de luz, conta de água, gás',
                  ),
                  validator: (text) {
                    if (text!.isEmpty) {
                      return 'Precisamos indentificar a conta!';
                    }
                  },
                ),
              ),
              const Text("Qual o valor da conta:"),
              Padding(
                padding: const EdgeInsets.only(bottom: _spaceInputs),
                child: TextFormField(
                  controller: _price,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: '0,00',
                  ),
                  validator: (text) {
                    try {
                      double value = toDouble(text!);

                      if (!(value >= 0.01)) {
                        return 'Digite um valor maior que zero!';
                      }
                    } catch (e) {
                      return 'Precisamos saber uma previsão de valor';
                    }
                  },
                ),
              ),
              const Text("Geralmente vence em que dia?:"),
              Padding(
                padding: const EdgeInsets.only(bottom: _spaceInputs),
                child: TextFormField(
                  controller: _expire,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  decoration: const InputDecoration(
                    hintText: 'De 1 a 31',
                  ),
                  validator: (text) {
                    try {
                      int value = int.parse(text!);
                      if (!(value >= 1 && value <= 31)) {
                        return 'Digite um valor entre 1 e 31';
                      }
                    } catch (e) {
                      return 'Precisamos saber em que dia vence a conta!';
                    }
                  },
                ),
              ),
              ElevatedButton(
                onPressed: save,
                child: Text(labelButton),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity,
                      40), // double.infinity is the width and 30 is the height
                ),
              )
            ],
          ),
        ));
  }
}
