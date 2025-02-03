import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:holdwise/app/config/colors.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
// 
class FullScreenCamera extends StatefulWidget {
  @override
  _FullScreenCameraState createState() => _FullScreenCameraState();
}

class _FullScreenCameraState extends State<FullScreenCamera>
    with WidgetsBindingObserver {
  late CameraController _controller;
  late List<CameraDescription> _cameras;
  bool isCameraInitialized = false;
  Color _borderColor = AppColors.success; // Default frame color

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    WidgetsBinding.instance.addObserver(this);

    // Lock orientation to portrait
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void dispose() {
    _controller.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Handles app lifecycle states (e.g., background, foreground)
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.paused) {
      _disposeCamera();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  /// Initializes the front camera with error handling
  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      final frontCamera = _cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => _cameras.first,
      );

      _controller = CameraController(
        frontCamera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _controller.initialize();
      if (!mounted) return;

      setState(() {
        isCameraInitialized = true;
      });
    } catch (e) {
      print("Error initializing camera: $e");
    }
  }

  /// Dispose the camera when not in use
  void _disposeCamera() {
    if (isCameraInitialized) {
      _controller.dispose();
      setState(() {
        isCameraInitialized = false;
      });
    }
  }

  /// Change the border color dynamically
  void _changeBorderColor() {
    setState(() {
      if (_borderColor == AppColors.success) {
        _borderColor = AppColors.error;
      } else if (_borderColor == AppColors.error) {
        _borderColor = AppColors.warning;
      } else {
        _borderColor = AppColors.success;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          if (isCameraInitialized)
            Positioned.fill(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller.value.previewSize?.height ?? screenWidth,
                  height: _controller.value.previewSize?.width ?? screenHeight,
                  child: RotatedBox(
                    quarterTurns: 1,
                    child: Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationY(math.pi),
                      child: CameraPreview(_controller),
                    ),
                  ),
                ),
              ),
            )
          else
            Center(child: CircularProgressIndicator()),

          // Border overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: _borderColor, width: screenWidth * 0.025),
                borderRadius: BorderRadius.circular(screenWidth * 0.09),
              ),
            ),
          ),

          // Change frame color button
          Positioned(
            bottom: screenHeight * 0.2,
            left: screenWidth * 0.25,
            right: screenWidth * 0.25,
            child: ElevatedButton(
              onPressed: _changeBorderColor,
              child: Text("Change Frame Color"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                textStyle: TextStyle(fontSize: screenWidth * 0.05),
              ),
            ),
          ),
        ],
      ),
    );
  }
}