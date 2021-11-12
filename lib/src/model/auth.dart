import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_lembrete/src/model/user.dart';
import 'package:flutter_lembrete/src/repository/user_repository.dart';

class AuthModel {
  User? user;
  UserModel? userModel;

  DateTime? lastAuth;

  static final AuthModel instance = AuthModel._privateConstructor();

  AuthModel._privateConstructor();

  Future<bool> auth(UserModel authUser) async {
    user = FirebaseAuth.instance.currentUser;
    userModel = authUser;

    lastAuth = DateTime.now();

    return isAuth();
  }

  Future tryAuth() async {
    user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return;
    }

    String findEmail = user!.email ?? 'notFinder';
    UserModel? searchUser = await UserRepository().searchByEmail(findEmail);

    if (searchUser != null && searchUser.id() == user!.uid) {
      auth(searchUser);
    }
  }

  bool isAuth() {
    return userModel != null && user != null;
  }

  Future<bool> register(User user) async {
    String name = user.displayName!;
    String email = user.email!;
    String id = user.uid;

    UserModel userModel =
    UserModel(name: name, email: email, id: id, reference: id);

    UserRepository userRepository = UserRepository();
    userModel = await userRepository.register(userModel);

    return auth(userModel);
  }

  bool logout() {
    user = null;
    userModel = null;
    lastAuth = null;

    return !isAuth();
  }
}