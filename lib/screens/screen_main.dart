import 'dart:io';

import 'package:camera/camera.dart';
import 'package:camera_app/screens/screen_gallery.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:media_scanner/media_scanner.dart';

class ScreenMain extends StatefulWidget {
final List <CameraDescription> cameras ;

  const ScreenMain({super.key, required this.cameras});

  @override
  State<ScreenMain> createState() => _ScreenMainState();
}

class _ScreenMainState extends State<ScreenMain> {
  late CameraController cameraController;
  late Future<void> cameravalue;
  bool isFlashOn = false;
  bool isRearCameraOn=true;

  late List <File> imageList=[];

  Future<File> saveImage(XFile image)async {
    final downloadPath = await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS);
    final filename ='${DateTime.now().millisecondsSinceEpoch}.png';
    final file = File('$downloadPath/$filename');

    try{
      await file.writeAsBytes(await image.readAsBytes());
      }catch(_){}

      return file;

      
  }

  void takeImage() async{
    XFile? image;

    if(cameraController.value.isTakingPicture|| !cameraController.value.isInitialized){
      return;
    }
    if(isFlashOn== false){
      await cameraController.setFlashMode((FlashMode.off));
    }else{
      await cameraController.setFlashMode(FlashMode.torch);
    }
    image= await cameraController.takePicture();
    if(cameraController.value.flashMode== FlashMode.torch){
      setState(() {
        cameraController.setFlashMode(FlashMode.off);
      });
    }
    final file = await saveImage(image);

    setState(() {
        imageList.add(file);
      });

      MediaScanner.loadMedia(path: file.path);

    stdout.write(imageList);
  }

  void startCamera(int camera){
    cameraController = CameraController(
      widget.cameras[camera],
      ResolutionPreset.high,enableAudio: true,
      );
      cameravalue=cameraController.initialize();
      
  }

  @override
  void initState() {
    startCamera(0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed:takeImage,
      backgroundColor: Colors.white,
      shape: CircleBorder(),
      child: Icon(Icons.camera,size:40 ,),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      
      body: Stack(
        children: [
          FutureBuilder(future: cameravalue, builder: (context,snapshot){
            if (snapshot.connectionState== ConnectionState.done){
              return SizedBox(
                width: size.width,
                height: size.height,
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: 100,
                    child: CameraPreview(cameraController),
                  ),
                ),
              );
            }else{
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
          SafeArea
          (child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(left: 270,top: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        isFlashOn= !isFlashOn;
                      });
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(40, 255, 255, 255),
                        shape: BoxShape.circle,
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: isFlashOn? 
                          Icon(Icons.flash_on)
                          :Icon(Icons.flash_off),
                          
                          
                          ),
                        
                    ),
                  ),
                  Gap(10),
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        isRearCameraOn= !isRearCameraOn;
                      });
                      isRearCameraOn? startCamera(0): startCamera(1);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(40, 255, 255, 255),
                        shape: BoxShape.circle,
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: isRearCameraOn? 
                          Icon(Icons.camera_rear)
                          :Icon(Icons.camera_front),
                          
                          
                          ),
                        
                    ),
                  ),
                  
                ],
              ),
            ),)),
            Align(
              alignment: Alignment.bottomLeft,
              child: GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder:(context) =>  ScreenGallery(imageList)));
                },
                child: Padding(
                  padding: const EdgeInsets.only(left:10,bottom: 10),
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromARGB(0, 255, 255, 255),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image(image: imageList.isEmpty? AssetImage('lib/assets/image_default.jpg') : FileImage(imageList[imageList.length-1]),
                      fit: BoxFit.cover,),
                    ),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
  
  
}