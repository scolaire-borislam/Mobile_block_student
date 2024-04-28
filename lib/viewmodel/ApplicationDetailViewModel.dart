import 'dart:convert';
import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:mobile_block_student_adm/viewmodel/UserManager.dart';
import 'package:provider/provider.dart';

import '../model/application.dart';

class ApplicationDetailViewModel with ChangeNotifier {
  late Application _currApplication;
  late List<Application> _currAppList;

  Application get currApplication => _currApplication;

  List<Application> get currAppList => _currAppList;

  set currApplication(Application value) {
    _currApplication = value;
    notifyListeners();
  }

  set currAppList(List<Application> value) {
    _currAppList = value;
    notifyListeners();
  }

  late UserManager _userManager;



  UserManager get userManager => _userManager;


  set userManager(UserManager value) {
    _userManager = value;
    notifyListeners();
  }

  ApplicationDetailViewModel(BuildContext context) {
    //_userManager = Provider.of<UserManager>(context);
  }
}