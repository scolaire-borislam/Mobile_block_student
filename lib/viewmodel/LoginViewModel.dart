import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_block_student_adm/viewmodel/UserManager.dart';
import 'package:provider/provider.dart';

class LoginViewModel with ChangeNotifier {
  //final BuildContext context;
  late UserManager _userManager;

  UserManager get userManager => _userManager;

  set userManager(UserManager value) {
    _userManager = value;
    notifyListeners();
  }

  LoginViewModel(BuildContext context) {
    //_userManager = Provider.of<UserManager>(context);
  }

  Future<void>  login(String loginId , String password) async {
    await _userManager.processLogin(loginId, password);
    notifyListeners();
  }

  void logout() {

  }

}