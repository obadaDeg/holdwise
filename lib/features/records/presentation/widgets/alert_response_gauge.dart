import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class AlertResponseGauge extends StatelessWidget {
  final double responseRate; // Expecting value between 0 and 100

  const AlertResponseGauge({Key? key, required this.responseRate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Alert Response Rate",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            // Circular Gauge with Range Pointer
            SizedBox(
              height: 200,
              width: 200,
              child: SfRadialGauge(
                axes: <RadialAxis>[
                  RadialAxis(
                    minimum: 0,
                    maximum: 100,
                    showLabels: false,
                    showTicks: false,
                    axisLineStyle: AxisLineStyle(
                      thickness: 15,
                      color: Colors.grey.shade300, // Background track
                      cornerStyle: CornerStyle.bothCurve,
                    ),
                    pointers: <GaugePointer>[
                      RangePointer(
                        value: responseRate,
                        width: 15,
                        enableAnimation: true,
                        gradient: SweepGradient(
                          colors: [Colors.blue, Colors.purple], // Gradient effect
                          stops: [0.2, 1.0],
                        ),
                        cornerStyle: CornerStyle.bothCurve,
                      ),
                    ],
                    annotations: <GaugeAnnotation>[
                      GaugeAnnotation(
                        widget: Text(
                          '${responseRate.toStringAsFixed(1)} / 100',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        positionFactor: 0.0,
                        angle: 0,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
