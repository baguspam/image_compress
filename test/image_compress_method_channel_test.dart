import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_compress/image_compress_method_channel.dart';

void main() {
  MethodChannelImageCompress platform = MethodChannelImageCompress();
  const MethodChannel channel = MethodChannel('image_compress');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      if (methodCall.method == 'getPlatformVersion') {
        return '42';
      }
      return null;
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
