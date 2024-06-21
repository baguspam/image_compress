#include "include/image_compress/image_compress_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "image_compress_plugin.h"

void ImageCompressPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  image_compress::ImageCompressPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
