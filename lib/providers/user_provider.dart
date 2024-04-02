import 'package:flutter/material.dart';
import 'package:instgram_clone/models/user.dart';
import 'package:instgram_clone/resources/auth_methods.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  AuthMethods _authMethods = AuthMethods();
  User get getUser => _user!;

  Future<void> refreshUser() async {
    _user = await _authMethods.getUserdetails();
    notifyListeners();
  }
}
