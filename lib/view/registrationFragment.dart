
import 'package:mobile_block_student_adm/common/CommonVariables.dart';
import 'dart:convert';
import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'appDrawer.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'dart:developer';
import 'basePage.dart';

// Create a Form widget.
//class RegistrationFragment extends StatefulWidget {
class RegistrationFragment extends BasePageFragment {

  // final Function(String, Map<String, dynamic>) callbackNavigate; // Notice the variable type
  // const RegistrationFragment({super.key, required this.callbackNavigate});

  RegistrationFragment({super.key, required callbackNavigate}) : super(callbackNavigate: callbackNavigate) ;

  @override
  RegistrationFragmentState createState() {
    return RegistrationFragmentState();

  }
}


//class RegistrationFragmentState extends State<RegistrationFragment> {
class RegistrationFragmentState extends BasePageFramentState<RegistrationFragment> {

  final _formKey = GlobalKey<FormBuilderState>();


  // const ProfileFragment({super.key});
  final ImagePicker _picker = ImagePicker();
  // final appDir = dotenv.get('APP_DIR', fallback: '');
  // final uploadUrl = dotenv.get('UPLOAD_URL', fallback: '');
  final getUploadUrl = dotenv.get('GET_DOC_URL', fallback: '');

  bool _passwordVisible = false;
  bool _repasswordVisible = false;
  XFile? _image;
  // final userPool = CognitoUserPool(
  //   dotenv.get('COGNITO_USER_POOL_ID', fallback: ''),
  //   dotenv.get('COGNITO_CLIENT_ID', fallback: ''),
  // );

  @override
  void initState() {
    log("appDir:" + appDir);
    log("uploadUrl:" + getUploadUrl);
   }


  void performRegistrationAndUpload(String loginId, String surName, String givenName, String mobile, String password) async {
    String url = await getUploadAvatarUrl(loginId);
    File imageFile =File(_image!.path);
    try {
      final response = await http.put(
        Uri.parse(url),
        body: await imageFile.readAsBytes(),
      );
      if (response.statusCode == 200) {
        log(response.body);
      } else {
        throw Exception('Failed to upload avatar image file.');
      }
    } catch (e) {
      log(e.toString());
      throw Exception('Failed to upload avatar image file.');
    }


    try {
      final userAttributes = [
        AttributeArg(name: 'given_name', value: givenName),
        AttributeArg(name: 'name', value: surName),
        AttributeArg(name: 'phone_number', value: mobile),
      ];

      var data = await CommonVariables.userPool.signUp(
        loginId,
        password,
        userAttributes: userAttributes,
      );

    } catch (e) {
      log(e.toString());
      throw Exception('Failed to register account!.');
    }

  }

