import 'package:flutter/material.dart';
import 'package:newgps/src/ui/connected_device/connected_device_provider.dart';
import 'package:newgps/src/utils/styles.dart';
import 'package:provider/provider.dart';

class ConnectedDeviceButton extends StatelessWidget {
  const ConnectedDeviceButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int count = context.select<ConnectedDeviceProvider, int>((v) => v.countedConnectedDevices);
    if( count == 0 ) return const SizedBox();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 0.5),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppConsts.mainColor, width: 1.4),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Row(
        children:  [
         const Icon(
            Icons.brightness_1,
            color: Colors.green,
            size: 12,
          ),
          Text(
            '$count connecté',
            style:const TextStyle(
              color: Colors.black,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
