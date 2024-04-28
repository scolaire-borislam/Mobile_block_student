import 'dart:convert';
import 'dart:developer';
import 'package:mobile_block_student_adm/common/CommonSetting.dart';
import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_block_student_adm/view/basePage.dart';
import 'package:mobile_block_student_adm/viewmodel/UserManager.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../model/user.dart';

class ProfileViewModel with ChangeNotifier, CommonSetting {
  //final BuildContext context;
  late UserManager _userManager;

  UserManager get userManager => _userManager;


  set userManager(UserManager value) {
    _userManager = value;
    notifyListeners();
  }

  ProfileViewModel(BuildContext context) ;

  Future<String> getAvatarImageUrl() async {
    try {
      final loginId = _userManager.user?.email;
      final imagePath = "$appDir/$loginId/avatar.jpg" ;
      log(imagePath);
      Map data = {
        'documentKey': imagePath,
        "actionType":"get_object"
      };

      final response = await http.post(
        Uri.parse(getDocUrl),
        headers: <String, String>{
          'content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );
      print(response.statusCode );
      if (response.statusCode == 200) {
        log(response.body);
        String imageUrl= response.body;

        return imageUrl;

      } else {
        throw Exception('Failed retrieve avatar :${response.statusCode}');
      }
    } catch (e) {
      log(e.toString());
      throw Exception('Failed retrieve avatar url');
    }
  }

  Future<void> saveProfile(Map<String, dynamic> formData) async {
    try {
      //User? user = userManager?.user;
      Map<String, dynamic> clonedFormed = Map.from(formData);
      print(formData);
      clonedFormed['pk'] = userManager?.user?.uid;
      clonedFormed['sk'] = "CAND";
      print(clonedFormed);
      // Map data = {
      //   'item': clonedFormed,
      // };
      // final response = await http.post(
      //   Uri.parse(admissionAppUrl),
      //   headers: <String, String>{
      //     'content-Type': 'application/json',
      //   },
      //   body: jsonEncode(data),
      // );
      Map<String, dynamic> itemMap = await userManager.updateDBUser(clonedFormed);
      // if (response.statusCode == 200) {
      //   final Map<String, dynamic> resdata = json.decode(response.body);
      //   if (resdata.containsKey('item')) {
      //     Map<String, dynamic> itemMap = resdata['item'];
      //     print(itemMap);

      if (itemMap != null) {
          log("Save successfully!");
          await userManager?.updateCognitoUserProfile(itemMap);

          User? user = userManager?.user;
          user?.mergeFromJson(itemMap);
          print(user.toString());
          notifyListeners();
        // } else {
        //   throw Exception('Field "item" not found in response.');
        // }
      } else {
        throw Exception('Failed to update data in DB. No item return');
      }
    } catch (e) {
      log(e.toString());
      throw Exception('Failed to save profile');
    }
  }
}