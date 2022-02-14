import 'package:flutter/material.dart';
import 'package:newgps/src/models/device.dart';
import 'package:newgps/src/services/device_provider.dart';
import 'package:newgps/src/services/newgps_service.dart';
import 'package:newgps/src/ui/driver_phone/driver_phone_provider.dart';
import 'package:newgps/src/utils/functions.dart';
import 'package:newgps/src/utils/locator.dart';
import 'package:newgps/src/utils/styles.dart';
import 'package:newgps/src/widgets/buttons/main_button.dart';
import 'package:provider/provider.dart';

import 'buttons/outlined_button.dart';
import 'emoticone_builder/emoticone_widget.dart';

class FloatingGroupWindowInfo extends StatefulWidget {
  final Device device;
  final bool showOnOffDevice;
  final bool showCallDriver;

  const FloatingGroupWindowInfo(
      {Key? key,
      required this.device,
      this.showOnOffDevice = true,
      this.showCallDriver = true})
      : super(key: key);

  @override
  _FloatingGroupWindowInfoState createState() =>
      _FloatingGroupWindowInfoState();
}

class _FloatingGroupWindowInfoState extends State<FloatingGroupWindowInfo> {
  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    return WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pop();
          return false;
        },
        child: orientation == Orientation.portrait
            ? _FloatingGroupInfoWindowInfoPortrait(
                device: widget.device,
                showCallDriver: widget.showCallDriver,
                showOnOffDevice: widget.showOnOffDevice)
            : _FloatingGroupInfoWindowInfoLandscape(
                device: widget.device,
                showCallDriver: widget.showCallDriver,
                showOnOffDevice: widget.showOnOffDevice));
  }
}

