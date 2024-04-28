
import 'dart:convert';
import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:mobile_block_student_adm/viewmodel/UserManager.dart';
import 'package:provider/provider.dart';
import '../model/application.dart';
import '../model/promramme.dart';
import '../service/SecureStorageService.dart';
import '../service/WalletService.dart';
import '../viewmodel/ApplicationViewModel.dart';
import '../viewmodel/WalletViewModel.dart';
import 'appDrawer.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'dart:developer';
import 'basePage.dart';
import 'homepage.dart';

class SetupWalletFragment extends BasePageFragment {

  SetupWalletFragment({super.key, required callbackNavigate})
      : super(callbackNavigate: callbackNavigate);

  //SetupWalletFragment({super.key, required callbackNavigate}) : super(callbackNavigate: callbackNavigate) ;

  @override
  SetupWalletFragmentState createState() {
    return SetupWalletFragmentState();

  }
}


class SetupWalletFragmentState extends BasePageFramentState<SetupWalletFragment> {


  late WalletViewModel walletViewModel;

  late String privateKey;
  late String publicKey;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    walletViewModel = Provider.of<WalletViewModel>(context);

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // Function(String, Map<String, dynamic>) callbackNavigate = widget
    //     .callbackNavigate;
    // final parentState = context.findAncestorStateOfType<MyHomePageState>();
    String? username = walletViewModel.userManager.user?.email;
    Function(String, Map<String, dynamic>) callbackNavigate = widget
        .callbackNavigate;
    return Center(
      child:
      SizedBox(
        width: MediaQuery.of(context).size.width *0.9 ,
        child: Column (

          children: [
            const SizedBox(height: 5),
            const Text("You don't have an valid Wallet" , style: TextStyle(fontSize: 25, color: Colors.purple)),
            const SizedBox(height: 5),


            const Text("You can choose to :" , style: TextStyle(fontSize: 25, color: Colors.purple)),
            const SizedBox(height: 30),
            SizedBox(
                height: 150.0,
                width: MediaQuery.of(context).size.width *0.9,
                child: TextButton.icon(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green,
                    textStyle: const TextStyle(fontSize: 20),
                    padding: const EdgeInsets.all(50.0),
                    shape:  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  icon: const Icon(Icons.wallet_membership_sharp),
                  onPressed: () async {
                    String secretPhrase  = walletViewModel.genWalletMnemonic();
                    List<String> secretList = secretPhrase.split(' ');
                    print(secretList);

                    String publicAddress = await walletViewModel.createWallet(secretPhrase);
                    await  walletViewModel.updateDBWalletAddress( publicAddress);
                    walletViewModel.walletPublicAddress =publicAddress;
                    print('Go to Mnemonic Page');
                    Map<String, dynamic> param = new Map();
                    param["secret_phrase"] = secretList;
                    param["public_address"] = publicAddress;

                    callbackNavigate("/setupWalletMnemonic", param);
                  },
                  label: const Text('Setup a new student card wallet '),
                )
            ),
            const SizedBox(height: 10),
            SizedBox(
                height: 150.0,
                width: MediaQuery.of(context).size.width *0.9,
                child: TextButton.icon(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blueAccent,
                    textStyle: const TextStyle(fontSize: 20),

                    padding: const EdgeInsets.all(50.0),
                    shape:  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  icon: const Icon(Icons.restore_sharp),
                  onPressed: () {
                    callbackNavigate("/recoverWallet", {});
                  },
                  label: const Text('Recover a wallet with your 12 words secret'),
                )
            ),
            // const SizedBox(height: 25),
            // ElevatedButton(onPressed: () async{
            //   await SecureStorage().deleteSecureData("PRIVATE_KEY");
            //   await SecureStorage().deleteSecureData("PUBLIC_KEY");
            // }, child:
            // Text("erase Key Data")
            // ),
            // const SizedBox(height: 25),
            // ElevatedButton(onPressed: () async{
            //   await WalletService().savePrivateKey(privateKey,username!);
            //   await WalletService().savePublicKey(publicKey,username);
            //   }, child:
            //   Text("save Data")
            // ),
            //
            // const SizedBox(height: 5),
            // ElevatedButton(onPressed: () async{
            //   String prikey = await WalletService().loadPrivateKey(username!);
            //   setState(() {
            //     privateKey = prikey; // Set isLoading to false when uploading completes
            //   });
            //   String pubkey = await WalletService().loadPublicAddressString(username!);
            //   setState(() {
            //     publicKey = pubkey; // Set isLoading to false when uploading completes
            //   });
            // }, child:
            // Text("retrieve Key Data")
            // ),
            // ElevatedButton(onPressed: () async{
            //
            //   String mnemonic = WalletService().generateMnemonic();
            //   String priKey = await WalletService().getPrivateKey(mnemonic);
            //   setState(() {
            //     privateKey = priKey; // Set isLoading to false when uploading completes
            //   });
            //   String pubKey = await  WalletService().getPublicKey(priKey);
            //   setState(() {
            //     publicKey = pubKey; // Set isLoading to false when uploading completes
            //   });
            //
            // }, child:
            //   Text("Gen walet Key")
            // ),
            // const SizedBox(height: 5),
            // ElevatedButton(onPressed: () async{
            //   print('private key ' + privateKey );
            //   print('public key ' + publicKey );
            //   double balance = await  WalletService().getWalletBalance(privateKey);
            //   print(balance);
            //   }, child:
            // Text("show wallet amount")
            // ),
          ],
        ),
      ),
    );
  }
}
