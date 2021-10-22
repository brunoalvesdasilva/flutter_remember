import 'package:flutter/material.dart';
import 'package:flutter_lembrete/src/repository/bill_repository.dart';
import 'package:flutter_lembrete/src/model/bill.dart';
import 'package:flutter_lembrete/src/widget/bill/list.dart';

final BillRepository repository = BillRepository();

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentView = 0;

  reload(dynamic result) {
    print("Resultado");
    print(result);
  }

  Widget _actionButton() {
    if (currentView != 0) {
      return const SizedBox.shrink();
    }

    return FloatingActionButton(
      tooltip: 'Adicionar nova conta',
      child: const Icon(Icons.add),
      onPressed: () async {
        Navigator.pushNamed(context, '/bill').then(reload);
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
            tabList(),
            tabConfig(),
          ],
        ),
        floatingActionButton: _actionButton(),
      ),
    );
  }
}

/**
 * Tab de config
 */
class tabConfig extends StatelessWidget {
  const tabConfig({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Config"),
    );
  }
}

/**
 * Tab de listagens
 */
class tabList extends StatelessWidget {
  const tabList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: FutureBuilder<List<BillModel>>(
            future: repository.getAll(),
            builder: (context, AsyncSnapshot<List<BillModel>> snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return loading();
              }

              return ListBill(snapshot.data ?? []);
            }));
  }

  Widget loading() {
    return Column(
      children: const <Widget>[
        LinearProgressIndicator(),
        Center(child: Text("Recuperando informações"))
      ],
    );
  }
}
