import 'package:camera_app/screens/screen_main.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main(List<String> args) async{
 
 



  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('imageBox');
  await Hive.openBox('filenameBox');

  final cameras = await availableCameras();

  runApp( MyApp(cameras: cameras,));
}

class MyApp extends StatelessWidget {
  final List <CameraDescription> cameras;
  const MyApp({super.key, required this.cameras});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ScreenMain(cameras:cameras),
    );
  }
}