import 'package:flutter/material.dart';
import '../../models/device.dart';
import '../../models/info_model.dart';
import '../../services/device_provider.dart';
import '../../utils/functions.dart';
import '../../utils/styles.dart';
import 'last_position_provider.dart';
import '../../widgets/status_widegt.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class CardInfoView extends StatelessWidget {
  const CardInfoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DeviceProvider deviceProvider = Provider.of<DeviceProvider>(context);
    LastPositionProvider lastPositionProvider =
        Provider.of<LastPositionProvider>(context, listen: false);
    InfoModel? infoModel = deviceProvider.infoModel;

    if ((!lastPositionProvider.markersProvider.fetchGroupesDevices && infoModel != null) ||
        (deviceProvider.selectedTabIndex == 1 && infoModel != null)) {
      Device? device = deviceProvider.selectedDevice;
      Orientation orientation = MediaQuery.of(context).orientation;
      return Positioned(
        bottom: 2,
        left: AppConsts.outsidePadding,
        right: AppConsts.outsidePadding,
        child: SafeArea(
          right: false,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OdometreWidget(device: device),
                    Padding(
                      padding:
                           EdgeInsets.only(bottom:  orientation == Orientation.portrait ? AppConsts.outsidePadding : 3),
                      child: StatusWidget(device: device),
                    ),
                  ],
                ),
                if (orientation == Orientation.landscape)
                  _InfoCardLandscape(
                    device: device,
                    infoModel: infoModel,
                  ),
                if (orientation == Orientation.portrait)
                  _InfoCardPortrait(infoModel: infoModel, device: device)
              ],
            ),
          ),
        ),
      );
    }
    return const SizedBox();
  }
}

class _InfoCardPortrait extends StatelessWidget {
  final InfoModel infoModel;
  final Device? device;
  const _InfoCardPortrait(
      {Key? key, required this.infoModel, required this.device})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConsts.miniradius),
        border: Border.all(color: AppConsts.mainColor, width: 1.6),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildLabel(
                    label: 'Date', content: formatDeviceDate(infoModel.lastUpdate)),
                const SizedBox(height: 2),
                _buildLabel(
                    label: 'Cons carburant',
                    content: '${infoModel.carbConsomation.round()} L'),
                const SizedBox(height: 2),
                _buildLabel(
                    label: 'Distance parcourue',
                    content: '${infoModel.distance} Km'),
                const SizedBox(height: 2),
                _buildLabel(
                    label: 'Vitesse maximal',
                    content: '${infoModel.maxSpeed} Km/h'),
              ],
            ),
          ),
          const Cdivider(),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildLabel(
                  label: 'Kilométrage',
                  content: '${infoModel.odometer} Km',
                ),
                const SizedBox(height: 2),
                _buildLabel(
                  label: 'Niveau carburant',
                  content: '${infoModel.carbNiveau} L',
                ),
                _buildLabel(
                  label: 'Temps de conduite',
                  content: infoModel.drivingTime,
                ),
                const SizedBox(height: 2),
                _buildLabel(
                  label: 'Nombre d"arrets',
                  content: '${infoModel.stopedTime}',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel({required String label, required String content}) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            maxLines: 1,
            style: const TextStyle(
              fontSize: 7,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const  Text(':'),
        Expanded(
          flex: 3,
          child: Text(
            content,
            maxLines: 1,
            style: const TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                color: AppConsts.mainColor),
          ),
        )
      ],
    );
  }
}

