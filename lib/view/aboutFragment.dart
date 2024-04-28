import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../service/SecureStorageService.dart';
import '../service/WalletService.dart';
import '../viewmodel/WalletViewModel.dart';
import 'basePage.dart';

class AboutFragment extends BasePageFragment {

  AboutFragment({super.key, required callbackNavigate})
      : super(callbackNavigate: callbackNavigate);

  //SetupWalletFragment({super.key, required callbackNavigate}) : super(callbackNavigate: callbackNavigate) ;

  @override
  AboutFragmentState createState() {
    return AboutFragmentState();

  }
}


class AboutFragmentState extends BasePageFramentState<AboutFragment> {


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
    String? username = walletViewModel.userManager.user?.email;
    // TODO: implement build
    return Center(
        child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Column(
          children: [
            const SizedBox(height: 10),
            Text("About Page - This is used for testing purpose"),
            const SizedBox(height: 25),
            ElevatedButton(onPressed: () async{
              await SecureStorage().deleteSecureData("PRIVATE_KEY$username");
              await SecureStorage().deleteSecureData("PUBLIC_KEY$username");
            }, child:
            Text("erase Key Data")
            ),
            const SizedBox(height: 25),
            ElevatedButton(onPressed: () async{
              String prikey = await WalletService().loadPrivateKey(username!);
              setState(() {
                privateKey = prikey; // Set isLoading to false when uploading completes
              });
              String pubkey = await WalletService().loadPublicAddressString(username!);
              setState(() {
                publicKey = pubkey; // Set isLoading to false when uploading completes
              });
            }, child:
            Text("retrieve Key Data")
            ),
            const SizedBox(height: 25),
            ElevatedButton(onPressed: () async{
              await WalletService().savePrivateKey(privateKey,username!);
              await WalletService().savePublicKey(publicKey,username!);
            }, child:
            Text("save Key Data")
            ),
            const SizedBox(height: 5),
            ElevatedButton(onPressed: () async{

              String mnemonic = WalletService().generateMnemonic();
              String priKey = await WalletService().getPrivateKey(mnemonic);
              setState(() {
                privateKey = priKey; // Set isLoading to false when uploading completes
              });
              String pubKey = await  WalletService().getPublicKey(priKey);
              setState(() {
                publicKey = pubKey; // Set isLoading to false when uploading completes
              });

            }, child:
            Text("Gen walet Key")
            ),
            const SizedBox(height: 5),
            ElevatedButton(onPressed: () async{
              print('private key ' + privateKey );
              print('public key ' + publicKey );
              double balance = await  WalletService().getWalletBalance(privateKey);
              print(balance);
            }, child:
            Text("show wallet amount")
            ),
          ]
        ),
      ),
    );
  }

}