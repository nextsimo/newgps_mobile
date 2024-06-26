import 'package:flutter_tts/flutter_tts.dart';
import 'device_provider.dart';
import 'shared_preferences_service.dart';
import '../utils/locator.dart';
import '../ui/navigation/navigation_provider.dart';

import '../ui/repport/resume/loading/resume_repport_loding_provider.dart';
import '../ui/repport/resume/resume_repport_provider.dart';
import 'api_service.dart';
import 'firebase_messaging_service.dart';
import 'location_service.dart';

class NewgpsService {
  static LocationService locationService = locator<LocationService>();
  static ApiService apiService = locator<ApiService>();
  static SharedPrefrencesService sharedPrefrencesService =
      locator<SharedPrefrencesService>();
  static DeviceProvider deviceProvider = locator<DeviceProvider>();
  static FlutterTts audioPlayer = locator<FlutterTts>();
  static NavigationProvider navigationViewProvider =
      locator<NavigationProvider>();
  static ResumeRepportProvider resumeRepportProvider =
      locator<ResumeRepportProvider>();
  static ResumeReportLoadingProvider loading =
      locator<ResumeReportLoadingProvider>();

  static FirebaseMessagingService messaging =
      locator<FirebaseMessagingService>();
}

LocationService loc = NewgpsService.locationService;
ApiService api = NewgpsService.apiService;
SharedPrefrencesService shared = NewgpsService.sharedPrefrencesService;
DeviceProvider deviceProvider = NewgpsService.deviceProvider;
NavigationProvider navigationViewProvider =
    NewgpsService.navigationViewProvider;
ResumeRepportProvider resumeRepportProvider =
    NewgpsService.resumeRepportProvider;
