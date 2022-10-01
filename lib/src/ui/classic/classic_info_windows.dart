import 'package:battery_indicator/battery_indicator.dart';
import 'package:flutter/material.dart';
import 'package:newgps/src/models/device.dart';
import 'package:newgps/src/utils/functions.dart';
import 'package:signal_strength_indicator/signal_strength_indicator.dart';

class ClassicInfoWindows extends StatelessWidget {
  final Device device;
  const ClassicInfoWindows({Key? key, required this.device}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var boxDecoration = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(5),
      boxShadow: const [
        BoxShadow(
          color: Colors.black26,
          blurRadius: 10,
          spreadRadius: 1,
          offset: Offset(0, 0),
        ),
      ],
    );
    return Container(
      decoration: boxDecoration,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            device.description,
            maxLines: 1,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.blue,
            ),
          ),
          Text(
            formatDeviceDate(device.dateTime),
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BatteryIndicator(
                batteryFromPhone: false,
                style: BatteryIndicatorStyle.skeumorphism,
                batteryLevel: device.batteryLevel.toInt(),
              ),
              SignalStrengthIndicator.bars(
                size: 15,
                value: device.signalStrength,
                minValue: 0,
                maxValue: 5,
                barCount: 5,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
