import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:mobile_block_student_adm/model/user.dart';
import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:mobile_block_student_adm/view/basePage.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_block_student_adm/common/CommonVariables.dart';
import 'package:mobile_block_student_adm/common/CommonSetting.dart';
class UserManager with ChangeNotifier , CommonSetting {

  User? _user  ;

  User? get user => _user;

  set user(User? value) {
    _user = value;
  }

  Future<void> processLogin(String userName, String password)  async{

    // get parameter
    final response = await http.get(
      Uri.parse(getParameterUrl),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> resdata = json.decode(response.body);
      CommonVariables.rpcUrl = resdata['rpc_url'];
      CommonVariables.contractAddress = resdata['smart_contract_address'];
      log(CommonVariables.rpcUrl);
      log(CommonVariables.contractAddress);
      String externalCognitoPoolId = resdata['external_cognito_pool_id'];
      String externalAppClientSecret = resdata['external_app_client_secret'];
      CommonVariables.userPool= CognitoUserPool(
        externalCognitoPoolId,
        externalAppClientSecret,
      );
    } else {
      throw Exception('Failed to fetch parameter: ${response.statusCode}');
    }

    // perform Login
    final cognitoUser = CognitoUser(userName, CommonVariables.userPool);
    print('process login');
    String? accesstoken = "FAIL";
    String? idtoken = "FAIL";
    final authDetails = AuthenticationDetails(
      username: userName,
      password: password,
    );
    CognitoUserSession session;
    try {
      session  = (await cognitoUser.authenticateUser(authDetails)) as CognitoUserSession;
      log("access Token:");
      log(session.getAccessToken().getJwtToken().toString());
      log("ID Token:");
      log(session.getIdToken().getJwtToken().toString());
      accesstoken = session.getAccessToken().getJwtToken();
      idtoken = session.getIdToken().getJwtToken();
      await getUserDetails(cognitoUser);
      _user?.accessToken = accesstoken;
      _user?.idToken = idtoken;
      _user?.cognitoUser=cognitoUser;
      print(_user.toString());
      notifyListeners();
    } on CognitoUserNewPasswordRequiredException catch (e) {
      try {
        // if(e.requiredAttributes!.isEmpty) {
        //   // No attribute hast to be set
        //   session = await cognitoUser.sendNewPasswordRequiredAnswer(password) as CognitoUserSession;
        // }
        // else {
        //   // All attributes from the e.requiredAttributes has to be set.
        //   print(e.requiredAttributes);
        //   // For example obtain and set the name attribute.
        //   var attributes = { "name": "Adam Kaminski"};
        //   session = await cognitoUser.sendNewPasswordRequiredAnswer(password, attributes) as CognitoUserSession;
        // }
      } on CognitoUserMfaRequiredException catch (e) {
        // handle SMS_MFA challenge
      } on CognitoUserSelectMfaTypeException catch (e) {
        // handle SELECT_MFA_TYPE challenge
      } on CognitoUserMfaSetupException catch (e) {
        // handle MFA_SETUP challenge
      } on CognitoUserTotpRequiredException catch (e) {
        // handle SOFTWARE_TOKEN_MFA challenge
      } on CognitoUserCustomChallengeException catch (e) {
        // handle CUSTOM_CHALLENGE challenge
      } catch (e) {
        log("Error in Login :",error: e);
        rethrow;
      }
    } on CognitoUserMfaRequiredException catch (e) {
      log("Error in Login SMS! ",error: e);
      rethrow;
      // handle SMS_MFA challenge
    } on CognitoUserSelectMfaTypeException catch (e) {
      log("Error in Login MFA ! ",error: e);
      rethrow;
      // handle SELECT_MFA_TYPE challenge
    } on CognitoUserMfaSetupException catch (e) {
      log("Error in Login ! MFA Setup",error: e);
      rethrow;
      // handle MFA_SETUP challenge
    } on CognitoUserTotpRequiredException catch (e) {
      log("Error in Login !  TOTP",error: e);
      rethrow;
      // handle SOFTWARE_TOKEN_MFA challenge
    } on CognitoUserCustomChallengeException catch (e) {
      log("Error in Login ! Custom Challenge",error: e);
      rethrow;
      // handle CUSTOM_CHALLENGE challenge
    } on CognitoUserConfirmationNecessaryException catch (e) {
      log("Error in Login confirm error! ",error: e);
      rethrow;
      // handle User Confirmation Necessary
    } catch (e) {
      log("Error in Login ! ",error: e);
      rethrow;
    }
    //notifyListeners();
    //accesstoken ??= "FAIL";
    //return accesstoken;
  }

