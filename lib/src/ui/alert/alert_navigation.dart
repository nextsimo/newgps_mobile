import 'dart:io';

import 'package:flutter/material.dart';
import 'package:newgps/src/ui/alert/hood/hood_alert_view.dart';
import '../../services/newgps_service.dart';
import '../../widgets/buttons/log_out_button.dart';
import 'alert_view.dart';
import 'battery/battery_view.dart';
import 'depranch/depranch_notif_view.dart';
import 'fuel/fuel_view.dart';
import 'highway/nighway_notif_view.dart';
import 'hsitorics/notif_hsitoric_view.dart';
import 'immobility/imobility_alert_view.dart';
import 'oil_change/oil_change_view.dart';
import 'radar/radar_view.dart';
import 'speed/speed_view.dart';
import 'start_up/startup_view.dart';
import 'temperature/temperature_view.dart';

class AlertNavigation extends StatelessWidget {
  const AlertNavigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Stack(
        children: [
          Navigator(
            initialRoute: navigationViewProvider.initAlertRoute,
            onGenerateRoute: (RouteSettings settings) {
              switch (settings.name) {
                case '/speed':
                  return MaterialPageRoute(
                      builder: (_) => const SpeedAlertView());
                case '/historics':
                  return MaterialPageRoute(
                      builder: (_) => const NotifHistoricView());
                case '/hood':
                  return MaterialPageRoute(builder: (_) => const HoodAlertView());
                case '/temp':
                  return MaterialPageRoute(
                      builder: (_) => const TemperatureView());
                case '/radar':
                  return MaterialPageRoute(
                      builder: (_) => const RadarNotifView());
                case '/fuel':
                  return MaterialPageRoute(
                      builder: (_) => const FuelAlertView());
                case '/oil_change':
                  return MaterialPageRoute(
                      builder: (_) => const OilChangeAertView());
                case '/startup':
                  return MaterialPageRoute(builder: (_) => const StartupView());
                case '/imobility':
                  return MaterialPageRoute(builder: (_) => const ImobilityAlertView());
                case '/debranchement':
                  return MaterialPageRoute(
                      builder: (_) => const DepranchNotifView());
                case '/battery':
                  return MaterialPageRoute(
                      builder: (_) => const BatteryAlertView());
                case '/highway':
                  return MaterialPageRoute(
                      builder: (_) => const HighwayNotifView());
                default:
                  return MaterialPageRoute(builder: (_) => const AlertView());
              }
            },
          ),
          const _BuildMapWidget(),
        ],
      ),
    );
  }
}

class _BuildMapWidget extends StatelessWidget {
  const _BuildMapWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isIOS = Platform.isIOS;
    bool _isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Positioned(
      right: _isPortrait ? 0 : -5,
      top: _isPortrait ? (isIOS ? 112 : 92) : (isIOS ? 58 : 86),
      child: const LogoutButton(
        pop: true,
      ),
    );
  }
}
