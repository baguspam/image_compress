import 'package:flutter_test/flutter_test.dart';
import 'package:image_compress/image_compress.dart';
import 'package:image_compress/image_compress_platform_interface.dart';
import 'package:image_compress/image_compress_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockImageCompressPlatform
    with MockPlatformInterfaceMixin
    implements ImageCompressPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final ImageCompressPlatform initialPlatform = ImageCompressPlatform.instance;

  test('$MethodChannelImageCompress is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelImageCompress>());
  });

  test('getPlatformVersion', () async {
    ImageCompress imageCompressPlugin = ImageCompress();
    MockImageCompressPlatform fakePlatform = MockImageCompressPlatform();
    ImageCompressPlatform.instance = fakePlatform;

    expect(await imageCompressPlugin.getPlatformVersion(), '42');
  });
}