class _FloatingGroupInfoWindowInfoPortrait extends StatelessWidget {
  final Device device;
  final bool showOnOffDevice;
  final bool showCallDriver;
  const _FloatingGroupInfoWindowInfoPortrait({
    Key? key,
    required this.device,
    required this.showOnOffDevice,
    required this.showCallDriver,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DeviceProvider provider =
        Provider.of<DeviceProvider>(context, listen: false);
    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          alignment: Alignment.bottomCenter,
          color: Colors.transparent,
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppConsts.mainradius),
              color: Colors.white,
            ),
            child: Stack(
              children: [
                Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          Navigator.of(context).pop();
                        })),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Matricule
                        if (device.description.isNotEmpty)
                          Text(device.description,
                              style: const TextStyle(
                                  color: AppConsts.blue,
                                  fontWeight: FontWeight.bold)),
                        const SizedBox(height: 20),

                        Row(
                          children: [
                            const Icon(Icons.commute, color: AppConsts.blue),
                            const SizedBox(width: 5),
                            RichText(
                                text: TextSpan(
                                    text: "État: ",
                                    style: TextStyle(
                                      color: Colors.black.withOpacity(0.7),
                                    ),
                                    children: [
                                  TextSpan(
                                      text: device.statut,
                                      style: const TextStyle(
                                          color: Colors.black54))
                                ])),
                          ],
                        ),
                        const SizedBox(height: 7),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today,
                                color: AppConsts.mainColor),
                            const SizedBox(width: 5),
                            Expanded(
                              child: RichText(
                                  text: TextSpan(
                                      text: "Date: ",
                                      style: TextStyle(
                                        color: Colors.black.withOpacity(0.7),
                                      ),
                                      children: [
                                    TextSpan(
                                        text: formatDeviceDate(device.dateTime),
                                        style: const TextStyle(
                                          color: Colors.black54,
                                        ))
                                  ])),
                            ),
                          ],
                        ),
                        const SizedBox(height: 7),
                        Row(
                          children: [
                            const Icon(Icons.av_timer,
                                color: AppConsts.mainColor),
                            const SizedBox(width: 5),
                            RichText(
                              text: TextSpan(
                                text: "Vitesse: ",
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.7)),
                                children: [
                                  TextSpan(
                                      text: "${device.speedKph} Km/H",
                                      style: const TextStyle())
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 7),
                        Row(
                          children: [
                            const Icon(Icons.location_on,
                                color: AppConsts.blue),
                            const SizedBox(width: 5),
                            Expanded(
                              child: RichText(
                                  text: TextSpan(
                                      text: "Adresse: ",
                                      style: TextStyle(
                                          color: Colors.black.withOpacity(0.7)),
                                      children: [
                                    TextSpan(
                                        text: device.address,
                                        style: const TextStyle(
                                            color: Colors.black54))
                                  ])),
                            ),
                          ],
                        ),
                        const SizedBox(height: 7),
                        Row(
                          children: [
                            const Icon(Icons.speed, color: AppConsts.mainColor),
                            const SizedBox(width: 5),
                            RichText(
                                text: TextSpan(
                                    text: "Odometer: ",
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(0.7)),
                                    children: [
                                  TextSpan(
                                      text: "${device.odometerKm} Km",
                                      style: const TextStyle(
                                          color: Colors.black54))
                                ])),
                          ],
                        ),
                        const SizedBox(height: 7),
                        if (showCallDriver)
                          MainButton(
                            height: 35,
                            icon: Icons.call,
                            onPressed: () {
                              locator<DriverPhoneProvider>().checkPhoneDriver(
                                  context: context,
                                  device: device,
                                  sDevice: device,
                                  callNewData: () async {
                                    await deviceProvider.fetchDevices();
                                  });
                            },
                            label: 'Appele conducteur',
                          ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    if (showOnOffDevice)
                      Row(
                        children: [
                          Expanded(
                            child: MainButton(
                              height: 35,
                              onPressed: () async {
                                await _showStartStopDilaog(context, provider,
                                    'IgnitionEnable', 'démarrer');
                              },
                              label: 'Démarrer',
                              backgroundColor: Colors.green,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                              child: MainButton(
                            height: 35,
                            onPressed: () async {
                              await _showStartStopDilaog(context, provider,
                                  'IgnitionDisable', 'arrêter');
                            },
                            label: 'Arrêter',
                            backgroundColor: Colors.red,
                          )),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _showStartStopDilaog(BuildContext context, DeviceProvider provider,
      String command, String status) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            const Icon(
              Icons.warning_rounded,
              color: AppConsts.mainColor,
              size: 44,
            ),
            const SizedBox(height: 10),
            Text('Etes-vous sur de $status ce véhicule'),
            const SizedBox(height: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(width: 10),
                CustomOutlinedButton(
                  width: 90,
                  onPressed: () => Navigator.of(context).pop(),
                  label: 'Non',
                ),
                const SizedBox(width: 10),
                MainButton(
                  onPressed: () async =>
                      await provider.startStopDevice(command, context, device),
                  width: 90,
                  label: 'Oui',
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class _FloatingGroupInfoWindowInfoLandscape extends StatelessWidget {
  final Device device;
  final bool showOnOffDevice;
  final bool showCallDriver;
  const _FloatingGroupInfoWindowInfoLandscape({
    Key? key,
    required this.device,
    required this.showOnOffDevice,
    required this.showCallDriver,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DeviceProvider provider =
        Provider.of<DeviceProvider>(context, listen: false);
    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: SafeArea(
          top: false,
          right: false,
          left: false,
          child: Container(
            alignment: Alignment.bottomCenter,
            color: Colors.transparent,
            child: Container(
              width: 350,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppConsts.mainradius),
                color: Colors.white,
              ),
              child: Stack(
                children: [
                  Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                          padding: const EdgeInsets.all(5),
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            Navigator.of(context).pop();
                          })),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Matricule
                          if (device.description.isNotEmpty)
                            Text(
                              device.description,
                              style: const TextStyle(
                                  color: AppConsts.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12),
                            ),
                          const SizedBox(height: 4),
                          const EmoticonWidget(),

                          Row(
                            children: [
                              const Icon(Icons.commute,
                                  color: AppConsts.blue, size: 14),
                              const SizedBox(width: 5),
                              RichText(
                                  text: TextSpan(
                                      text: "État: ",
                                      style: TextStyle(
                                        color: Colors.black.withOpacity(0.7),
                                        fontSize: 12,
                                      ),
                                      children: [
                                    TextSpan(
                                        text: device.statut,
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.black54))
                                  ])),
                            ],
                          ),
                          const SizedBox(height: 3),

                          Row(
                            children: [
                              const Icon(Icons.calendar_today,
                                  color: AppConsts.mainColor, size: 14),
                              const SizedBox(width: 5),
                              Expanded(
                                child: RichText(
                                    text: TextSpan(
                                        text: "Date: ",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black.withOpacity(0.7),
                                        ),
                                        children: [
                                      TextSpan(
                                          text:
                                              formatDeviceDate(device.dateTime),
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.black54,
                                          ))
                                    ])),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),

                          Row(
                            children: [
                              const Icon(
                                Icons.av_timer,
                                color: AppConsts.mainColor,
                                size: 14,
                              ),
                              const SizedBox(width: 5),
                              RichText(
                                  text: TextSpan(
                                      text: "Vitesse: ",
                                      style: TextStyle(
                                          color: Colors.black.withOpacity(0.7)),
                                      children: [
                                    TextSpan(
                                        text: "${device.speedKph} Km/H",
                                        style: const TextStyle(fontSize: 12))
                                  ])),
                            ],
                          ),
                          const SizedBox(height: 7),

                          Row(
                            children: [
                              const Icon(Icons.location_on,
                                  color: AppConsts.blue, size: 14),
                              const SizedBox(width: 5),
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    text: "Adresse: ",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.black.withOpacity(0.7)),
                                    children: [
                                      TextSpan(
                                        text: device.address,
                                        style: const TextStyle(
                                            color: Colors.black54,
                                            fontSize: 12),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 7),
                          Row(
                            children: [
                              const Icon(Icons.speed,
                                  color: AppConsts.mainColor, size: 14),
                              const SizedBox(width: 5),
                              RichText(
                                  text: TextSpan(
                                      text: "Odometer: ",
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.black.withOpacity(0.7)),
                                      children: [
                                    TextSpan(
                                        text: "${device.odometerKm} Km",
                                        style: const TextStyle(
                                            fontSize: 10,
                                            color: Colors.black54))
                                  ])),
                            ],
                          ),

                          const SizedBox(height: 7),
                          if (device.phone1.isNotEmpty && showCallDriver)
                            MainButton(
                              height: 25,
                              icon: Icons.call,
                              onPressed: () {
                                if (device.phone1.isNotEmpty) {
                                  showDialog(
                                      context: context,
                                      builder: (_) {
                                        return Dialog(
                                          child: Container(
                                            width: 300,
                                            padding: const EdgeInsets.all(17),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                MainButton(
                                                  onPressed: () {},
                                                  icon: Icons
                                                      .phone_forwarded_rounded,
                                                  label: device.phone1,
                                                ),
                                                const SizedBox(height: 10),
                                                if (device.phone2.isNotEmpty)
                                                  MainButton(
                                                    onPressed: () {},
                                                    icon: Icons
                                                        .phone_forwarded_rounded,
                                                    label: device.phone2,
                                                  ),
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                                }
                              },
                              label: 'Appele conducteur',
                            ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      if (showOnOffDevice)
                        Row(
                          children: [
                            Expanded(
                              child: MainButton(
                                height: 25,
                                onPressed: () async {
                                  await _showStartStopDilaog(context, provider,
                                      'IgnitionEnable', 'démarrer');
                                },
                                label: 'Démarrer',
                                backgroundColor: Colors.green,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                                child: MainButton(
                              height: 25,
                              onPressed: () async {
                                await _showStartStopDilaog(context, provider,
                                    'IgnitionDisable', 'arrêter');
                              },
                              label: 'Arrêter',
                              backgroundColor: Colors.red,
                            )),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _showStartStopDilaog(BuildContext context, DeviceProvider provider,
      String command, String status) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            const Icon(
              Icons.warning_rounded,
              color: AppConsts.mainColor,
              size: 44,
            ),
            const SizedBox(height: 10),
            Text('Etes-vous sur de $status ce véhicule'),
            const SizedBox(height: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(width: 10),
                CustomOutlinedButton(
                  width: 90,
                  onPressed: () => Navigator.of(context).pop(),
                  label: 'Non',
                ),
                const SizedBox(width: 10),
                MainButton(
                  onPressed: () async =>
                      await provider.startStopDevice(command, context, device),
                  width: 90,
                  label: 'Oui',
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
