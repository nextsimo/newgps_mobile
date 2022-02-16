import 'package:geolocator/geolocator.dart';

class LocationService {
  late Position myPosition;

  LocationService() {
    init();
  }

  void init() async {
    LocationPermission permission =
        await GeolocatorPlatform.instance.requestPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      myPosition = await GeolocatorPlatform.instance.getCurrentPosition();
    }
  }
}
