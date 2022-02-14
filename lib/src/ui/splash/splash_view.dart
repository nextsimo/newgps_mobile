import 'package:flutter/material.dart';
import 'package:newgps/src/utils/device_size.dart';
import 'package:newgps/src/ui/splash/splash_view_model.dart';
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
          model.init(context);
          return Material(
            child: Center(
              child: Image.asset(
                'assets/logo-200.png',
              ),
            ),
          );
        });
  }
}
