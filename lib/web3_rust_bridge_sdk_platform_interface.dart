import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'web3_rust_bridge_sdk_method_channel.dart';

abstract class Web3RustBridgeSdkPlatform extends PlatformInterface {
  /// Constructs a Web3RustBridgeSdkPlatform.
  Web3RustBridgeSdkPlatform() : super(token: _token);

  static final Object _token = Object();

  static Web3RustBridgeSdkPlatform _instance = MethodChannelWeb3RustBridgeSdk();

  /// The default instance of [Web3RustBridgeSdkPlatform] to use.
  ///
  /// Defaults to [MethodChannelWeb3RustBridgeSdk].
  static Web3RustBridgeSdkPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [Web3RustBridgeSdkPlatform] when
  /// they register themselves.
  static set instance(Web3RustBridgeSdkPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
