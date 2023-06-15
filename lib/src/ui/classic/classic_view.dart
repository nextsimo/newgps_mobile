import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:newgps/src/models/device.dart';
import 'package:newgps/src/ui/classic/classic_more_info.dart';
import 'package:newgps/src/ui/classic/classic_view_map.dart';
import 'package:newgps/src/ui/navigation/top_app_bar.dart';
import 'package:newgps/src/utils/functions.dart';
import 'package:newgps/src/utils/styles.dart';
import 'package:provider/provider.dart';
import 'classic_provider.dart';

class ClassicView3 extends StatelessWidget {
  const ClassicView3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: ChangeNotifierProvider(
          create: (context) => ClassicProvider(),
          builder: (providerContext, __) {
            final provider = providerContext.watch<ClassicProvider>();
            return Scaffold(
              appBar: const CustomAppBar(
                actions: [],
              ),
              body: Expanded(
                child: PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: provider.pageController,
                  children: [
                    _FirstClassicView(providerContext: providerContext),
                    const ClassicViewMap()
                  ],
                ),
              ),
            );
          }),
    );
  }
}

class _FirstClassicView extends StatelessWidget {
  final BuildContext providerContext;
  const _FirstClassicView({
    Key? key,
    required this.providerContext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector(
      selector: (context, ClassicProvider provider) => provider.loading,
      builder: (context, bool loading, __) {
        final provider = context.read<ClassicProvider>();
        return provider.devices.isEmpty
            ? const _EmptyRefreshWidget()
            : _BuildListWidget(
                providerContext: providerContext,
              );
      },
    );
  }
}

class _EmptyRefreshWidget extends StatelessWidget {
  const _EmptyRefreshWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'No devices found',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 10),
          Text(
            'Pull down to refresh',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class _BuildListWidget extends StatelessWidget {
  final BuildContext providerContext;
  const _BuildListWidget({
    Key? key,
    required this.providerContext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.read<ClassicProvider>();
    return ListView.separated(
      padding: const EdgeInsets.only(
        top: 25,
        bottom: 140,
      ),
      separatorBuilder: (context, index) => const SizedBox(height: 15),
      itemCount: provider.devices.length,
      itemBuilder: (context, index) => _BuildDeviceCard(
        device: provider.devices[index],
        providerContext: providerContext,
      ),
    );
  }
}

class _BuildDeviceCard extends StatelessWidget {
  final BuildContext providerContext;
  final Device device;
  const _BuildDeviceCard(
      {Key? key, required this.device, required this.providerContext})
      : super(key: key);

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
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => const ClassicMoreInfo()));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        margin: const EdgeInsets.symmetric(horizontal: 15),
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
                _BuildState(device: device, providerContext: providerContext),
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
                      '${device.odometerKm.toInt()} km',
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

// build statu color depend on status string
class _BuildState extends StatelessWidget {
  final Device device;
  final BuildContext providerContext;
  const _BuildState(
      {Key? key, required this.device, required this.providerContext})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final provider = context.read<ClassicProvider>();

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConsts.mainradius),
            color: _buildStatutColor(device.statut),
          ),
          child: Text(
            device.statut,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 10),
        // build image from base64 string
        GestureDetector(
          onTap: () => provider.gotoMapView(device, providerContext),
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                  ),
                ]),
            child: Stack(
              children: [
                Center(
                  child: Image.memory(
                    base64Decode(device.markerPng),
                    height: 30,
                  ),
                ),
                const Icon(
                  Icons.map,
                  color: Colors.blue,
                  size: 20,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Color _buildStatutColor(String statut) {
    switch (statut) {
      case 'En Route':
        return Colors.green;
      case 'Parking':
        return Colors.red;
      case 'Ralenti':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
