import 'dart:developer';

import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:mobile_block_student_adm/view/setupWalletFragment.dart';
import 'package:provider/provider.dart';
import '../viewmodel/WalletViewModel.dart';
import 'basePage.dart';
import 'homepage.dart';

class SetupWalletMnemonicFragment extends BasePageFragment {

  SetupWalletMnemonicFragment({super.key, required callbackNavigate})
      : super(callbackNavigate: callbackNavigate);

  //SetupWalletFragment({super.key, required callbackNavigate}) : super(callbackNavigate: callbackNavigate) ;

  @override
  SetupWalletMnemonicFragmentState createState() {
    return SetupWalletMnemonicFragmentState();

  }
}


class SetupWalletMnemonicFragmentState extends BasePageFramentState<SetupWalletMnemonicFragment> {


  late WalletViewModel walletViewModel;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    walletViewModel = Provider.of<WalletViewModel>(context);
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final parentState = context.findAncestorStateOfType<MyHomePageState>();
    Map<String, dynamic>? param =parentState?.argumentMap;
    List<String> secretList = param?["secret_phrase"] ;
    print(secretList);
    String publicAddress = param?["public_address"] ;

    print(publicAddress);
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Column(
            children: [
              const SizedBox(height: 10),
              const Text("Your Wallet Created!" , style: TextStyle(fontSize: 25, color: Colors.green)),
              const SizedBox(height: 5),
              Icon(
                Icons.check_circle_outline,
                color: Colors.green,
                size: 80.0,
              ),
              const SizedBox(height: 5),
              Text("Wallet Public Address : " ,
                  style: TextStyle(fontSize: 15, color: Colors.red)),
              TextFormField(initialValue: publicAddress,
                  textAlign: TextAlign.center,
                  readOnly: true,
                  style: TextStyle(fontSize: 14, color: Colors.red)),
              const SizedBox(height: 10),
              const Text("Wallet Recovery Phrase" , style: TextStyle(fontSize: 20, color: Colors.purple)),
              const SizedBox(height: 10),
              Text("WARNING: Your 12-word secret recovery phrase is very important. It makes it easy to backup and restore your wallet. Please save it and keep it secret.", style: const TextStyle(fontSize: 17, color: Colors.yellow) ),
              const SizedBox(height: 20),
              Row (
                children: [
                  Text(" 1."),
                  Expanded(
                    child: TextFormField(
                      initialValue: secretList[0],
                      textAlign: TextAlign.center,
                      readOnly: true,
                    ),
                  ),
                  Text(" 2."),
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      initialValue: secretList[1],
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              Row (
                children: [
                  Text(" 3."),
                  Expanded(
                    child: TextFormField(
                      initialValue: secretList[2],
                      textAlign: TextAlign.center,
                      readOnly: true,
                    ),
                  ),
                  Text(" 4."),
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      initialValue: secretList[3],
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              Row (
                children: [
                  Text(" 5."),
                  Expanded(
                    child: TextFormField(
                      initialValue: secretList[4],
                      textAlign: TextAlign.center,
                      readOnly: true,
                    ),
                  ),
                  Text(" 6."),
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      initialValue: secretList[5],
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              Row (
                children: [
                  Text(" 7."),
                  Expanded(
                    child: TextFormField(
                      initialValue: secretList[6],
                      textAlign: TextAlign.center,
                      readOnly: true,
                    ),
                  ),
                  Text(" 8."),
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      initialValue: secretList[7],
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              Row (
                children: [
                  Text(" 9."),
                  Expanded(
                    child: TextFormField(
                      initialValue: secretList[8],
                      textAlign: TextAlign.center,
                      readOnly: true,
                    ),
                  ),
                  Text("10."),
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      initialValue: secretList[9],
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              Row (
                children: [
                  Text("11."),
                  Expanded(
                    child: TextFormField(
                      initialValue: secretList[10],
                      textAlign: TextAlign.center,
                      readOnly: true,
                    ),
                  ),
                  Text("12."),
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      initialValue: secretList[11],
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

            ]
        ),
      ),
    );
  }

}