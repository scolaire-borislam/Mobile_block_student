import 'package:amazon_cognito_identity_dart_2/cognito.dart';

class User {
  final String email;
  String? surname;
  String? givenName;
  DateTime? dob;
  String? docNo;
  String? gender;
  String? mobile;
  String? accessToken;
  String? idToken;
  CognitoUser? cognitoUser;
  String? uid;
  String? walletAddress;

  User({
    required this.email,
    this.surname,
     this.givenName,
    this.dob,
    this.docNo,
    this.gender,
    this.mobile
  });

  // factory User.fromJson(Map<String, dynamic> json) {
  //   return User(
  //     email: json['email'] as String,
  //     surname: json['surname'] as String,
  //     givenName: json['givenName'] as String,
  //     dob: DateTime.parse(json['dob'] as String),
  //     docNo: json['docNo'] as String,
  //     gender: json['gender'] as String,
  //     mobile: json['mobile'] as String,
  //   );
  // }
  void mergeFromJson(Map<String, dynamic> json) {
    walletAddress = json['wallet_address'] != null ?  json['wallet_address'] as String : null ;
    surname = json['surname'] != null ?  json['surname'] as String : null ;
    givenName = json['given_name'] != null ?  json['given_name'] as String : null ;
    mobile = json['mobile'] != null ?  json['mobile'] as String : null;


  }

  Map<String, dynamic> toJsonMap() {
    final Map<String, dynamic> json = {
      'email': email,
      'sk': 'CAND',
    };

    // Add optional fields if they are not empty or null

    if (surname != null) json['surname'] = surname;
    if (givenName != null) json['given_name'] = givenName;
    if (mobile != null) json['mobile'] = dob;
    if (uid != null) json['pk'] = uid;
    if (walletAddress != null) json['wallet_address'] = walletAddress;

    return json;
  }


  @override
  String toString() {
    return 'User{email: $email, surname: $surname, givenName: $givenName, dob: $dob, docNo: $docNo, gender: $gender, mobile: $mobile, uid: $uid, walletAddress: $walletAddress, accessToken: $accessToken, idToken: $idToken, cognitoUser: $cognitoUser}';
  }
}