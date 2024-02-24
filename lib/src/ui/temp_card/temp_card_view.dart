import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:newgps/src/models/device.dart';
import 'package:newgps/src/ui/navigation/top_app_bar.dart';
import 'package:provider/provider.dart';

import '../../utils/styles.dart';
import 'temp_device_temp/temp_device.dart';
import 'temp_card_provider.dart';
import 'temp_graphic/download_today_repport.dart';
import 'temp_graphic/temp_card_graphic_view.dart';

class TempCardView extends StatelessWidget {
  const TempCardView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => TempCardProvider(),
        builder: (providerContext, __) {
          return Scaffold(
            appBar: const CustomAppBar(actions: []),
            body: _FirstTempCardView(
              providerContext: providerContext,
            ),
          );
        });
  }
}

class _FirstTempCardView extends StatelessWidget {
  final BuildContext providerContext;
  const _FirstTempCardView({
    required this.providerContext,
  });

  @override
  Widget build(BuildContext context) {
    return Selector(
      selector: (context, TempCardProvider provider) => provider.loading,
      builder: (context, bool loading, __) {
        final provider = context.read<TempCardProvider>();
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
  const _EmptyRefreshWidget();

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
    required this.providerContext,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.read<TempCardProvider>();
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
      {required this.device, required this.providerContext});

  @override
  Widget build(BuildContext context) {
    const boxShadow = [
      BoxShadow(
        color: Color(0x19000000),
        blurRadius: 13,
        offset: Offset(0, 3),
        
      ),
    ];
    return Container(
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  device.description,
                
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              ClassicDeviceTemp(
                device: device,
              ),
            ],
          ),
          const SizedBox(height: 20),
          TempGraphicView(
            device: device,
          ),
           DownloadTodayRepport(device: device),
        ],
      ),
    );
  }
}

// build statu color depend on status string
// ignore: unused_element
class _BuildState extends StatelessWidget {
  final Device device;
  const _BuildState({required this.device});
  @override
  Widget build(BuildContext context) {
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
        Image.memory(
          base64Decode(device.markerPng),
          height: 30,
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
