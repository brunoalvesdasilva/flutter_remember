import 'package:flutter/material.dart';
import '../bills_payments/bills_payments.dart';
import './widget/bills_payments/bills_payments.dart';
import './widget/config/config.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentView = 0;

  Widget _actionButton() {
    if (currentView != 0) {
      return const SizedBox.shrink();
    }

    return FloatingActionButton(
      tooltip: 'Increment Counter',
      child: const Icon(Icons.add),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const BillPaymentsScreen()),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Meu lembrete de contas'),
          bottom: TabBar(
            tabs: const <Widget>[
              Tab(
                icon: Icon(Icons.add_alert),
              ),
              Tab(
                icon: Icon(Icons.brightness_5_sharp),
              ),
            ],
            onTap: (index) {
              setState(() {
                currentView = index;
              });
            },
          ),
        ),
        body: const TabBarView(
          children: <Widget>[
            BillsPayments(),
            Config(),
          ],
        ),
        floatingActionButton: _actionButton(),
      ),
    );
  }
}
