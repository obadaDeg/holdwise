class OrientationData {
  final double tiltAngle;

  OrientationData(this.tiltAngle);

  bool isCorrectAngle() {
    // if (orientationType == 'portrait') {
    //   return tiltAngle >= 70;
    // } else if (orientationType == 'landscape') {
    //   return tiltAngle <= 65;
    // }
    return tiltAngle >= 70; 
  }
}
