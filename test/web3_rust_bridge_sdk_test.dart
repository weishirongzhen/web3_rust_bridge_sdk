import 'package:flutter_test/flutter_test.dart';
import 'package:web3_rust_bridge_sdk/web3_rust_bridge_sdk.dart';
import 'package:web3_rust_bridge_sdk/web3_rust_bridge_sdk_platform_interface.dart';
import 'package:web3_rust_bridge_sdk/web3_rust_bridge_sdk_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockWeb3RustBridgeSdkPlatform
    with MockPlatformInterfaceMixin
    implements Web3RustBridgeSdkPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final Web3RustBridgeSdkPlatform initialPlatform = Web3RustBridgeSdkPlatform.instance;

  test('$MethodChannelWeb3RustBridgeSdk is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelWeb3RustBridgeSdk>());
  });

  test('getPlatformVersion', () async {
    Web3RustBridgeSdk web3RustBridgeSdkPlugin = Web3RustBridgeSdk();
    MockWeb3RustBridgeSdkPlatform fakePlatform = MockWeb3RustBridgeSdkPlatform();
    Web3RustBridgeSdkPlatform.instance = fakePlatform;

    expect(await web3RustBridgeSdkPlugin.getPlatformVersion(), '42');
  });
}
