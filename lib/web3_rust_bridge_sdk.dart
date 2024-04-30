export 'rust/api/aleo.dart';
export 'aleo/aleo_hd_key.dart';
export 'aleo/transfer_util.dart';
import 'package:web3_rust_bridge_sdk/rust/frb_generated.dart';

import 'web3_rust_bridge_sdk_platform_interface.dart';

class Web3RustBridgeSdk {
  static bool _libInit = false;
  Future<String?> getPlatformVersion() {
    return Web3RustBridgeSdkPlatform.instance.getPlatformVersion();
  }

  static Future<void> initWeb3RustBridge() async {
    if (!_libInit) {
      try {
        await RustLib.init();
        _libInit = true;
      } catch (e) {
        _libInit = false;
        rethrow;
      }
    }
  }

  static void deposeAleo() {
    RustLib.dispose();
    _libInit = false;
  }
}
