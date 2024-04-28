import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../viewmodel/WalletViewModel.dart';
import 'basePage.dart';

class RecoverWalletFragment extends BasePageFragment {

  RecoverWalletFragment({super.key, required callbackNavigate})
      : super(callbackNavigate: callbackNavigate);

  @override
  RecoverWalletFragmentState createState() {
    return RecoverWalletFragmentState();

  }
}


class RecoverWalletFragmentState extends BasePageFramentState<RecoverWalletFragment> {


  late WalletViewModel walletViewModel;
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    walletViewModel = Provider.of<WalletViewModel>(context);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Function(String, Map<String, dynamic>) callbackNavigate = widget
        .callbackNavigate;
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,

        child:
         Column (
                children: <Widget>[
                FormBuilder(
                key: _formKey,
                child:
                    Column(
                        children: [
                          const SizedBox(height: 10),
                          const Text("Wallet Recovery" , style: TextStyle(fontSize: 25, color: Colors.purple)),
                          const SizedBox(height: 10),
                          Text("Please input your 12-word secret phrase in order to recover your wallet.", style: const TextStyle(fontSize: 18, color: Colors.yellow) ),
                          const SizedBox(height: 20),

                          Row (
                            children: [
                              Text(" 1."),
                              Expanded(
                                child: FormBuilderTextField(
                                  name: "secret1",
                                  textAlign: TextAlign.center,
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(),
                                  ]),
                                ),
                              ),
                              Text(" 2."),
                              Expanded(
                                child: FormBuilderTextField(
                                  name: "secret2",
                                  textAlign: TextAlign.center,
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(),
                                  ]),
                                ),

                              ),
                            ],
                          ),
                          Row (
                            children: [
                              Text(" 3."),
                              Expanded(
                                child: FormBuilderTextField(
                                  name: "secret3",
                                  textAlign: TextAlign.center,
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(),
                                  ]),
                                ),
                              ),
                              Text(" 4."),
                              Expanded(
                                child: FormBuilderTextField(
                                  name: "secret4",
                                  textAlign: TextAlign.center,
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(),
                                  ]),
                                ),
                              ),
                            ],
                          ),
                          Row (
                            children: [
                              Text(" 5."),
                              Expanded(
                                child: FormBuilderTextField(
                                  name: "secret5",
                                  textAlign: TextAlign.center,
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(),
                                  ]),

                                ),
                              ),
                              Text(" 6."),
                              Expanded(
                                child: FormBuilderTextField(
                                  name: "secret6",
                                  textAlign: TextAlign.center,
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(),
                                  ]),
                                ),
                              ),
                            ],
                          ),
                          Row (
                            children: [
                              Text(" 7."),
                              Expanded(
                                child: FormBuilderTextField(
                                  name: "secret7",
                                  textAlign: TextAlign.center,
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(),
                                  ]),
                                ),
                              ),
                              Text(" 8."),
                              Expanded(
                                child: FormBuilderTextField(
                                  name: "secret8",
                                  textAlign: TextAlign.center,
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(),
                                  ]),
                                ),
                              ),
                            ],
                          ),
                          Row (
                            children: [
                              Text(" 9."),
                              Expanded(
                                child: FormBuilderTextField(
                                  name: "secret9",
                                  textAlign: TextAlign.center,
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(),
                                  ]),
                                ),
                              ),
                              Text("10."),
                              Expanded(
                                child: FormBuilderTextField(
                                  name: "secret10",
                                  textAlign: TextAlign.center,
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(),
                                  ]),
                                ),
                              ),
                            ],
                          ),
                          Row (
                            children: [
                              Text("11."),
                              Expanded(
                                child: FormBuilderTextField(
                                  name: "secret11",
                                  textAlign: TextAlign.center,
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(),
                                  ]),
                                ),
                              ),
                              Text("12."),
                              Expanded(
                                child: FormBuilderTextField(
                                  name: "secret12",
                                  textAlign: TextAlign.center,
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(),
                                  ]),
                                ),
                              ),
                            ],
                          )
                        ]
                       ),
                    )
                  ,
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

                        print(formData.toString());

                        String secretPhrase = formData['secret1'].toString() + ' ' +
                            formData['secret2'].toString() + ' ' +
                            formData['secret3'].toString() + ' ' +
                            formData['secret4'].toString() + ' ' +
                            formData['secret5'].toString() + ' ' +
                            formData['secret6'].toString() + ' ' +
                            formData['secret7'].toString() + ' ' +
                            formData['secret8'].toString() + ' ' +
                            formData['secret9'].toString() + ' ' +
                            formData['secret10'].toString() + ' ' +
                            formData['secret11'].toString() + ' ' +
                            formData['secret12'].toString();
                        print(secretPhrase);
                        String publicAddress = await walletViewModel.createWallet(secretPhrase);
                        if (publicAddress == "INVALID") {
                          var  snackBar = SnackBar(
                            content: const Text("Invalid Secret Phrase!", style: TextStyle(fontSize: 16, color: Colors.black)),
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
                        } else {
                          await  walletViewModel.updateDBWalletAddress( publicAddress);
                          walletViewModel.walletPublicAddress =publicAddress;
                          callbackNavigate("/recoverWalletConfirm", {});
                        }

                      }
                      // Map<String, dynamic> param = Map();
                      // param['program'] = prog;
                      // currApp.status = "SUBMITTED";
                      // currApp = await applicationViewModel.saveApplication(currApp);
                      //
                      // callbackNavigate("/applicationConfirmFragment",param);
                    },
                    child: const Text('Confirm Your Secret Phrase', style: TextStyle(fontSize: 15),),
                  )

                ]
            ),


      ),
    );
  }

}