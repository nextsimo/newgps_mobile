import 'package:battery_indicator/battery_indicator.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:newgps/src/models/device.dart';
import 'package:newgps/src/utils/functions.dart';
import 'package:signal_strength_indicator/signal_strength_indicator.dart';

import '../utils/styles.dart';

class ClassicInfoWindows extends StatelessWidget {
  final Device device;
  const ClassicInfoWindows({Key? key, required this.device}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var boxDecoration = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(AppConsts.mainradius),
      boxShadow: const [
        BoxShadow(
          color: Colors.black26,
          blurRadius: 10,
          spreadRadius: 1,
          offset: Offset(0, 0),
        ),
      ],
    );
    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: boxDecoration,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 5),
                Text(
                  device.description,
                  maxLines: 1,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  formatDeviceDate(device.dateTime),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      device.statut,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '(${device.speedKph} km/h)',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    SignalStrengthIndicator.bars(
                      size: 15,
                      value: device.signalStrength,
                      minValue: 0,
                      maxValue: 5,
                      barCount: 5,
                    ),
                    const SizedBox(width: 10),
                    BatteryIndicator(
                      batteryFromPhone: false,
                      style: BatteryIndicatorStyle.skeumorphism,
                      batteryLevel: 100,
                      //batteryLevel: device.batteryLevel.toInt(),
                      size: 11.5,
                    ),
                  ],
                ),
                const SizedBox(height: 5),
              ],
            ),
          ),
        ),
        // traingle shape at the bottom of the info window
        Transform.scale(
          scale: -1,
          child: CustomPaint(
            painter: _TrianglePainter(
              strokeColor: Colors.white,
              strokeWidth: 1,
              paintingStyle: PaintingStyle.fill,
            ),
            child: const SizedBox(
              height: 12,
              width: 10,
            ),
          ),
        ),
      ],
    );
  }
}

class _TrianglePainter extends CustomPainter {
  final Color strokeColor;
  final PaintingStyle paintingStyle;
  final double strokeWidth;

  _TrianglePainter(
      {this.strokeColor = Colors.black,
      this.strokeWidth = 3,
      this.paintingStyle = PaintingStyle.stroke});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = strokeColor
      ..strokeWidth = strokeWidth
      ..style = paintingStyle;

    canvas.drawPath(getTrianglePath(size.width, size.height), paint);
  }

  Path getTrianglePath(double x, double y) {
    return Path()
      ..moveTo(0, y)
      ..lineTo(x / 2, 0)
      ..lineTo(x, y)
      ..lineTo(0, y);
  }

  @override
  bool shouldRepaint(_TrianglePainter oldDelegate) {
    return oldDelegate.strokeColor != strokeColor ||
        oldDelegate.paintingStyle != paintingStyle ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}

class MyCustomInfoWindows extends StatelessWidget {
  final CustomInfoWindowController controller;
  const MyCustomInfoWindows({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomInfoWindow(
      controller: controller,
      height: 100,
      width: 200,
      offset: 30,
    );
  }
}
