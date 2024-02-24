import 'package:flutter/material.dart';
import 'package:newgps/src/widgets/status_widegt.dart';

import '../src/models/device.dart';
import '../src/utils/functions.dart';
import '../src/utils/styles.dart';

class DeviceCard extends StatelessWidget {
  final Device device;
  final VoidCallback? onTap;
  const DeviceCard(
      {super.key, required this.device, this.onTap});

  @override
  Widget build(BuildContext context) {
    const boxShadow = [
      BoxShadow(
        color: Color(0x19000000),
        blurRadius: 13,
        offset: Offset(0, 3),
      ),
    ];
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConsts.mainradius),
          boxShadow: boxShadow,
          color: Colors.white,
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               StatusWidget(device: device),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        device.description,
                        style: const TextStyle(
                          color: Color(0xff1a316c),
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 5),
                      if (device.address.isEmpty)
                        const Text(
                          'Adresse non disponible',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 8,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      else
                        Text(
                          device.address,
                          style: const TextStyle(
                            color: Color(0xff080b12),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ],
                  ),
                ),
    /*               ClassicDeviceTemp(
                  device: device,
                ), */
              ],
            ),
            const Divider(),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      'Dernière connexion',
                      style: TextStyle(
                        color: Color(0xff080b12),
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 7),
                    Container(
                      height: 22,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(AppConsts.mainradius),
                        color: AppConsts.mainColor.withOpacity(0.1),
                      ),
                      child: Center(
                        child: Text(
                          formatDeviceDate(device.dateTime),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppConsts.mainColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 89,
                  height: 19,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(300),
                    border: Border.all(
                      color: AppConsts.mainColor,
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '${device.distanceKm.toInt()} km',
                      style: const TextStyle(
                        color: AppConsts.mainColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}