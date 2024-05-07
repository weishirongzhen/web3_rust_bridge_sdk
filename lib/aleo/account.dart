import 'package:bip39_mnemonic/bip39_mnemonic.dart';
import 'package:convert/convert.dart';

import '../web3_rust_bridge_sdk.dart';
import 'delegate_transaction_data.dart';

class AleoAccount {
  late String privateKey;
  late String viewKey;
  late String address;
  late String extendedPrivateKey;
  late String derivePath;

  /// AleoAccount from mnemonic
  /// accountIndex 0 for default account, next account index will be will 1
  AleoAccount.fromMnemonic(
    String mnemonic, {
    int accountIndex = 0,
  }) {
    final m = Mnemonic.fromSentence(mnemonic, Language.english);
    final seedHex = hex.encode(m.seed);
    extendedPrivateKey = seedHex;
    String path = "m/44'/0'/$accountIndex'/0'";
    final keys = deriveAleoPath(path, seedHex);
    privateKey = privateKeyFromSeed(seed: keys.key!);
    viewKey = privateKeyToViewKey(privateKey: privateKey);
    address = privateKeyToAddress(privateKey: privateKey);
    derivePath = path;
  }

  /// AleoAccount from extended privateKey aka seed
  /// accountIndex 0 for default account, next account index will be will 1
  AleoAccount.fromExtendedPrivateKey(
    this.extendedPrivateKey, {
    int accountIndex = 0,
  }) {
    String path = "m/44'/0'/$accountIndex'/0'";
    final keys = deriveAleoPath(path, extendedPrivateKey);
    privateKey = privateKeyFromSeed(seed: keys.key!);
    viewKey = privateKeyToViewKey(privateKey: privateKey);
    address = privateKeyToAddress(privateKey: privateKey);
    derivePath = path;
  }

  AleoAccount.fromPrivateKey(this.privateKey) {
    extendedPrivateKey = '';
    viewKey = privateKeyToViewKey(privateKey: privateKey);
    address = privateKeyToAddress(privateKey: privateKey);
    derivePath = '';
  }

  /// generate data for rpc to broadcast public transfer
  /// [privateKey] sender privateKey
  /// [recipient] recipient address
  /// [amount] double value, amount should be human readable, it will convert to real microCredit on rust side
  /// [fee] fee should be human readable, it will convert to real microCredit on rust side
  static Future<AleoDelegateTransferData> generatePublicTransfer({
    required String privateKey,
    required String recipient,
    required double amount,
    double fee = 0.28,
  }) async {
    final result = await generatePublicTransferDelegateData(
      privateKey: privateKey,
      recipient: recipient,
      amountCredits: amount,
      feeCredits: fee,
    );
    return AleoDelegateTransferData.public(
      authorization: result[0],
      program: result[1],
      feeAuthorization: result[2],
    );
  }

  /// default public transfer is 0.28
  static double getPublicTransferFee() {
    return 0.28;
  }

  /// get public aleo balance
  static Future<double> getPublicAleoBalance(
    String address, {
    String url = '',
    String networkId = '',
  }) async {
    return getPublicBalance(
      url: url,
      networkId: networkId,
      address: address,
    );
  }
}
