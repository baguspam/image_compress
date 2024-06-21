import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'image_compress_method_channel.dart';

abstract class ImageCompressPlatform extends PlatformInterface {
  /// Constructs a ImageCompressPlatform.
  ImageCompressPlatform() : super(token: _token);

  static final Object _token = Object();

  static ImageCompressPlatform _instance = MethodChannelImageCompress();

  /// The default instance of [ImageCompressPlatform] to use.
  ///
  /// Defaults to [MethodChannelImageCompress].
  static ImageCompressPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ImageCompressPlatform] when
  /// they register themselves.
  static set instance(ImageCompressPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
