class OrientationData {
  final double tiltAngle;

  OrientationData(this.tiltAngle);

  bool isCorrectAngle() {
    return tiltAngle >= 70;
  }

  Map<String, dynamic> toMap() {
    return {
      'tiltAngle': tiltAngle,
    };
  }

  factory OrientationData.fromMap(Map<String, dynamic> map) {
    return OrientationData(map['tiltAngle']);
  }
}