class _InfoCardLandscape extends StatelessWidget {
  final InfoModel infoModel;
  final Device? device;
  const _InfoCardLandscape(
      {Key? key, required this.infoModel, required this.device})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConsts.miniradius),
        border: Border.all(color: AppConsts.mainColor, width: 1.6),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildLabel(
                    label: 'Date', content: formatDeviceDate(device!.dateTime)),
                _buildLabel(
                    label: 'Cons carburant',
                    content: '${infoModel.carbConsomation.round()} L'),
              ],
            ),
          ),
          const Cdivider(),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildLabel(
                    label: 'Distance parcourue',
                    content: '${infoModel.distance} Km'),
                _buildLabel(
                    label: 'Vitesse maximal',
                    content: '${infoModel.maxSpeed} Km/h'),
              ],
            ),
          ),
          const Cdivider(),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildLabel(
                  label: 'Kilométrage',
                  content: '${infoModel.odometer} Km',
                ),
                _buildLabel(
                  label: 'Niveau carburant',
                  content: '${infoModel.carbNiveau} L',
                ),
              ],
            ),
          ),
          const Cdivider(),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildLabel(
                  label: 'Temps de conduite',
                  content: infoModel.drivingTime,
                ),
                _buildLabel(
                  label: 'Nombre d"arrets',
                  content: '${infoModel.stopedTime}',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel({required String label, required String content}) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            style: const TextStyle(
              fontSize: 7,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Text(':', style: TextStyle(fontSize: 7)),
        ),
        Expanded(
          flex: 1,
          child: Text(
            content,
            style: const TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w500,
                color: AppConsts.mainColor),
          ),
        )
      ],
    );
  }
}

class Cdivider extends StatelessWidget {
  const Cdivider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: 1.1,
      height: 35,
      color: AppConsts.mainColor,
    );
  }
}


class _OdometreWidgetPortrait extends StatelessWidget {
  const _OdometreWidgetPortrait({
    Key? key,
    required this.device,
  }) : super(key: key);

  final Device? device;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(-30, 0),
      child: SizedBox(
        width: 160,
        height: 80,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            SfRadialGauge(
              axes: <RadialAxis>[
                RadialAxis(
                  pointers: <RangePointer>[
                    RangePointer(
                      enableDragging: false,
                      value: device?.speedKph.toDouble() ?? 0,
                      color: AppConsts.mainColor,
                      width: 14,
                    ),
                  ],
                  showLabels: false,
                  showTicks: false,
                  axisLineStyle: const AxisLineStyle(
                    thickness: 0.3,
                    thicknessUnit: GaugeSizeUnit.factor,
                    color: Color(0xffA6BBC9),
                  ),
                  startAngle: 180,
                  endAngle: 0,
                  canScaleToFit: true,
                )
              ],
            ),
            Positioned(
              bottom: 0,
              left: 63,
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xff639FCE),
                    fontWeight: FontWeight.bold,
                  ),
                  text: '${device?.speedKph}\n',
                  children: const [
                    TextSpan(
                      text: 'km/h',
                      style: TextStyle(
                        color: Color(0xff639FCE),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OdometreWidget extends StatelessWidget {
  const OdometreWidget({
    Key? key,
    required this.device,
  }) : super(key: key);

  final Device? device;

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    if (orientation == Orientation.landscape) {
      return _OdometreWidgetLandscape(device: device);
    }
    return _OdometreWidgetPortrait(device: device);
  }
}

class _OdometreWidgetLandscape extends StatelessWidget {
  const _OdometreWidgetLandscape({
    Key? key,
    required this.device,
  }) : super(key: key);

  final Device? device;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(-30, 0),
      child: SizedBox(
        width: 120,
        height: 40,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            SfRadialGauge(
              axes: <RadialAxis>[
                RadialAxis(
                  pointers: <RangePointer>[
                    RangePointer(
                      enableDragging: false,
                      value: device?.speedKph.toDouble() ?? 0,
                      color: AppConsts.mainColor,
                      width: 7,
                    ),
                  ],
                  showLabels: false,
                  showTicks: false,
                  axisLineStyle: const AxisLineStyle(
                    thickness: 0.3,
                    thicknessUnit: GaugeSizeUnit.factor,
                    color: Color(0xffA6BBC9),
                  ),
                  startAngle: 180,
                  endAngle: 0,
                  canScaleToFit: true,
                )
              ],
            ),
            Positioned(
              bottom: 0,
              left: 48,
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xff639FCE),
                    fontWeight: FontWeight.bold,
                  ),
                  text: '${device?.speedKph}\n',
                  children: const [
                    TextSpan(
                      text: 'km/h',
                      style: TextStyle(
                        color: Color(0xff639FCE),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
