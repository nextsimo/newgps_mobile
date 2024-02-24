import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newgps/src/ui/auto_search/auto_search.dart';

import '../../models/device.dart';
import '../../widgets/date_hour_widget.dart';

class SelectGroup extends StatelessWidget {
  const SelectGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 70.r.h,
      child: Column(
        children: [
          AutoSearchDevice(
            onSelectDeviceFromOtherView: (Device? device) async {
              log("===> ${device?.description}");
            },
          ),
          DateHourWidget(
            width: 215.w,
            fetchData: false,
            dateFrom: DateTime.now(),
            dateTo: DateTime.now(),
            onSelectDate: (DateTime? dateTime) {
              log("===> $dateTime");
            },
          ),
        ],
      ),
    );
  }
}
