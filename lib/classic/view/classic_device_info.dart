import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:newgps/classic/bloc/classic_bloc.dart';
import 'package:newgps/classic/view/classic_device_info_map.dart';
import 'package:newgps/src/models/device.dart';
import 'package:provider/provider.dart';

import '../../models/device_info_model.dart';
import '../../src/utils/functions.dart';
import 'date_time_range_picker_widget.dart';

class ClassicDeviceInfo extends StatelessWidget {
  final List<DeviceInfoModel> deviceInfos;
  final Device device;
  final DateTimeRange initialDateRange;
  const ClassicDeviceInfo({
    super.key,
    required this.deviceInfos,
    required this.device,
    required this.initialDateRange,
  });

  // get the the color depend on the type 0 : red, 1: green
  Color getColor(int type) {
    return type == 0 ? Colors.red : Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ClassicBloc>();
    return Material(
      child: Column(
        children: [
          const SizedBox(
            height: 70,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: DateTimeRangePicker(
              initialDateRange: initialDateRange,
              onConfirm: (dateTimeRange) {
                log("dateTimeRange: $dateTimeRange");
                bloc.add(ClassicLoadDevice(
                  device: device,
                  dateTimeRange: dateTimeRange,
                ));
              },
            ),
          ),
          Expanded(
            child: ListView.separated(
              separatorBuilder: (context, index) => const Divider(),
              itemCount: deviceInfos.length,
              padding: const EdgeInsets.only(
                  top: 20, left: 12, right: 12, bottom: 200),
              itemBuilder: (context, index) {
                final deviceInfo = deviceInfos[index];
                final color = getColor(deviceInfo.type);
                return _BuildCardInfo(
                  color: color,
                  deviceInfo: deviceInfo,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _BuildCardInfo extends StatelessWidget {
  const _BuildCardInfo({
    required this.color,
    required this.deviceInfo,
  });

  final Color color;
  final DeviceInfoModel deviceInfo;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        ClassicDeviceInfoMap.route(deviceInfo, color),
      ),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconTimer(
                          color: color,
                          date: deviceInfo.startDate,
                        ),
                        const SizedBox(width: 10),
                        IconTimer(
                          color: color,
                          date: deviceInfo.endDate,
                        ),
                      ],
                    ),
                    Text(
                      deviceInfo.timeStr,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                if (deviceInfo.type == 1)
                  Column(
                    children: [
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                FontAwesomeIcons.road,
                                size: 16,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                '${deviceInfo.distance.toInt()} km',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          // consumption
                          Row(
                            children: [
                              const Icon(
                                FontAwesomeIcons.gasPump,
                                size: 16,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                '${deviceInfo.consumption} L',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(FontAwesomeIcons.gaugeHigh,
                                  size: 16, color: Colors.red),
                              const SizedBox(width: 5),
                              Text(
                                '${deviceInfo.maxSpeed.toInt()} km/h',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      // address
                      Row(
                        children: [
                          if (deviceInfo.startAddress.isNotEmpty)
                            Expanded(
                              child: Text(
                                deviceInfo.startAddress,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          if (deviceInfo.startAddress.isNotEmpty &&
                              deviceInfo.endAddress.isNotEmpty)
                            const Text(
                              ' | ',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                          if (deviceInfo.endAddress.isNotEmpty)
                            Expanded(
                              child: Text(
                                deviceInfo.endAddress,
                                textAlign: TextAlign.end,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                if (deviceInfo.type == 0)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        deviceInfo.endAddress,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      color: color,
                      size: 16,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      "${deviceInfo.startDate.day}/${deviceInfo.startDate.month}/${deviceInfo.startDate.year}",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 10,
            right: 10,
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: color.withOpacity(0.3),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class IconTimer extends StatelessWidget {
  final Color color;
  final DateTime date;
  const IconTimer({super.key, required this.color, required this.date});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.av_timer_outlined,
          color: color,
          size: 16,
        ),
        const SizedBox(width: 5),
        Text(
          formatToTime(date, 'HH:mm'),
          style: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
