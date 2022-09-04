import 'package:flutter/material.dart';
import '../../utils/functions.dart';
import 'last_position_provider.dart';
import 'package:provider/provider.dart';

class DateWidget extends StatelessWidget {
  const DateWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LastPositionProvider provider = Provider.of<LastPositionProvider>(context);
    if (provider.markersProvider.fetchGroupesDevices) {
      return Positioned(
        bottom: 6,
        left: 5,
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              formatDeviceDate(provider.lastDateFetchDevices),
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
      );
    }

    return const SizedBox();
  }
}
