import 'package:flutter/material.dart';

class DeviceSize {
  static late BuildContext c;
  static late double width;
  static late double height;
  static late Size size;

  DeviceSize.init(BuildContext context) {
    c = context;
    size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
  }
}