  Future<String> getUploadAvatarUrl(String loginId) async {
    String imagePath =_image!.path;
    final extension = p.extension(imagePath); // '.dart'
    log(extension);
    final uploadPath = "$appDir/$loginId/avatar$extension" ;
    log(uploadPath);
    Map data = {
      'documentKey': uploadPath,
      "actionType":"put_object"
    };
    log(jsonEncode(data));
    final response = await http.post(
      Uri.parse(getUploadUrl),

      headers: <String, String>{
        'content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      log(response.body);
      return response.body;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to get upload path.');
    }
  }

  Future getImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    log('pick image file 1');
    setState(() {
      _image = image;
    });
    log(_image!.path);
    log('pick image file 2');
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Function(String, Map<String, dynamic>) callbackNavigate = widget.callbackNavigate;
    return  Center(
      child:
      SizedBox(
        width: MediaQuery.of(context).size.width *0.9 ,
        child:  Column(
            children : <Widget> [
              const Text("Account Registration" , style: TextStyle(fontSize: 20)),
              const SizedBox(height: 20),
              CircleAvatar(
                radius: MediaQuery.of(context).size.width * 0.2,
                backgroundImage: _image==null ? null: FileImage(File(_image!.path)),
                child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.bottomRight,
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.white70,
                          child: RawMaterialButton(
                              onPressed: () {
                                getImage();
                                print("change photo");
                                },
                              elevation: 2.0,
                              fillColor: const Color(0xFFF5F6F9),
                              child: const Icon(Icons.camera_alt_outlined, color: Colors.blue,),
                              shape: const CircleBorder()
                          ),
                        ),
                      ),
                    ]
                ),
              ) ,
              const SizedBox(height: 20),
              FormBuilder(
                key: _formKey,
                child:
                Column(
                    children : <Widget> [
                      FormBuilderTextField(
                        name: 'loginId',
                        style :Theme.of(context).textTheme.bodyLarge,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle :Theme.of(context).textTheme.bodyLarge,
                          // suffixIcon: _emailError
                          //     ? const Icon(Icons.error, color: Colors.red)
                          //     : const Icon(Icons.check, color: Colors.green),
                        ),
                        onChanged: (val) {
                          print(val); // Print the text value write into TextField
                        },
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.email()
                        ]),
                      ),
                      FormBuilderTextField(
                        name: 'surname',
                        style :Theme.of(context).textTheme.bodyLarge,
                        decoration: InputDecoration(
                          labelText: 'Surname',
                          labelStyle :Theme.of(context).textTheme.bodyLarge,
                          // suffixIcon: _surNameError
                          //     ? const Icon(Icons.error, color: Colors.red)
                          //     : const Icon(Icons.check, color: Colors.green),
                        ),
                        onChanged: (val) {
                          print(val); // Print the text value write into TextField
                        },
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ]),
                      ),
                      const SizedBox(height: 10),
                      FormBuilderTextField(
                        name: 'givenName',
                        style :Theme.of(context).textTheme.bodyLarge,
                        decoration: InputDecoration(
                          labelText: 'Given Name',
                          labelStyle :Theme.of(context).textTheme.bodyLarge,
                          // suffixIcon: _givenNameError
                          //     ? const Icon(Icons.error, color: Colors.red)
                          //     : const Icon(Icons.check, color: Colors.green),
                        ),
                        onChanged: (val) {
                          print(val); // Print the text value write into TextField
                        },
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ]),
                      ),
                      const SizedBox(height: 10),
                      FormBuilderTextField(
                        name: 'mobile',
                        style :Theme.of(context).textTheme.bodyLarge,
                        decoration: InputDecoration(
                          labelText: 'Mobile Number',
                          labelStyle :Theme.of(context).textTheme.bodyLarge,
                          // suffixIcon: _mobileError
                          //     ? const Icon(Icons.error, color: Colors.red)
                          //     : const Icon(Icons.check, color: Colors.green),
                        ),
                        onChanged: (val) {
                          print(val); // Print the text value write into TextField
                        },
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.numeric()
                        ]),
                      ),
                      const SizedBox(height: 10),
                      FormBuilderTextField(
                        obscureText: !_passwordVisible,
                        enableSuggestions: false,
                        autocorrect: false,
                        name: 'password',
                        style :Theme.of(context).textTheme.bodyLarge,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle :Theme.of(context).textTheme.bodyLarge,
                        ),
                        onChanged: (val) {
                          print(val); // Print the text value write into TextField
                        },
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.minLength(8),
                        ]),
                      ),
                      const SizedBox(height: 10),
                      FormBuilderTextField(
                        obscureText: !_repasswordVisible,
                        enableSuggestions: false,
                        autocorrect: false,
                        name: 'repassword',
                        style :Theme.of(context).textTheme.bodyLarge,
                        decoration: InputDecoration(
                          labelText: 'Re-enter Password',
                          labelStyle :Theme.of(context).textTheme.bodyLarge,
                        ),
                        onChanged: (val) {
                          print(val); // Print the text value write into TextField
                        },
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.minLength(8),
                           (val) {
                            if (_formKey.currentState != null &&
                                val != _formKey.currentState!.fields['password']?.value) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ]),
                      ),
                      const SizedBox(height: 20),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          backgroundColor: Colors.white,
                          side: const BorderSide(
                            color:  Colors.red,
                          ),
                        ),
                        onPressed: () async {

                          if (_formKey.currentState!.saveAndValidate()) {
                            var formData = _formKey.currentState!.value;
                            var loginId = formData['loginId'];
                            var surname = formData['surname'];
                            var givenName = formData['givenName'];
                            var mobile = formData['mobile'];
                            var password = formData['password'];
                            //String url = await getUploadAvatarUrl(loginId);
                            performRegistrationAndUpload(loginId,surname,givenName,mobile,password);
                            Map<String, dynamic> param = Map();
                            param['email'] = formData['loginId'];
                            callbackNavigate("/registrationConfirmation",param);
                          }

                        },
                        child: const Text('Save and Upload'),
                      )
                    ]
                ),
              )

            ]
        ),
      ),
    );
  }

}

