import 'package:camera/camera.dart';
import 'dart:async';

class CameraHandler {
  CameraController? _controller;
  List<CameraDescription>? _cameras;

  Future<void> initialize() async {
    _cameras = await availableCameras();
    print(_cameras);
    if (_cameras!.isNotEmpty) {
      _controller = CameraController(_cameras![0], ResolutionPreset.low);
      await _controller!.initialize();
    }
  }



  Future<void> captureImage() async {
    if (_controller != null && _controller!.value.isInitialized) {
      print("Capturing image...");
      await _controller!.takePicture();
      print("Image captured");
    }
  }

  void dispose() {
    _controller?.dispose();
  }
}
