import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newgps/src/services/newgps_service.dart';
import 'package:newgps/src/widgets/buttons/log_out_button.dart';

import '../../widgets/buttons/appele_condcuteur_button.dart';

class ButtonsGroup extends StatelessWidget {
  const ButtonsGroup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 73.r.h,
      right: 0,
      child: Column(
        children: [
          const LogoutButton(),
          const SizedBox(height: 4),
          AppelCondicteurButton(
            device: deviceProvider.selectedDevice,
            callNewData: () async {
              await deviceProvider.fetchDevice();
            },
          ),
        ],
      ),
    );
  }
}
