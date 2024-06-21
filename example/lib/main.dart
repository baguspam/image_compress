import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:image_compress/image_compress.dart';
import 'package:image_picker/image_picker.dart';

Future<Null> main() async {
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  File? imageFile;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  initState() {
    super.initState();
  }

  Future compressNow(ImageSource imageSource) async {
    XFile? img = await ImagePicker().pickImage(source: imageSource,
        imageQuality: 100, preferredCameraDevice: CameraDevice.front);
    //Source of the image in _futureImage
    imageFile = File(img!.path);
    print("FILE SIZE BEFORE: " + imageFile!.lengthSync().toString());
    await ImageCompress.compress(imageSrc: imageFile!.path,
        desiredQuality: 90,
        watermarkText: 'Test lorem ipsum',
        maxWidth: 1280,
        maxHeight: 1080,

    ); //desiredQuality ranges from 0 to 100
    print("FILE SIZE  AFTER: " + imageFile!.lengthSync().toString());


    setState(() {
      imageFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Compress Image Example App'),
        ),
        body: Center(
          child: imageFile == null
              ? const Text('No image selected.')
              : Image.file(imageFile!),
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () {
                compressNow(ImageSource.gallery);
              },
              tooltip: 'Pick Image',
              child: const Icon(Icons.photo),
            ),
            const SizedBox(height: 10,),
            FloatingActionButton(
              onPressed: () {
                compressNow(ImageSource.camera);
              },
              tooltip: 'Pick Image',
              child: const Icon(Icons.add_a_photo),
            ),
          ],
        ),
      ),
    );
  }

  void showInSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }


  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

}