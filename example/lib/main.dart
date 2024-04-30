import 'package:convert/convert.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:web3_rust_bridge_sdk/web3_rust_bridge_sdk.dart' as aleo;

import 'package:bip39_mnemonic/bip39_mnemonic.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await aleo.Web3RustBridgeSdk.initWeb3RustBridge();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final testMnemonic =
      "lesson maid remove boring swift floor produce crouch kangaroo action kick pole";
  String privateKey0 = "";
  String viewKey0 = "";
  String address0 = "";
  String recipient =
      "aleo1m8gqcxedmqfp2ylh8f96w6n3z7zw0ucahenq0symvxpqg0f8sugqd4we6f";

  String delegateDataText = "waiting";

  bool transferring = false;

  String error = "";

  int timeInSeconds = 0;

  @override
  void initState() {
    genAddress(0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Aleo SDK'),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "mnemonic:",
                style: TextStyle(fontSize: 20),
              ),
              Text(
                testMnemonic,
                style: const TextStyle(fontSize: 20),
              ),
              const Divider(),
              titleContentRow('[PrivateKey-0]', privateKey0),
              titleContentRow('[ViewKey-0]', viewKey0),
              titleContentRow('[Address-0]', address0),
              const Divider(),
              const Text(
                "public transfer to ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                recipient,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.blue),
              ),
              const Divider(),
              const Text(
                "when transfering do not exit this screen, or else will transfer error, but you credits will be safe",
                style: TextStyle(color: Colors.redAccent, fontSize: 12),
              ),
              Row(
                children: [
                  ElevatedButton(
                      onPressed: () {
                        generateDelegateData();
                      },
                      child: const Text("生成代理证明信息")),
                  if (transferring) const CircularProgressIndicator(),
                ],
              ),
              Text("delegate data = $delegateDataText"),
              if (timeInSeconds != 0) Text("take = ${timeInSeconds ~/ 1000} s"),
              if (error.isNotEmpty) Text("error = $error"),
            ],
          ),
        ),
      ),
    );
  }

  void genAddress(int index) async {
    final seed0 = seedFromDerivePath(index);
    privateKey0 = aleo.privateKeyFromSeed(seed: seed0);
    viewKey0 = aleo.privateKeyToViewKey(privateKey: privateKey0);
    address0 = aleo.privateKeyToAddress(privateKey: privateKey0);
    setState(() {});
  }

  Uint8List seedFromDerivePath(int index) {
    /// aleo hd account derive path m/44'/0'/<account_index>'/0' and default account_index = 0

    final path = "m/44'/0'/$index'/0'";
    final m = Mnemonic.fromSentence(testMnemonic, Language.english);
    final seedHex = hex.encode(m.seed);
    final keys = aleo.derivePath(path, seedHex);
    return keys.key!;
  }

  Widget titleContentRow(String title, String content) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("$title : "),
        Expanded(child: Text(content)),
      ],
    );
  }

  void generateDelegateData() async {
    final startTime = DateTime.now().millisecondsSinceEpoch;
    setState(() {
      transferring = true;
      timeInSeconds = 0;
      delegateDataText = "waiting";
    });

    await Future.delayed(const Duration(seconds: 1), () async {
      try {
        delegateDataText =
            (await aleo.TransferUtil.generatePublicTransferDelegate(
          privateKey: privateKey0,
          recipient: recipient,
          amount: 0.10,
          fee: 0.28,
        ))
                .join("\n");
      } catch (e) {
        error = e.toString();
      }
    });
    final endTime = DateTime.now().millisecondsSinceEpoch;

    setState(() {
      transferring = false;
      timeInSeconds = endTime - startTime;
    });
  }
}
