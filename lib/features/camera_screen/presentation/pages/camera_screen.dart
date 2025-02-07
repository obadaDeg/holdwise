import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:holdwise/app/config/colors.dart';


class FullScreenCamera extends StatefulWidget {
  @override
  _FullScreenCameraState createState() => _FullScreenCameraState();
}

class _FullScreenCameraState extends State<FullScreenCamera>
    with WidgetsBindingObserver {
  late CameraController _controller;
  late List<CameraDescription> _cameras;
  Interpreter? _interpreter;
  List<String> _labels = [];
  bool isCameraInitialized = false;
  // static const _channel = MethodChannel('com.example.pose/keypoints');
  Color _borderColor = AppColors.success; // Default frame color
  Timer? _poseTimer; // Timer for continuous pose checking

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _loadModel();
    WidgetsBinding.instance.addObserver(this);

    // Lock orientation to portrait
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  /// **Load TFLite Model and Labels**
  Future<void> _loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset(
          'assets/pose_classification_model.tflite');
      _labels = await _loadLabels('assets/labels.txt');
      print("✅ Model and labels loaded successfully");

      // Start checking the pose continuously every 2 seconds
      _poseTimer = Timer.periodic(Duration(seconds: 2), (timer) {
        _processPose();
      });
    } catch (e) {
      print("❌ Error loading model: $e");
    }
  }

  /// **Load Labels from File**
  Future<List<String>> _loadLabels(String path) async {
    final String labelsString = await rootBundle.loadString(path);
    return labelsString.split('\n').where((label) => label.isNotEmpty).toList();
  }

  /// **Pose Classification**
  Future<void> _processPose() async {
    if (!isCameraInitialized || _interpreter == null) return;

    try {
      // 👇 TODO: Extract keypoints from camera frame (Use MediaPipe here)
      List<double> keypoints = await _extractKeypoints();
      print("🔑 Keypoints: $keypoints");
      if (keypoints.isNotEmpty) {
        String? result = await classifyPose(keypoints);
        if (result != null) {
          _updateBorderColor(result);
        }
      }
    } catch (e) {
      print("❌ Error processing pose: $e");
    }
  }

  /// **Extract Keypoints from Camera Frame**
  Future<List<double>> _extractKeypoints() async {
    try {
      // Invoke the native method.
      // final List<dynamic> keypoints = await _channel.invokeMethod('getPoseKeypoints');
      // Convert the dynamic list to List<double>.
      // return keypoints.map((e) => e as double).toList();
      return List.filled(33 * 3, 0.0); // Placeholder
    } catch (e) {
      print("❌ Error extracting keypoints: $e");
      // Return a fallback (or you could propagate the error).
      return List.filled(33 * 3, 0.0);
    }
  }

  /// **Run TFLite Model on Extracted Keypoints**
  Future<String?> classifyPose(List<double> keypoints) async {
    if (_interpreter == null) {
      print("❌ Model not loaded yet!");
      return null;
    }

    var input = [keypoints]; // Ensure correct input shape
    var output =
        List.filled(1 * _labels.length, 0.0).reshape([1, _labels.length]);

    _interpreter!.run(input, output);

    int predictedIndex = output[0].indexOf(
        output[0].reduce((a, b) => math.max<double>(a.toDouble(), b.toDouble())));

    return _labels[predictedIndex]; // Return class label
  }

  /// **Update Border Color Based on Pose Label**
  void _updateBorderColor(String label) {
    setState(() {
      if (label == "good") {
        _borderColor = AppColors.success; // Green
      } else if (label == "bad") {
        _borderColor = AppColors.error; // Red
      } else {
        _borderColor = AppColors.warning; // Yellow
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _interpreter?.close(); // Close safely
    _poseTimer?.cancel(); // Stop the periodic timer
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// **Handles App Lifecycle Changes**
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.paused) {
      _disposeCamera();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  /// **Initialize Front Camera**
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
      print("❌ Error initializing camera: $e");
    }
  }

  /// **Dispose Camera**
  void _disposeCamera() {
    if (isCameraInitialized) {
      _controller.dispose();
      setState(() {
        isCameraInitialized = false;
      });
    }
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

          // Border overlay (changes dynamically)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                border:
                    Border.all(color: _borderColor, width: screenWidth * 0.025),
                borderRadius: BorderRadius.circular(screenWidth * 0.09),
              ),
            ),
          ),

          // Pose Classification Status
          Positioned(
            bottom: screenHeight * 0.1,
            left: screenWidth * 0.2,
            right: screenWidth * 0.2,
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  "Posture: ${_borderColor == AppColors.success ? "Good" : _borderColor == AppColors.error ? "Bad" : "Unknown"}",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
