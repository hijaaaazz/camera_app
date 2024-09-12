import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:camera_app/screens/screen_gallery.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:gap/gap.dart';

class ScreenMain extends StatefulWidget {
  final List<CameraDescription> cameras;

  const ScreenMain({super.key, required this.cameras});

  @override
  State<ScreenMain> createState() => _ScreenMainState();
}

class _ScreenMainState extends State<ScreenMain> {
  late CameraController cameraController;
  late Future<void> cameraValue;
  bool isFlashOn = false;
  bool isRearCameraOn = true;

  final Box imageBox = Hive.box('imageBox');

  void takeImage() async {
    XFile? image;

    if (cameraController.value.isTakingPicture || !cameraController.value.isInitialized) {
      return;
    }

    if (isFlashOn == false) {
      await cameraController.setFlashMode(FlashMode.off);
    } else {
      await cameraController.setFlashMode(FlashMode.torch);
    }

    image = await cameraController.takePicture();
    if (cameraController.value.flashMode == FlashMode.torch) {
      setState(() {
        cameraController.setFlashMode(FlashMode.off);
      });
    }

    Uint8List imageBytes = await image.readAsBytes();
    await imageBox.add(imageBytes);

    setState(() {});
  }

  void startCamera(int camera) {
    cameraController = CameraController(
      widget.cameras[camera],
      ResolutionPreset.high,
      enableAudio: true,
    );
    cameraValue = cameraController.initialize();
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
     
      body: Stack(
        children: [
          FutureBuilder(
            future: cameraValue,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
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
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              color: const Color.fromARGB(255, 0, 0, 0),
              height: 100,
              child: Padding(
                padding: const EdgeInsets.only(top:40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            isFlashOn = !isFlashOn;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: isFlashOn
                              ? const Icon(Icons.flash_on ,color: Colors.white,)
                              : const Icon(Icons.flash_off,color: Colors.white,),
                        ),
                      ),
                      const Gap(10),
                      
                
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: const Color.fromARGB(255, 0, 0, 0),
              height: 160,
             
            ),
          ),
          
          Align(
            alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.only(bottom:35 ),
                child: Row(
                  
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center  ,
                  
                  children: [
                    GestureDetector(
                      onTap:() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ScreenGallery(),
                    ),
                  );
                },
                      child: Container(
                         decoration: BoxDecoration(
                          color: const Color.fromARGB(65, 255, 255, 255),
                          borderRadius: BorderRadius.circular(10)
                        ),
                        width: 60,
                        height: 60 ,
                        child: ClipRRect(
                          
                          
                          borderRadius: BorderRadius.circular(6),
                          child: imageBox.isEmpty
                              ? const Image(
                                  image: AssetImage('lib/assets/image_default.jpg'),
                                  
                                )
                              : Image.memory(
                                  imageBox.getAt(imageBox.length - 1),
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                    ),
                    Container(
                       decoration: BoxDecoration(
                        color: const Color.fromARGB(65, 255, 255, 255),
                        borderRadius: BorderRadius.circular(60)
                      ),
                      width: 100,
                      height:  100 ,
                      child:IconButton(
                        
                        onPressed: takeImage,
                        icon: const Icon(Icons.camera,color: Colors.white,size: 50,),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(65, 255, 255, 255),
                        borderRadius: BorderRadius.circular(10)
                      ),
                      width: 60,
                      height: 60,
                      
                      child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isRearCameraOn = !isRearCameraOn;
                            });
                            isRearCameraOn ? startCamera(0) : startCamera(1);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: isRearCameraOn
                                ? const Icon(Icons.camera_rear,color: Colors.white,)
                                : const Icon(Icons.camera_front,color: Colors.white,),
                          ),
                        ),
                    ),
                            
                            
                    
                  ],
                ),
              ),
            ),
        ]
          ),
          
        
      );
    
  }
}
