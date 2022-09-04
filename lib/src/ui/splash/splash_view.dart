import 'package:flutter/material.dart';
import '../../services/newgps_service.dart';
import '../../utils/device_size.dart';
import 'splash_view_model.dart';
import 'package:provider/provider.dart';

class SplashView extends StatelessWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DeviceSize.init(context);
    return ChangeNotifierProvider<SplashViewModel>(
        create: (_) => SplashViewModel(),
        builder: (context, snapshot) {
          SplashViewModel model =
              Provider.of<SplashViewModel>(context, listen: false);
          resumeRepportProvider.fresh();
          model.init(context);
          return Material(
            child: Center(
              child: Image.asset('assets/logo-200.png'),
            ),
          );
        });
  }
}
