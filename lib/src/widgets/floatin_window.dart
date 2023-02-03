import 'package:flutter/material.dart';
import '../models/device.dart';
import '../services/device_provider.dart';
import '../services/newgps_service.dart';
import '../ui/driver_phone/driver_phone_provider.dart';
import '../utils/functions.dart';
import '../utils/locator.dart';
import '../utils/styles.dart';
import 'buttons/main_button.dart';
import 'map_launcher/map_launcher_widget.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../ui/icon_change/change_icon_view.dart';
import 'buttons/outlined_button.dart';

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
  // ignore: library_private_types_in_public_api
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

class _FloatingGroupInfoWindowInfoPortrait extends StatefulWidget {
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
  State<_FloatingGroupInfoWindowInfoPortrait> createState() =>
      _FloatingGroupInfoWindowInfoPortraitState();
}

class _FloatingGroupInfoWindowInfoPortraitState
    extends State<_FloatingGroupInfoWindowInfoPortrait> {
  String address = '';

  @override
  void initState() {
    super.initState();
    _setTheAddress();
  }

  Future<void> _setTheAddress() async {
    Future.microtask(() async {
      debugPrint("${widget.device.latitude}/${widget.device.longitude}");
      address = await api.get(
          url:
              '/device/address/${widget.device.latitude}/${widget.device.longitude}');
      setState(() {});
    });
  }

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
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppConsts.mainradius),
              color: Colors.white,
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 40,
                  right: 4,
                  child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                ),
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
                        Row(
                          children: [
                            if (widget.device.description.isNotEmpty)
                              Text(widget.device.description,
                                  style: const TextStyle(
                                      color: AppConsts.blue,
                                      fontWeight: FontWeight.bold)),
                            //const SizedBox(width: 10),
/*                             IconChangeView(
                              selectedDevice: widget.device,
                            ), */
                          ],
                        ),
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
                                      text: widget.device.statut,
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
                                        text: formatDeviceDate(
                                            widget.device.dateTime),
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
                                      text: "${widget.device.speedKph} Km/H",
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
                                        text: address,
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
                                      text: "${widget.device.odometerKm} Km",
                                      style: const TextStyle(
                                          color: Colors.black54))
                                ])),
                          ],
                        ),
                        const SizedBox(height: 7),
                        if (widget.showCallDriver)
                          MainButton(
                            height: 35,
                            icon: Icons.call,
                            onPressed: () {
                              locator<DriverPhoneProvider>().checkPhoneDriver(
                                  context: context,
                                  device: widget.device,
                                  sDevice: widget.device,
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
                    if (widget.showOnOffDevice)
                      Row(
                        children: [
                          Expanded(
                            child: MainButton(
                              height: 35,
                              onPressed: () async {
                                await _showStartStopDilaog(context, provider,
                                    'IgnitionEnable:TCP', 'démarrer');
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
                                  'IgnitionDisable:TCP', 'arrêter');
                            },
                            label: 'Arrêter',
                            backgroundColor: Colors.red,
                          )),
                        ],
                      ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: MainButton(
                            height: 35,
                            onPressed: () async {
                              openMapsSheet(context, widget.device);
                              return;
                            },
                            label: 'Iténiraire',
                            icon: Icons.directions,
                            backgroundColor: Colors.blue,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                            child: MainButton(
                          height: 35,
                          onPressed: () async {
                            Share.share(
                                'http://maps.google.com/?q=${widget.device.latitude},${widget.device.longitude}');
                          },
                          label: 'Partger localisation',
                          backgroundColor: Colors.blueAccent,
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
                  onPressed: () async => await provider.startStopDevice(
                      command, context, widget.device),
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
                      top: 10,
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
                          //const EmoticonWidget(),

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
                                      'IgnitionEnable:TCP', 'démarrer');
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
                                    'IgnitionDisable:TCP', 'arrêter');
                              },
                              label: 'Arrêter',
                              backgroundColor: Colors.red,
                            )),
                          ],
                        ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: MainButton(
                              height: 25,
                              onPressed: () async {
                                openMapsSheet(context, device);
                                return;
                              },
                              label: 'Iténiraire',
                              icon: Icons.directions,
                              backgroundColor: Colors.blue,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                              child: MainButton(
                            height: 25,
                            onPressed: () async {
                              Share.share(
                                  'http://maps.google.com/?q=${device.latitude},${device.longitude}');
                            },
                            label: 'Partger localisation',
                            backgroundColor: Colors.blueAccent,
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
