import 'package:ed25519_hd_key/ed25519_hd_key.dart';
import 'package:web3dart/credentials.dart';
import 'package:bip39/bip39.dart' as bip39;
import "package:hex/hex.dart";
import 'package:http/http.dart'; //You can also import the browser version
import 'package:web3dart/web3dart.dart';
import '../view/basePage.dart';
import 'SecureStorageService.dart';
import 'package:mobile_block_student_adm/common/CommonVariables.dart';
import 'package:mobile_block_student_adm/common/CommonSetting.dart';
class WalletService with CommonSetting {

  WalletService._privateConstructor();

  static final WalletService _instance = WalletService._privateConstructor();



  factory WalletService() {
    return _instance;
  }

  Future<void> savePrivateKey(String key,String username) async {
    await SecureStorage().writeSecureData("PRIVATE_KEY$username",key);
  }

  Future<void> savePublicKey(String key,String username) async {
    await SecureStorage().writeSecureData("PUBLIC_KEY$username",key);
  }


  Future<String> loadPrivateKey(String username) async {
    String privateKey = await SecureStorage().readSecureData("PRIVATE_KEY$username");
    return privateKey;
  }

  Future<String> loadPublicAddressString(String username) async {
    String publicAddress = await SecureStorage().readSecureData("PUBLIC_KEY$username");
    return publicAddress;
  }

  String generateMnemonic() {
    String passphrase = bip39.generateMnemonic();
    print(passphrase);
    return passphrase;
  }

  bool validateMnemonic(String mnemonic) {
    return bip39.validateMnemonic(mnemonic);
  }


  Future<String> getPrivateKey(String mnemonic) async {
    final seed = bip39.mnemonicToSeed(mnemonic);
    final master = await ED25519_HD_KEY.getMasterKeyFromSeed(seed);
    String privateKey = HEX.encode(master.key);
    print(privateKey);
    return privateKey;
  }

  Future<String> getPublicKey(String privateKey) async {
    final private = EthPrivateKey.fromHex(privateKey);
    EthereumAddress publicKey = private.address;
    print(publicKey.hex);
    return publicKey.hex;
  }

  Future<double> getWalletBalance(String addressString) async {
    var httpClient = Client();
    var client = Web3Client(CommonVariables.rpcUrl, httpClient);
    print(CommonVariables.rpcUrl);
    print(addressString);
    var credentials = EthPrivateKey.fromHex(addressString);

    var address = credentials.address;
    EtherAmount balance = await client.getBalance(address);

    print("public address: " + addressString);

    print(balance.getInEther);
    print(balance.getValueInUnit(EtherUnit.ether));
    return balance.getValueInUnit(EtherUnit.ether);
  }


}