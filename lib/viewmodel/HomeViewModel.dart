import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mobile_block_student_adm/viewmodel/UserManager.dart';
import 'package:mobile_block_student_adm/model/promramme.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;

import 'package:mobile_block_student_adm/view/basePage.dart';

import '../model/user.dart';
import '../service/WalletService.dart';

class HomeViewModel with ChangeNotifier {
  //final BuildContext context;
  late UserManager _userManager;
  //late List<Programme> featuredProgramList;

  UserManager get userManager => _userManager;



  set userManager(UserManager value) {
    _userManager = value;
    notifyListeners();
  }

  HomeViewModel(BuildContext context) {
    //_userManager = Provider.of<UserManager>(context);
  }


  Future<bool> checkWalletCreated() async {
    User? user = userManager.user;
    String publicAddress = await WalletService().loadPublicAddressString(user!.email);
    if (publicAddress != "NO_DATA_FOUND") {
      return true;
    }
    return false;
  }

  Future<void>  login(String loginId , String password) async {
    await _userManager.processLogin(loginId, password);
    notifyListeners();
  }

  Future<List<Programme>> getFeaturedProgramList(String apiurl) async {
  //Future<void> getFeaturedProgramList(String apiurl) async {
    try {
      final response = await http.get(
        Uri.parse(apiurl),
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        log(response.body);

        // Parse the string as JSON using the jsonDecode function
        List<dynamic> jsonDataList = jsonDecode(response.body);

        // Convert each JSON object to a Programme object
        List<Programme> programmeList = jsonDataList.map((jsonData) => Programme.fromJson(jsonData)).toList();

       return programmeList;

      } else {
        throw Exception('Failed retrieve featured program :${response.statusCode}');
      }
    } catch (e) {
      log(e.toString());
      throw Exception('Failed retrieve featured program');
    }
  }
}