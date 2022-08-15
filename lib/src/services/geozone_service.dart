import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:label_marker/label_marker.dart';
import 'package:newgps/src/services/newgps_service.dart';
import 'package:newgps/src/utils/styles.dart';

import '../models/geozone.dart';

class GeozoneService {
  List<GeozoneModel> _geozones = [];

  // fetch geozone from server
  Future<void> fetchGeozoneFromApi() async {
    clear();
    final res = await api.post(url: '/geozones', body: {
      "accountId": shared.getAccount()?.account.accountId,
    });

    if (res.isNotEmpty) {
      _geozones = geozoneModelFromJson(res);
      _setGeozoneShapes();
    }
  }

  Set<Circle> circles = {};
  Set<Polygon> polygons = {};

  Set<Marker> geozoneMarkers = {};

  void _setGeozoneShapes() {
    for (var geo in _geozones) {
      if (geo.zoneType == 0 || geo.zoneType == 2) {
        // add marker label for this geozone
        _addMarkerLabelToCircle(geo);
        circles.add(
          Circle(
            circleId: CircleId(geo.geozoneId),
            center: LatLng(geo.cordinates.first[0], geo.cordinates.first[1]),
            radius: geo.radius.toDouble(),
            fillColor: const Color.fromARGB(66, 136, 190, 61),
            strokeColor:
                geo.zoneType == 0 ? AppConsts.mainColor : Colors.transparent,
            strokeWidth: 3,
          ),
        );
      }
      if (geo.zoneType == 1) {
        _addMarkerLabelToPolygon(geo);
        polygons.add(
          Polygon(
              polygonId: PolygonId(geo.geozoneId),
              points: geo.cordinates.map((e) => LatLng(e[0], e[1])).toList(),
              fillColor: const Color.fromARGB(66, 136, 190, 61),
              strokeColor: AppConsts.mainColor,
              strokeWidth: 4),
        );
      }
    }
    debugPrint('circles: ${circles.length}');
  }

  // add marker label to circle
  void _addMarkerLabelToCircle(GeozoneModel model) {
    LatLng center =
        LatLng(model.cordinates.first[0], model.cordinates.first[1]);
    _addMarkerLabel(model, center);
  }

  // add marker label to polygon
  void _addMarkerLabelToPolygon(GeozoneModel model) {
    // get center of polygon
    var center = _getPolygonCenter(model.cordinates);
    _addMarkerLabel(model, center);
  }

  // add marker label
  void _addMarkerLabel(GeozoneModel model, LatLng center) {
    geozoneMarkers.addLabelMarker(
      LabelMarker(
        markerId: MarkerId(model.geozoneId),
        label: model.description,
        position: center,
        backgroundColor: model.zoneType == 2 ? Colors.blue : Colors.green,
        textStyle: const TextStyle(
          color: Colors.white,
          fontSize: 33,
        ),
      ),
    );
  }

  // get center of polygon
  LatLng _getPolygonCenter(List<List<double>> cordinates) {
    var center = const LatLng(0, 0);
    var sumX = 0.0;
    var sumY = 0.0;
    for (var i = 0; i < cordinates.length; i++) {
      sumX += cordinates[i][0];
      sumY += cordinates[i][1];
    }
    center = LatLng(sumX / cordinates.length, sumY / cordinates.length);
    return center;
  }

  // call when is logout
  void clear() {
    circles.clear();
    polygons.clear();
    geozoneMarkers.clear();
  }
}
