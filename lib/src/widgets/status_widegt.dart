import 'package:flutter/material.dart';
import '../models/device.dart';

class StatusWidget extends StatelessWidget {
  const StatusWidget({
    Key? key,
    required this.device,
  }) : super(key: key);

  final Device? device;

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
          return Container(
      width: 80,
      padding: EdgeInsets.symmetric(
          vertical: orientation == Orientation.portrait ? 8 : 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Color.fromRGBO(device!.colorR, device!.colorG, device!.colorB, 1),
      ),
      child: Center(
        child: Text(
          device!.statut,
          style: TextStyle(
            color: Colors.white,
            fontSize: orientation == Orientation.portrait ? 12 : 8,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  
  }
}
