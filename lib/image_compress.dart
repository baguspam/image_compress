
import 'image_compress_platform_interface.dart';
import 'package:flutter/services.dart';

class ImageCompress {
  static const MethodChannel _channel = MethodChannel('compress_image');

  Future<String?> getPlatformVersion() {
    return ImageCompressPlatform.instance.getPlatformVersion();
  }

  static Future<String> compress({String? imageSrc, int? desiredQuality, String? watermarkText, bool isDateWatermark=false, int? maxWidth, int? maxHeight}) async {
    final Map<String, dynamic> params = <String, dynamic> {
      'filePath': imageSrc,
      'desiredQuality': desiredQuality,
      'watermarkText': watermarkText,
      'isDateWatermark': isDateWatermark,
      'maxWidth': maxWidth,
      'maxHeight': maxHeight,
    };
    final String filePath = await _channel.invokeMethod('compressImage', params);
    return filePath;
  }
}
