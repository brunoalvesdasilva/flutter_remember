import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lembrete/src/client/google_auth_client.dart';
import 'package:flutter_lembrete/src/model/auth.dart';
import 'package:flutter_lembrete/src/model/fcm.dart';
import 'package:flutter_lembrete/src/repository/bill_repository.dart';
import 'package:flutter_lembrete/src/model/bill.dart';
import 'package:flutter_lembrete/src/repository/user_repository.dart';
import 'package:flutter_lembrete/src/widget/bill/list.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:google_sign_in/google_sign_in.dart' as signIn;

import 'bill.dart';

final BillRepository repository = BillRepository();

FirebaseMessaging messaging = FirebaseMessaging.instance;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentView = 0;

  requestPermissionNotification() async {
    // NotificationSettings settings =
    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    /*if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }*/
  }

  requestToken() async {
    String? token = await FirebaseMessaging.instance.getToken();

    await saveTokenToDatabase(token!);
    FirebaseMessaging.instance.onTokenRefresh.listen(saveTokenToDatabase);
  }

  Future<void> saveTokenToDatabase(String token) async {
    AuthModel.instance.userModel!.addFcm(FcmModel(token));
    UserRepository().update(AuthModel.instance.userModel!);
  }

  reload(dynamic result) {
    if (result is String && result == 'Refresh') {
      setState(() {});
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

  handleDelete(BillModel bill) {
    repository.delete(bill);
  }

  handleAttachment(BillModel bill) async {

    final googleSignIn =
    signIn.GoogleSignIn.standard(scopes: [drive.DriveApi.driveScope]);
    final signIn.GoogleSignInAccount account = await googleSignIn.signIn();

    print("User account $account");
    final authHeaders = await account.authHeaders;
    final authenticateClient = GoogleAuthClient(authHeaders);
    final driveApi = drive.DriveApi(authenticateClient);

    FilePickerResult? fileLocal = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'pdf'],
    );

    if (fileLocal != null) {
      PlatformFile fileSelected = fileLocal.files.first;

      File file = File(fileSelected.path!);

      var driveFolder = drive.File();
      driveFolder.name = "Lembrete_de_contas";
      driveFolder.mimeType = "application/vnd.google-apps.folder";
      await driveApi.files.create(driveFolder);

      var driveFile = drive.File();
      //driveFile.parents = ['Lembrete_de_contas'];
      driveFile.name = "hello_world.${fileSelected.extension}";
      final result = await driveApi.files.create(driveFile, uploadMedia: drive.Media(file.openRead(), file.lengthSync()));
      print("Upload result: $result");
    }
  }

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
        body: listBills(),
        floatingActionButton: _actionButton(),
      ),
    );
  }

  Widget listBills() {
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
                handleDelete: handleDelete,
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
