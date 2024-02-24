import 'package:flutter/material.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';

import '../../models/device.dart';

class MyMarkerBuilder extends StatelessWidget {
  final Device device;
  final bool wave;
  const MyMarkerBuilder({super.key, required this.device, this.wave = false});

  @override
  Widget build(BuildContext context) {
    debugPrint("HistoricProviderN => $wave");

    return Stack(
      alignment: Alignment.center,
      children: [
        if (wave)
          const RippleAnimation(
            color: Colors.blue,
            minRadius: 30,
            repeat: true,
            child:  SizedBox(
              width: 30,
              height: 30,
            ),
          ),
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color:
                Color.fromRGBO(device.colorR, device.colorG, device.colorB, 1),
          ),
          child: Transform.rotate(
            angle: -device.heading.toDouble(),
            child: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
              size: 14,
            ),
          ),
        ),
      ],
    );
  }
}