  Future<Map<String, dynamic>> updateDBUser(Map<String, dynamic>  valueMap) async {
    Map data = {
      'item': valueMap,
    };

    try {
      final response = await http.post(
        Uri.parse(admissionAppUrl),
        headers: <String, String>{
          'content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> resdata = json.decode(response.body);
        if (resdata.containsKey('item')) {
          Map<String, dynamic> itemMap = resdata['item'];
          print(itemMap);
          notifyListeners();
          return itemMap;
        } else {
          throw Exception('Field "item" not found in response.');
        }
      } else {
        throw Exception('Failed to fetch data: ${response.statusCode}');
      }

    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> updateCognitoUserProfile(Map<String, dynamic>  valueMap) async {
    String? userName = user?.email;

    final cognitoUser = CognitoUser(userName, CommonVariables.userPool);

    final List<CognitoUserAttribute> attributes = [];
    attributes.add(CognitoUserAttribute(name: 'name', value: valueMap["surname"]));
    attributes.add(CognitoUserAttribute(name: 'given_name', value: valueMap["given_name"]));
    attributes.add(CognitoUserAttribute(name: 'phone_number', value: valueMap["mobile"]));

    try {
      await user?.cognitoUser?.updateAttributes(attributes);
      notifyListeners();
    } catch (e) {

      print(e);
      throw e;
    }
  }



  Future<void> getUserDetails(CognitoUser cognitoUser) async {
    final attributes = await cognitoUser.getUserAttributes();
    _user  = User(email: cognitoUser.username!);
    for (CognitoUserAttribute attribute in attributes!) {
      if (attribute.getName() == "sub") {
        user?.uid = attribute.getValue();
      } else if (attribute.getName() == "name") {
        user?.surname = attribute.getValue();
      } else if (attribute.getName() == "given_name") {
        user?.givenName = attribute.getValue();
      } else if (attribute.getName() == "phone_number") {
        user?.mobile = attribute.getValue();
      } else if (attribute.getName() == "name") {
        user?.surname = attribute.getValue();
      } else if (attribute.getName() == "givenName") {
        user?.givenName = attribute.getValue();
      } else if (attribute.getName() == "gender") {
        user?.gender = attribute.getValue();
      }
    }
    notifyListeners();
  }

  bool checkValidSession() {
    bool validSession = false;
    if (_user !=null && _user!.email != null) {
          String? accessToken= _user?.accessToken;
          String? idToken = _user?.idToken;
          bool boolValidAccessToken = false;
          bool boolValidIdToken = false;
          if (accessToken != null) {
            boolValidAccessToken = !JwtDecoder.isExpired(accessToken);
          }
          if (idToken != null) {
            boolValidIdToken = !JwtDecoder.isExpired(idToken);
          }
          if  (boolValidAccessToken && boolValidIdToken) {
            validSession = true;
          } else {
            log("Access token or ID token expired");
            validSession = false;
          }

    } else {
      log("No user login");
    }
    return validSession;
  }

  Future<bool> signOut() async {
    //final cognitoUser1 = CognitoUser("sdf", userPool);
    //await cognitoUser1.globalSignOut();
    //try {
    bool result = false;
    if (_user!=null &&
        _user?.cognitoUser !=null)
    {
      await _user?.cognitoUser?.globalSignOut();
      result = true;
      _user =null;
    } else {
      throw Exception("User does not signin");
    }
    return result;
  }
}