import 'package:flutter_tts/flutter_tts.dart';
import 'package:newgps/src/services/device_provider.dart';
import 'package:newgps/src/services/shared_preferences_service.dart';
import 'package:newgps/src/utils/locator.dart';
import 'package:newgps/src/ui/navigation/navigation_provider.dart';

import 'api_service.dart';
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
}

LocationService loc = NewgpsService.locationService;
ApiService api = NewgpsService.apiService;
SharedPrefrencesService shared = NewgpsService.sharedPrefrencesService;
DeviceProvider deviceProvider = NewgpsService.deviceProvider;
NavigationProvider navigationViewProvider = NewgpsService.navigationViewProvider;
