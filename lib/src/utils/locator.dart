import 'package:flutter_tts/flutter_tts.dart';
import 'package:get_it/get_it.dart';
import '../services/api_service.dart';
import '../services/device_provider.dart';
import '../services/firebase_messaging_service.dart';
import '../services/geozone_service.dart';
import '../services/location_service.dart';
import '../services/shared_preferences_service.dart';
import '../ui/driver_phone/driver_phone_provider.dart';
import '../ui/navigation/navigation_provider.dart';

import '../ui/repport/resume/loading/resume_repport_loding_provider.dart';
import '../ui/repport/resume/resume_repport_provider.dart';

final locator = GetIt.instance;

void setup() {
    locator.registerSingleton<SharedPrefrencesService>(SharedPrefrencesService());

  locator.registerSingleton<LocationService>(LocationService());
  locator.registerSingleton<ApiService>(ApiService());
  locator.registerSingleton<DeviceProvider>(DeviceProvider());
  locator.registerSingleton<FlutterTts>(FlutterTts());
  locator.registerSingleton<NavigationProvider>(NavigationProvider());
  locator.registerSingleton<DriverPhoneProvider>(DriverPhoneProvider());
  locator.registerSingleton<ResumeRepportProvider>(ResumeRepportProvider());
  locator.registerSingleton<GeozoneService>(GeozoneService());
  locator.registerSingleton<ResumeReportLoadingProvider>(
      ResumeReportLoadingProvider());
  locator
      .registerSingleton<FirebaseMessagingService>(FirebaseMessagingService());
}
