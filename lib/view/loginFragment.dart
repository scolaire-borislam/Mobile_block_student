import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:mobile_block_student_adm/viewmodel/LoginViewModel.dart';
import 'package:mobile_block_student_adm/viewmodel/WalletViewModel.dart';
import 'package:provider/provider.dart';
import 'appDrawer.dart';
import 'package:amazon_cognito_identity_dart_2/cognito.dart';

import 'basePage.dart';


// Create a Form widget.
class LoginFragment extends  BasePageFragment {

  LoginFragment({super.key, required callbackNavigate}) : super(callbackNavigate: callbackNavigate) ;

  @override
  LoginFragmentState createState() {
    return LoginFragmentState();
  }
}

class LoginFragmentState extends  BasePageFramentState<LoginFragment> {


  final _formKey = GlobalKey<FormBuilderState>();

  bool _passwordVisible = false;
  late LoginViewModel loginViewModel;
  late WalletViewModel walletViewModel;

  @override
  void initState() {
    _passwordVisible = false;
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loginViewModel = Provider.of<LoginViewModel>(context);
    walletViewModel = Provider.of<WalletViewModel>(context);
  }


  Future<void> login(String userName, String password)  async{
    log('start login');
    await loginViewModel.login(userName, password);
    await walletViewModel.loadWalletPublicAddress();
    log('end login');
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    log("build");
    if (loginViewModel.userManager != null) {
      if (loginViewModel.userManager.user != null) {
        log("User ID: ${loginViewModel.userManager.user?.email!}" );
        //log("access Token: ${loginViewModel.userManager.user.accessToken} ?? '' ");
        if (loginViewModel.userManager.user?.accessToken != null) {
          log("access Token: ${loginViewModel.userManager.user?.accessToken!}" );
        }

      }
    }
    Function(String, Map<String, dynamic>) callbackNavigate = widget.callbackNavigate;
    return

      Container(
        width: MediaQuery.of(context).size.width *0.9 ,
        height: MediaQuery.of(context).size.height *0.7  ,
        child:  FormBuilder(
            key: _formKey,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children : <Widget> [
                  FractionallySizedBox(
                    widthFactor: 0.6,
                    child: Image.asset(
                      'assets/Scolaire-Ledger-icon-white.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  FormBuilderTextField(
                    name: 'loginId',
                    style :Theme.of(context).textTheme.bodyLarge,
                    decoration: InputDecoration(
                      labelText: 'ID/Email',
                      labelStyle :Theme.of(context).textTheme.bodyLarge,
                    ),
                    onChanged: (val) {
                      print(val); // Print the text value write into TextField
                    },
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                  ),
                  const SizedBox(height: 20),
                  FormBuilderTextField(
                    obscureText: !_passwordVisible,
                    enableSuggestions: false,
                    autocorrect: false,
                    name: 'password',
                    style :Theme.of(context).textTheme.bodyLarge,
                    decoration: InputDecoration(
                      hintText: 'Enter your password',
                      labelText: 'Password',
                      labelStyle :Theme.of(context).textTheme.bodyLarge,

                      suffixIcon: IconButton(
                        icon: Icon(
                          // Based on passwordVisible state choose the icon
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.blue,
                        ),
                        onPressed: () {
                          // Update the state i.e. toogle the state of passwordVisible variable
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),

                    ),
                    onChanged: (val) {
                      print(val); // Print the text value write into TextField
                    },
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),

                    ]),

                  ),
                  const SizedBox(height: 20),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      backgroundColor: Colors.white,
                      side: BorderSide(
                        color:  Colors.red,
                      ),
                    ),
                    onPressed: ()  async {
                      //_formKey.currentState?.saveAndValidate();
                      if (_formKey.currentState!.saveAndValidate()) {
                        var formData = _formKey.currentState!.value;
                        var loginId = formData['loginId'];
                        var password = formData['password'];
                        print('username '+ loginId);
                        print('password '+ password);
                        try {
                          await login(loginId,password) ;
                          var  snackBar = SnackBar(
                            content: const Text("Login Successfully!", style: TextStyle(fontSize: 16)),
                            backgroundColor: Colors.lightGreenAccent,
                            behavior: SnackBarBehavior.floating,
                            margin: const EdgeInsets.all(20),
                            action: SnackBarAction(
                              label: 'Dismiss',
                              onPressed: () {
                                // Some code to undo the change.
                              },
                            ),
                          );

                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          callbackNavigate("/home",{});
                        } catch (e) {
                          log("Error during login", error:e);
                          var  snackBar = SnackBar(
                            content: const Text("Invalid Login!", style: TextStyle(fontSize: 16, color: Colors.black)),
                            backgroundColor: Colors.redAccent,
                            behavior: SnackBarBehavior.floating,
                            margin: const EdgeInsets.all(20),
                            action: SnackBarAction(
                              label: 'Dismiss',
                              onPressed: () {
                                // Some code to undo the change.
                              },
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }

                        /*
                        String aToken = await processLogin(loginId,password) ;
                        print("token : " + aToken);
                        if (aToken != "FAIL" ){
                          var  snackBar = SnackBar(
                            content: const Text("Login Successfully!", style: TextStyle(fontSize: 16)),
                            backgroundColor: Colors.lightGreenAccent,
                            behavior: SnackBarBehavior.floating,
                            margin: const EdgeInsets.all(20),
                            action: SnackBarAction(
                              label: 'Dismiss',
                              onPressed: () {
                                // Some code to undo the change.
                              },
                            ),
                            );

                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            callbackNavigate("/home",{});
                        } else {
                          var  snackBar = SnackBar(
                            content: const Text("Invalid Login!", style: TextStyle(fontSize: 16, color: Colors.black)),
                            backgroundColor: Colors.redAccent,
                            behavior: SnackBarBehavior.floating,
                            margin: const EdgeInsets.all(20),
                            action: SnackBarAction(
                              label: 'Dismiss',
                              onPressed: () {
                                // Some code to undo the change.
                              },
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }*/

                      }
                    },
                    child: const Text('Login'),
                  )
                ]
            )

          ),
      ) ;

  }

}