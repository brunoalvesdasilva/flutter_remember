import 'package:flutter/material.dart';
import 'package:flutter_lembrete/bill/dto/bill.dart';

class FormBill extends StatefulWidget {
  final Function onSave;

  const FormBill(this.onSave, {Key? key}) : super(key: key);

  @override
  _FormBillState createState() => _FormBillState(this.onSave);
}

class _FormBillState extends State<FormBill> {
  Function onSave;

  static const double _spaceInputs = 20;

  TextEditingController _title = TextEditingController();
  TextEditingController _price = TextEditingController();
  TextEditingController _expire = TextEditingController();

  final GlobalKey<FormState> _keyForm = GlobalKey<FormState>();

  _FormBillState(this.onSave);

  double toDouble(String raw) {
    String text = raw.replaceAll(',', '.');
    return double.parse(text);
  }

  void save() {
    if (!_keyForm.currentState!.validate()) {
      return;
    }

    String title = _title.text;
    double price = toDouble(_price.text);
    int expire = int.parse(_expire.text);

    BillDTO bill = BillDTO(title, price, expire);

    onSave(bill);
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
                child: const Text('Salvar lembrete de conta'),
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
