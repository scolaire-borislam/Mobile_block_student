import 'package:mobile_block_student_adm/common/CommonVariables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:pinput/pinput.dart';
import 'appDrawer.dart';
import 'dart:developer';
import 'homepage.dart';
import 'registrationFragment.dart';
import 'basePage.dart';
import 'package:amazon_cognito_identity_dart_2/cognito.dart';

class RegistrationConfirmFragment extends BasePageFragment{


  RegistrationConfirmFragment({super.key, required callbackNavigate}) : super(callbackNavigate: callbackNavigate) ;
  // final Function(String, Map<String, dynamic>) callbackNavigate; // Notice the variable type
  //
  // const RegistrationConfirmFragment({super.key , required this.callbackNavigate});

  @override
  RegistrationConfirmState createState() {
    return RegistrationConfirmState();
  }
}


//class RegistrationConfirmState extends State<RegistrationConfirmFragment> {
class RegistrationConfirmState extends BasePageFramentState<RegistrationConfirmFragment> {
  final _formKey = GlobalKey<FormBuilderState>();
  final pinController = TextEditingController();
  final focusNode = FocusNode();
  bool _pinCorrect = true;

  @override
  void initState() {

  }

  @override
  Widget build(BuildContext context) {
    Function(String, Map<String, dynamic>) callbackNavigate = widget.callbackNavigate;
    final parentState = context.findAncestorStateOfType<MyHomePageState>();
    Map<String, dynamic>? param =parentState?.argumentMap;
    String email = param?["email"] ;
    debugPrint(email);

    //String email = widget.param["email"];
    // TODO: implement build
    const focusedBorderColor = Color.fromRGBO(23, 171, 144, 1);
    const fillColor = Color.fromRGBO(243, 246, 249, 0);
    const borderColor = Color.fromRGBO(23, 171, 144, 0.4);



    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Colors.white,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: borderColor),
      ),
    );

    Future<bool> validateUser(String email, String code) async {
      final cognitoUser = CognitoUser(email, CommonVariables.userPool);
      bool registrationConfirmed = false;
      try {
        registrationConfirmed = await cognitoUser.confirmRegistration(code);

      } catch (e) {
        log(e.toString());
      }
      return registrationConfirmed;

    }
    Future<bool>  resendEmail(String email) async {
      final cognitoUser = CognitoUser(email, CommonVariables.userPool);
      bool sent = false;
      Map status;
      try {
        log("start resend" + email);
        status = await cognitoUser.resendConfirmationCode();
        //log(status);
        print(status);
        sent = true;
      } catch (e) {
        print(e);
        log(e.toString());
      }
      return sent;
    }



    return   Center(
      child:
        FormBuilder(
        key: _formKey,
        child:
          Column(
        textDirection: TextDirection.ltr,
        children: [
            const SizedBox(height: 50),
            const Text('Verification', style:  TextStyle(
              fontSize: 22,
              color: Colors.white,
            )),
            const SizedBox(height: 20),
            const Text('A verification code has been sent you your email:' ),
            const SizedBox(height: 10),
            Text(email, style: const TextStyle(
              fontSize: 18,
              color: Colors.orange,
            ) ),
            const SizedBox(height: 50),
            Directionality(
            // Specify direction if desired
            textDirection: TextDirection.ltr,
            child: Pinput(

              length: 6,
              controller: pinController,
              focusNode: focusNode,
              androidSmsAutofillMethod:
              AndroidSmsAutofillMethod.smsUserConsentApi,
              listenForMultipleSmsOnAndroid: true,
              defaultPinTheme: defaultPinTheme,
              separatorBuilder: (index) => const SizedBox(width: 8),
              validator: (value)  {
                return _pinCorrect ? null : 'Pin is incorrect';
              },
              onClipboardFound: (value) {
                debugPrint('onClipboardFound: $value');
                pinController.setText(value);
              },
              hapticFeedbackType: HapticFeedbackType.lightImpact,
              onCompleted: (pin) async {
                debugPrint('onCompleted: $pin');
                bool registered = await validateUser(email, pin);
                if (registered) {
                  callbackNavigate("/registrationComplete", {});
                } else {
                  setState(() {
                     _pinCorrect= false;
                  });
                  _formKey.currentState!.validate();
                }
              },
              onChanged: (value) {
                debugPrint('onChanged: $value');
              },
              cursor: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 9),
                    width: 22,
                    height: 1,
                    color: focusedBorderColor,
                  ),
                ],
              ),
              focusedPinTheme: defaultPinTheme.copyWith(
                decoration: defaultPinTheme.decoration!.copyWith(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: focusedBorderColor),
                ),
              ),
              submittedPinTheme: defaultPinTheme.copyWith(
                decoration: defaultPinTheme.decoration!.copyWith(
                  color: fillColor,
                  borderRadius: BorderRadius.circular(19),
                  border: Border.all(color: focusedBorderColor),
                ),
              ),
              errorPinTheme: defaultPinTheme.copyBorderWith(
                border: Border.all(color: Colors.redAccent),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text('Did not receive code?', style:  TextStyle(
            fontSize: 22,
            color: Colors.white,
          )),
          const SizedBox(height: 20),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.blue,
              backgroundColor: Colors.white,
              side: const BorderSide(
                color:  Colors.red,
              ),
            ),
            onPressed: () async {
              resendEmail(email);
              var  snackBar = SnackBar(
                content: const Text("Code Resent!", style: TextStyle(fontSize: 16)),
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
            },
            child: const Text('Resend'),
          ),
        ],
      ),
        ),
    );
  }
}

