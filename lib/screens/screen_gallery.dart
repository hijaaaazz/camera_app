import 'dart:io';

import 'package:flutter/material.dart';

class ScreenGallery extends StatelessWidget {
  final List<File> imageList;

  const ScreenGallery(this.imageList,{super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text('Gallery'),
      ),
      body:Container(
        child: GridView.builder(
          itemCount: imageList.length,
          
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
          itemBuilder: (BuildContext context, int index) {  
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 50,
                width: 50,
                color: Colors.red,
                child: Image(image: FileImage(imageList[index]),
                fit:BoxFit.cover ,),
                
              ),
            );

          },
        ),

      ),
    );
  }
}