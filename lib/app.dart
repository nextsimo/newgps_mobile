import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'src/services/device_provider.dart';
import 'src/services/newgps_service.dart';
import 'src/ui/connected_device/connected_device_provider.dart';
import 'src/ui/historic/historic_provider.dart';
import 'src/utils/styles.dart';
import 'src/ui/last_position/last_position_provider.dart';
import 'src/ui/login/login_view.dart';
import 'src/ui/navigation/navigation_view.dart';
import 'src/ui/splash/splash_view.dart';
import 'package:provider/provider.dart';
import 'src/ui/login/login_as/save_account_provider.dart';
import 'src/ui/repport/temperature_ble/temperature_repport_provider.dart';

class NewGpsApp extends StatelessWidget {
  const NewGpsApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DeviceProvider>.value(value: deviceProvider),
        ChangeNotifierProvider<TemperatureRepportProvider>(
          create: (_) => TemperatureRepportProvider(),
        ),
        ChangeNotifierProvider<LastPositionProvider>(
            create: (_) => LastPositionProvider()),
        ChangeNotifierProvider<HistoricProvider>(
            create: (_) => HistoricProvider()),
        ChangeNotifierProvider<SavedAcountProvider>(
            create: (_) => SavedAcountProvider()),
        ChangeNotifierProvider<ConnectedDeviceProvider>(
            create: (_) => ConnectedDeviceProvider()),
      ],
      child: MaterialApp(
        initialRoute: '/',
        routes: {
          // When navigating to the "/" route, build the FirstScreen widget.
          '/': (context) => const SplashView(),
          '/navigation': (context) => CustomNavigationView(),
          '/login': (context) => const LoginView(),
          // When navigating to the "/second" route, build the SecondScreen widget.
        },
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate
        ],
        supportedLocales: const [Locale('fr')],
        debugShowCheckedModeBanner: false,
        builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child!),
        title: 'NEW GPS',
        theme: ThemeData(
          primaryColor: AppConsts.mainColor,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
                backgroundColor: MaterialStateColor.resolveWith(
                    (states) => AppConsts.mainColor)),
          ),
        ),
      ),
    );
  }
}
