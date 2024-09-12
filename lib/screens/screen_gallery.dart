import 'dart:typed_data';
import 'package:camera_app/screens/screen_fullscreen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ScreenGallery extends StatefulWidget {
  const ScreenGallery({super.key});

  @override
  ScreenGalleryState createState() => ScreenGalleryState();
}

class ScreenGalleryState extends State<ScreenGallery> {
  late Box imageBox;

  @override
  void initState() {
    super.initState();
    imageBox = Hive.box('imageBox');
  }
  void refreshGallery() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gallery'),
      ),
      body: GridView.builder(
        itemCount: imageBox.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemBuilder: (BuildContext context, int index) {
          Uint8List imageBytes = imageBox.getAt(index);
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ScreenFullImage(
                    imageBytes: imageBytes,
                    index: index,
                    onDelete: refreshGallery,
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: Container(
                height: 50,
                width: 50,
                color: Colors.blue,
                child: Image.memory(
                  imageBytes,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
