import 'package:flutter/material.dart';
import '../services/device_provider.dart';
import '../utils/styles.dart';
import 'package:provider/provider.dart';

class LoadingIcon extends StatelessWidget {
  const LoadingIcon({super.key});

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
    }
    return const SizedBox();
  }
}
