import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../viewmodel/WalletViewModel.dart';
import 'basePage.dart';

class RecoverWalletConfirmFragment extends BasePageFragment {

  RecoverWalletConfirmFragment({super.key, required callbackNavigate})
      : super(callbackNavigate: callbackNavigate);

  @override
  RecoverWalletConfirmFragmentState createState() {
    return RecoverWalletConfirmFragmentState();

  }
}


class RecoverWalletConfirmFragmentState extends BasePageFramentState<RecoverWalletConfirmFragment> {


  late WalletViewModel walletViewModel;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Column(
            children: [
              SizedBox(height: 60),
              Icon(
                Icons.wallet_outlined,
                color: Colors.green,
                size: 150.0,
              ),
              SizedBox(height: 20),

              Text("You wallet recovered successfully!", style: TextStyle(
                fontSize: 20,
                color: Colors.greenAccent,
              )),
              const SizedBox(height: 5),

            ]
        ),
      ),
    );
  }

}