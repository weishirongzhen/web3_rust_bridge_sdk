import 'dart:developer';

import 'package:web3_rust_bridge_sdk/web3_rust_bridge_sdk.dart' as aleo;

String logTag = "web3_rust_bridge";

class TransferUtil {
  TransferUtil._();

  /// 返回public转账需要的代理数据
  /// 返回值
  /// 0-> authorization
  /// 1-> program
  /// 2-> fee_authorization
  /// [amount] double值，实际值
  /// [priorityFee] min 0.28
  static Future<List<String>> generatePublicTransferDelegate({
    required String privateKey,
    required String recipient,
    required double amount,
    double fee = 0.28,
  }) {
    try {
      return aleo.delegateTransferPublic(
        privateKey: privateKey,
        amountCredits: amount,
        recipient: recipient,
        feeCredits: fee,
      );
    } catch (e) {
      log("$logTag: $e");
      rethrow;
    }
  }

  /// recommend value for execute public transfer
  static double getPublicTransferFee({bool defaultValue = true}) {
    if (defaultValue) {
      return 0.28;
    } else {
      throw Error.safeToString("currently only support defaultValue");
    }
  }

  /// ALEO 主币精度
  static int get getDecimal => 6;
}
