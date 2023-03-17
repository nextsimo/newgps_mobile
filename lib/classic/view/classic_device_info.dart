import 'package:flutter/material.dart';

import '../../src/models/device.dart';

class ClassicDeviceInfo extends StatelessWidget {
  final Device device;
  const ClassicDeviceInfo({super.key, required this.device});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListView(
        padding: const EdgeInsets.only(top: 80, left: 12, right: 12),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                
              ],
            ),
          ),
        ],
      ),
    );
  }
}
