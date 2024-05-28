import 'dart:io';

import 'package:flutter/services.dart';

class FlutterImageClipboard {
  static const platform = MethodChannel('clipboard_image');

  Future<void> copyImageToClipboard(File imageFile) async {
    try {
      await platform
          .invokeMethod('copyImageToClipboard', {'path': imageFile.path});
    } on PlatformException catch (e) {
      print("Failed to copy image to clipboard: ${e.message}");
    }
  }
}
