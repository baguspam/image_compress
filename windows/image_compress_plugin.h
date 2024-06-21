#ifndef FLUTTER_PLUGIN_IMAGE_COMPRESS_PLUGIN_H_
#define FLUTTER_PLUGIN_IMAGE_COMPRESS_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace image_compress {

class ImageCompressPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  ImageCompressPlugin();

  virtual ~ImageCompressPlugin();

  // Disallow copy and assign.
  ImageCompressPlugin(const ImageCompressPlugin&) = delete;
  ImageCompressPlugin& operator=(const ImageCompressPlugin&) = delete;

 private:
  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace image_compress

#endif  // FLUTTER_PLUGIN_IMAGE_COMPRESS_PLUGIN_H_
