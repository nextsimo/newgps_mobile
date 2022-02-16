import 'package:flutter/material.dart';
import 'package:newgps/src/services/device_provider.dart';
import 'package:newgps/src/utils/styles.dart';
import 'package:provider/provider.dart';

class LoadingIcon extends StatelessWidget {
  const LoadingIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool loading = context.select<DeviceProvider, bool>((_) => _.loading);

    if (loading) {
      return const Center(
        child: SizedBox(
          width: 15,
          height: 15,
          child: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppConsts.mainColor),
            ),
          ),
        ),
      );
      ;
    }
    return const SizedBox();
  }
}
