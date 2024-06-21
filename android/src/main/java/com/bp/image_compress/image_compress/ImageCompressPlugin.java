package com.bp.image_compress.image_compress;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import java.io.ByteArrayOutputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.FileNotFoundException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** ImageCompressPlugin */
public class ImageCompressPlugin implements FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "compress_image");
    channel.setMethodCallHandler(this);
  }


  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("compressImage")) {
      try {
        String filePath = call.argument("filePath");
        Integer desiredQuality = call.argument("desiredQuality");
        Integer maxWidthValue = call.argument("maxWidth");
        Integer maxHeightValue = call.argument("maxHeight");
        String watermarkText = call.argument("watermarkText");
        boolean isDateWatermark = call.argument("isDateWatermark");

        int maxWidth = 1280;
        int maxHeight = 960;
        int desiredQualityInt = 100;


        if (filePath != null) {
          if(desiredQuality != null){
            desiredQualityInt = desiredQuality.intValue();
          }
          Bitmap bitmap = BitmapFactory.decodeFile(filePath);

          // Resize the image
          if(maxWidthValue!=null){
            maxWidth = maxWidthValue.intValue();
          }

          if(maxHeightValue!=null){
            maxHeight = maxHeightValue.intValue();
          }
          bitmap = resizeBitmap(bitmap, maxWidth, maxHeight);

          // Add watermark
          if(watermarkText != null || isDateWatermark){
            bitmap = addWatermark(bitmap, watermarkText, isDateWatermark);
          }

          // Compress the image
          ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
          bitmap.compress(Bitmap.CompressFormat.JPEG, desiredQualityInt, byteArrayOutputStream);

          // Save the compressed image to the same file
          OutputStream imageFile = new FileOutputStream(filePath);
          byteArrayOutputStream.writeTo(imageFile);
          imageFile.close();
          byteArrayOutputStream.close();

          result.success("Image compressed and watermarked successfully");
        } else {
          result.error("INVALID_ARGUMENT", "File path, desired quality, or watermark text is null", null);
        }
      } catch (FileNotFoundException e) {
        result.error("FILE_NOT_FOUND", "File not found: " + e.getMessage(), null);
      } catch (IOException e) {
        result.error("IO_ERROR", "I/O error occurred: " + e.getMessage(), null);
      } catch (Exception e) {
        result.error("UNKNOWN_ERROR", "An unknown error occurred: " + e.getMessage(), null);
      }
    }else if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    }else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }

  private Bitmap resizeBitmap(Bitmap bitmap, int maxWidth, int maxHeight) {
    int width = bitmap.getWidth();
    int height = bitmap.getHeight();

    float aspectRatio = (float) width / height;
    if (width > height) {
      width = maxWidth;
      height = Math.round(width / aspectRatio);
    } else {
      height = maxHeight;
      width = Math.round(height * aspectRatio);
    }

    return Bitmap.createScaledBitmap(bitmap, width, height, true);
  }

  private Bitmap addWatermark(Bitmap original, String watermarkText1, boolean isDate) {
    int w = original.getWidth();
    int h = original.getHeight();
    Bitmap result = Bitmap.createBitmap(w, h, original.getConfig());
    Canvas canvas = new Canvas(result);
    canvas.drawBitmap(original, 0, 0, null);

    Paint paint = new Paint();
    paint.setColor(Color.RED); // Change color as needed
    paint.setTextSize(24); // Change text size as needed
    paint.setAntiAlias(true);
    paint.setUnderlineText(false);

    Paint paint2 = new Paint();
    paint2.setColor(Color.WHITE); // Change color as needed
    paint2.setTextSize(24); // Change text size as needed
    paint2.setAntiAlias(true);
    paint2.setUnderlineText(false);

    // Draw the watermark text at the bottom right corner
    if(watermarkText1!=null){
      canvas.drawText(watermarkText1, 30, 30, paint2); // Adjust position as needed
    }
    if(isDate){
      String nowTime = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault()).format(new Date());
      canvas.drawText(nowTime, w - 234, h - 30, paint2); // Adjust position as needed
    }
    return result;
  }
}
