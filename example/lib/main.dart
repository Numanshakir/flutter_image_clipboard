import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_clipboard/flutter_image_clipboard.dart';

import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  File imageFile = File('');
  FlutterImageClipboard flutterImageClipboard = FlutterImageClipboard();

  getImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
// Pick an image.
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        imageFile = File("${image.path}");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Flutter Image Clipboard'),
          ),
          body: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (imageFile.path.isNotEmpty)
                  Image(image: FileImage(imageFile), width: 300, height: 300),
                SizedBox(
                  height: 30,
                ),
                MaterialButton(
                  color: Colors.blue,
                  onPressed: () {
                    if (imageFile.path.isEmpty) {
                      getImageFromGallery();
                    } else {
                      flutterImageClipboard.copyImageToClipboard(imageFile);
                    }
                  },
                  child: Text(
                    imageFile.path.isEmpty
                        ? 'Upload Image'
                        : 'Copy image clipboard',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                if (imageFile.path.isNotEmpty)
                  MaterialButton(
                    color: Colors.blue,
                    onPressed: () {
                      setState(() {
                        imageFile = File('');
                      });
                    },
                    child: Text(
                      'Remove Image',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
              ],
            ),
          )),
    );
  }
}
