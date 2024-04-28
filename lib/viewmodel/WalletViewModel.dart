import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_block_student_adm/viewmodel/UserManager.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../model/studentCard.dart';
import '../model/user.dart';
import '../service/WalletService.dart';
import '../view/basePage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:web3dart/web3dart.dart';
import 'package:mobile_block_student_adm/common/CommonVariables.dart';
import 'package:mobile_block_student_adm/common/CommonSetting.dart';

class WalletViewModel with ChangeNotifier , CommonSetting {

  String _walletPublicAddress ="NO_DATA_FOUND";
  late StudentCard _currCard;
  late List<StudentCard> _currCardList;

  //String walletKey ="49689d548b80f5aa6fd92b63d426added2f333071d843f24662aa255056c6c91";
  //String ownerAddress ="0x847a798432444fF70eEccd597fec676425a8420F";
  //final ownerAddress ="0x334073aE2f3d5DfC899d32BDA315f34869A8a908";

  String get walletPublicAddress => _walletPublicAddress;
  StudentCard get currCard => _currCard;
  List<StudentCard>  get currCardList => _currCardList;

  set walletPublicAddress(String value) {
    _walletPublicAddress = value;
    notifyListeners();
  }

  set currCard(StudentCard value) {
    _currCard = value;
    notifyListeners();
  }

  set currCardList(List<StudentCard>  value) {
    _currCardList = value;
    notifyListeners();
  }

  late UserManager _userManager;
  //late List<Programme> featuredProgramList;

  UserManager get userManager => _userManager;


  set userManager(UserManager value) {
    _userManager = value;
    notifyListeners();
  }

  WalletViewModel(BuildContext context) {
    //_userManager = Provider.of<UserManager>(context);
  }

  String genWalletMnemonic()  {
    return WalletService().generateMnemonic();
  }

  Future<void> loadWalletPublicAddress() async {
    User? user = userManager.user;
    String privateKey = await WalletService().loadPrivateKey(user!.email);
    String publicAddress = await WalletService().loadPublicAddressString(user!.email);
    await WalletService().savePrivateKey(privateKey,user!.email);
    await WalletService().savePublicKey(publicAddress,user!.email);
    print(publicAddress);
    walletPublicAddress = publicAddress;
  }

  Future<String> createWallet(String mnemonic)  async{
    User? user = userManager.user;
    bool validPhrase = WalletService().validateMnemonic(mnemonic);
    if (validPhrase) {
      String privateKey = await WalletService().getPrivateKey(mnemonic);
      String publicAddress = await WalletService().getPublicKey(privateKey);
      await WalletService().savePrivateKey(privateKey,user!.email);
      await WalletService().savePublicKey(publicAddress,user!.email);
      return publicAddress;
    } else {
      return "INVALID";
    }
  }


  Future<void> getOwnedTokens() async {
    log("start get OwnerTokens");
    final client = Web3Client(CommonVariables.rpcUrl, http.Client());

    final abiJson  = await rootBundle.loadString('assets/scolaire_abi.json');
    log('abiJson' + abiJson);

    final abi = jsonDecode(abiJson);
    log(abi['abi'].toString());
    final ownedStudentCard = <StudentCard>[];
    try {
      log('start get contract: $CommonVariables.contractAddress');
      final contract = DeployedContract(
        ContractAbi.fromJson(jsonEncode(abi['abi']), 'Scolaire'), // Replace with your contract name
        EthereumAddress.fromHex(CommonVariables.contractAddress),
      );
      log('start get balance of ' + walletPublicAddress);
      final balance = await client.call(
        contract: contract,
        function: contract.function('balanceOf'),
        params: [EthereumAddress.fromHex(walletPublicAddress)],
      );
      print('start get balance count :' + balance!.toString());
      print(balance[0].toInt());
      for (var i = 0; i < balance[0].toInt(); i++) {
        final tokenId = await client.call(
          contract: contract,
          function: contract.function('tokenOfOwnerByIndex'),
          params: [EthereumAddress.fromHex(walletPublicAddress), BigInt.from(i)],
        );
        print('tokenId');
        print(tokenId);
        final tokenURI = await client.call(
          contract: contract,
          function: contract.function('tokenURI'),
          params: [tokenId[0]],
        );

        print(tokenURI[0]);

        //get Json metadata
        final response = await http.get(Uri.parse(tokenURI[0]));
        Map<String, dynamic> metadata ={};
        if (response.statusCode == 200) {
          metadata = json.decode(response.body);

          //String imageUrl = await getImageUrl(metadata['image']);
          final imageResponse = await http.get( Uri.parse(metadata['image']));
          metadata["image"] = imageResponse.body;
          print(metadata);
        } else {
          throw Exception('Failed to load token metadata');
        }
        StudentCard card = StudentCard.fromMetadata(metadata, studentNo: "32165463",validUntil :"2025-05-05" , contractAddress : CommonVariables.contractAddress, hashValue :"");
        print(card);
        ownedStudentCard.add(card);
      }
      _currCardList = ownedStudentCard;
      print("end of get owner tokens");
    } catch (e) {
      log("",error: e );
      throw Exception('Failed retrieve Student Card list');
    }
  }




  Future<void> getStudentCardList() async {

    try {


     // File? scard1 = ;
      StudentCard card1 = StudentCard(
          imageUrl: publicUrl + 'img/HKIT_CARD.jpg' ,
          //imageUrl: file1.path,
          tokenId : 123,
          contractAddress: '#345234534te43535',
          hashValue: 'brefgtegretetr34545',
          studentNo:'32360501',
          validUntil: '2024-05-31',
          //imageData :  File(file1.path) ,
      );
      StudentCard card2 = StudentCard(
         imageUrl: publicUrl + 'img/UWL_CARD.jpg' ,
        //imageUrl: file1.path,
        tokenId : 124,
        contractAddress: '#3erw34534534te43535',
        hashValue: 'gdfgdfdgerfe343534534ret',
          studentNo:'12341234',
        validUntil: '2024-05-31',
        //imageData :  File(file1.path) ,
      );
      StudentCard card3 = StudentCard(
         imageUrl: publicUrl + 'img/MARY_CARD.jpg' ,
        //imageUrl: file1.path,
        tokenId : 12,
        contractAddress: '#345234534dte43535',
        hashValue: 'brefdgtegsdfretetr34545',
          studentNo:'12341234',
        validUntil: '2023-05-31',
       // imageData :  File(file1.path) ,
      );
      // Parse the string as JSON using the jsonDecode function
      List<StudentCard> cardList =  [];
      cardList.add(card1);
      cardList.add(card2);
      cardList.add(card3);
      _currCardList = cardList;


    } catch (e) {
      log("",error: e );
      throw Exception('Failed retrieve Student Card list');
    }
  }

  Future<void> updateDBWalletAddress(String wallAddress)  async {
    Map<String, dynamic>  valueMap = {};
    valueMap['pk'] = userManager.user?.uid;
    valueMap['sk'] = 'CAND';
    valueMap['wallet_address'] = wallAddress;
    try {
      Map<String, dynamic>  itemMap= await userManager.updateDBUser(valueMap);
      userManager.user?.walletAddress = wallAddress;
      notifyListeners();
    } catch (e) {
      log("",error: e );
      throw Exception('Failed update Wallet Address in DB');
    }

  }

}
