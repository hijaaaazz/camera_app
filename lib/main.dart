import 'package:camera_app/screens/screen_main.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

void main(List<String> args) async{

  WidgetsFlutterBinding.ensureInitialized();

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