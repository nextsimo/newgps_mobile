import 'package:geolocator/geolocator.dart';

class LocationService {
  late Position myPosition;

  LocationService() {
    init();
  }

  void init() async{
    myPosition = await GeolocatorPlatform.instance.getCurrentPosition();
  }
}
