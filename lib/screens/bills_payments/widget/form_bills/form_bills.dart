import 'package:flutter/material.dart';

class FormBills extends StatefulWidget {
  const FormBills({Key? key}) : super(key: key);

  @override
  _FormBillsState createState() => _FormBillsState();
}

class _FormBillsState extends State<FormBills> {
  static const double _spaceInputs = 20;

  TextEditingController _inputName = TextEditingController();
  TextEditingController _inputValue = TextEditingController();
  TextEditingController _inputExpiration = TextEditingController();

  final GlobalKey<FormState> _keyForm = GlobalKey<FormState>();

  void saveItem() {
    if (!_keyForm.currentState!.validate()) {
      return;
    }

    // ignore: avoid_print
    print(_inputName.text);
    print(_inputValue.text);
    print(_inputExpiration.text);
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
                  controller: _inputName,
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
                  controller: _inputValue,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: '0,00',
                  ),
                  validator: (text) {
                    try {
                      double value = double.parse(text!);
                      if (! (value >= 0.01)) {
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
                  controller: _inputExpiration,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'De 1 a 31',
                  ),
                  validator: (text) {
                    try {
                      int value = int.parse(text!);
                      if (! (value >= 1 && value <= 31)) {
                        return 'Digite um valor entre 1 e 31';
                      }
                    } catch (e) {
                      return 'Precisamos saber em que dia vence a conta!';
                    }
                  },
                ),
              ),
              ElevatedButton(
                onPressed: saveItem,
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
