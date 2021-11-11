import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lembrete/src/model/fcm.dart';
import 'package:flutter_lembrete/src/repository/fcm_repository.dart';
import 'package:flutter_lembrete/src/repository/bill_repository.dart';
import 'package:flutter_lembrete/src/model/bill.dart';
import 'package:flutter_lembrete/src/widget/bill/list.dart';

import 'bill.dart';

final BillRepository repository = BillRepository();
FcmRepository _fcmRepository = FcmRepository();

FirebaseMessaging messaging = FirebaseMessaging.instance;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentView = 0;

  requestPermissionNotification() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  requestToken() async {
    String? token = await FirebaseMessaging.instance.getToken();

    await saveTokenToDatabase(token!);

    FirebaseMessaging.instance.onTokenRefresh.listen(saveTokenToDatabase);
  }

  Future<void> saveTokenToDatabase(String token) async {
    _fcmRepository.create(FcmModel(token));
  }

  reload(dynamic result) {
    if (result is String) {
      if (result == 'Refresh') {
        setState(() {});
      }
    }
  }

  handleAdd() {
    Navigator.pushNamed(context, '/bill').then(reload);
  }

  handleEdit(BillModel bill) {
    Navigator.pushNamed(context, '/bill', arguments: BillScreenArguments(bill))
        .then(reload);
  }

  handleToggle(BillModel bill) {
    repository.paid(bill, !bill.isPaid);
  }

  handleAttachment(BillModel bill) {}

  @override
  void initState() {
    super.initState();
    requestToken();
  }

  Widget _actionButton() {
    if (currentView != 0) {
      return const SizedBox.shrink();
    }

    return FloatingActionButton(
      tooltip: 'Adicionar nova conta',
      child: const Icon(Icons.add),
      onPressed: handleAdd,
    );
  }

  @override
  Widget build(BuildContext context) {

    requestPermissionNotification();

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
        body: TabBarView(
          children: <Widget>[
            tabList(),
            tabConfig(),
          ],
        ),
        floatingActionButton: _actionButton(),
      ),
    );
  }

  Widget tabList() {
    return SingleChildScrollView(
        child: FutureBuilder<List<BillModel>>(
            future: repository.getAll(),
            builder: (context, AsyncSnapshot<List<BillModel>> snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return loading();
              }

              return ListBill(
                bills: snapshot.data ?? [],
                handleToggle: handleToggle,
                handleAttachment: handleAttachment,
                handleEdit: handleEdit,
              );
            }));
  }

  Widget tabConfig() {
    return const Center(
      child: Text("Config"),
    );
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
