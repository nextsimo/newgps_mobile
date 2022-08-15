import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:newgps/src/models/geozone.dart';
import 'package:newgps/src/utils/styles.dart';

class GeozoneDialogProvider with ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  int _selectionType = 0;

  final TextEditingController controllerGeozoneName = TextEditingController();
  final TextEditingController controllerGeozoneMetre =
      TextEditingController(text: '4000');
  int get selectionType => _selectionType;
  late LatLng pos;

  GoogleMapController? googleMapController;

  int _innerOuterValue = 0;

  int get innerOuterValue => _innerOuterValue;

  set innerOuterValue(int innerOuterValue) {
    _innerOuterValue = innerOuterValue;
    notifyListeners();
  }

  Future<void> initMap(GoogleMapController controller) async {
    googleMapController = controller;
    double zoom = await controller.getZoomLevel();
    controller.moveCamera(CameraUpdate.zoomTo(zoom + 0.1));
    notifyListeners();
  }

  double currentZoome = 6;

  void notify() {
    notifyListeners();
  }

  void clear() {
    _innerOuterValue = 0;
    _selectionType = 0;
    controllerGeozoneName.text = "";
    controllerGeozoneMetre.text = "4000";
    markers.clear();
    circle.clear();
    pointLines.clear();
    polygone.clear();
  }

  void updateInnerOuterValue(int val) => innerOuterValue = val;

  void onSave(BuildContext context) {
    // save geozone to api
    if (formKey.currentState!.validate()) {
      bool res = circle.isNotEmpty || polygone.isNotEmpty;
      Navigator.of(context).pop<bool>(res);
    }
  }

  Future<void> pop(BuildContext context) async {
    Navigator.of(context).pop();
    clear();
  }

  void onClickUpdate(GeozoneModel geozone) {
    controllerGeozoneName.text = geozone.description;
    controllerGeozoneMetre.text = geozone.radius.toString();
    _innerOuterValue = geozone.innerOuterValue;
    _selectionType = geozone.zoneType;
    markers.clear();
    pos = LatLng(geozone.cordinates.first[0], geozone.cordinates.first[1]);
    if (_selectionType == 0 || _selectionType == 2) {
      pos = LatLng(geozone.cordinates.first[0], geozone.cordinates.first[1]);
      if (_selectionType == 2) {
        _addCircleOnMarker();
      } else {
        _addCircle();
      }
    } else if (_selectionType == 1) {
      for (var cor in geozone.cordinates) {
        LatLng latLng = LatLng(cor[0], cor[1]);
        pointLines.add(latLng);
        markers.add(
          Marker(
            markerId: MarkerId(latLng.toString()),
            position: latLng,
            onDragEnd: movePolygonPoint,
            onDragStart: onMoveStart,
            draggable: true,
          ),
        );
      }
      _addPolygone(pos, null, false);
    }
    //pos = LatLng(geozone.latitude1, geozone.longitude1);
  }

  Set<Circle> circle = {};
  Set<Marker> markers = {};

  Set<Polygon> polygone = {};

  void onChangeMetre(String val) {
    if (selectionType == 1 || selectionType == 2) {
      return;
    }
    try {
      addShape(pos);
    } catch (_) {}
  }

  set selectionType(int selectionType) {
    _selectionType = selectionType;
    notifyListeners();
  }

  List<LatLng> pointLines = [];

  void addPoints(LatLng latLng, [int? index]) {
    if (index != null) {
      pointLines.insert(index, latLng);
    } else {
      pointLines.add(latLng);
      markers.add(
        Marker(
          markerId: MarkerId(latLng.toString()),
          position: latLng,
          onDragEnd: movePolygonPoint,
          onDragStart: onMoveStart,
          draggable: true,
        ),
      );
    }
  }

  int _index = 0;

  void movePolygonPoint(LatLng latlng) {
    addShape(latlng, _index);
  }

  void onMoveStart(LatLng latLng) {
    // find this lat
    int index = 0;
    for (LatLng p in pointLines) {
      if (p.latitude == latLng.latitude && p.longitude == latLng.longitude) {
        index = pointLines.indexOf(p);
      }
    }

    pointLines.removeAt(index);
    //markers.removeWhere((k) => k.markerId.toString() == latLng.toString());
    _index = index;
  }

  void addShape(LatLng _pos, [int? index]) {
    pos = _pos;
    if (_selectionType == 0) {
      _addCircle();
    } else if (_selectionType == 1) {
      _addPolygone(_pos, index);
    } else if (_selectionType == 2) {
      _addCircleOnMarker();
    }
    notifyListeners();
  }

  // add point to map

  void _addPolygone(LatLng _pos, [int? index, bool init = true]) {
    polygone.clear();
    circle.clear();
    if (pointLines.isEmpty) {
      markers.clear();
    }
    if (init) addPoints(_pos, index);
    polygone.clear();
    polygone.add(
      Polygon(
        consumeTapEvents: true,
        polygonId: const PolygonId('polygonId'),
        points: pointLines,
        visible: true,
        fillColor: AppConsts.mainColor.withOpacity(0.3),
        strokeColor: AppConsts.mainColor,
        strokeWidth: 4,
      ),
    );
  }

  // add circle to map with one marker
  void _addCircleOnMarker() {
    polygone.clear();
    pointLines.clear();
    circle.clear();
    markers.clear();
    markers.add(Marker(
        markerId: MarkerId(pos.toString()),
        position: pos,
        draggable: true,
        onDragEnd: (_pos) {
          pos = _pos;
          _clear();
          _addCircle(fromDarg: true);
          notifyListeners();
        }));
    circle.add(
      Circle(
        circleId: CircleId(pos.toString()),
        center: pos,
        radius: 1,
        fillColor: AppConsts.mainColor.withOpacity(0.3),
        strokeColor: AppConsts.mainColor,
        strokeWidth: 2,
      ),
    );
    addMaerkOnSidesOfCircle(pos, false);
  }

  void _addCircle({bool fromDarg = false}) {
    polygone.clear();
    pointLines.clear();
    circle.clear();
    markers.clear();
    markers.add(Marker(
        markerId: MarkerId(pos.toString()),
        position: pos,
        draggable: true,
        onDragEnd: (_pos) {
          pos = _pos;
          _clear();
          _addCircle(fromDarg: true);
          notifyListeners();
        }));
    circle.add(Circle(
      circleId: CircleId(pos.toString()),
      visible: true,
      center: pos,
      radius: double.parse(controllerGeozoneMetre.text),
      fillColor: AppConsts.mainColor.withOpacity(0.3),
      strokeColor: AppConsts.mainColor,
      strokeWidth: 4,
    ));

    addMaerkOnSidesOfCircle(pos);
  }

  void calculeDistanceBetweenTowPos(LatLng latLng1, LatLng latLng2) {
    double dist = Geolocator.distanceBetween(latLng1.latitude,
        latLng1.longitude, latLng2.latitude, latLng2.longitude);
    controllerGeozoneMetre.text = "$dist";
    addShape(pos);
  }

  void addMaerkOnSidesOfCircle(LatLng latLng, [bool isCircle = true]) {
    double dist = 0;
    if (isCircle) {
      dist = double.parse(controllerGeozoneMetre.text);
    } else {
      dist = 1;
    }

    var lat = latLng.latitude + (180 / pi) * (dist / 6371e3);
    var lon = latLng.longitude +
        (180 / pi) * (dist / 6371e3) / cos(pi / 180.0 * latLng.latitude);

    LatLng latL = LatLng(lat, lon);

    markers.add(Marker(
      markerId: MarkerId(latL.toString()),
      visible: isCircle,
      draggable: true,
      onDragEnd: (LatLng latLng2) => calculeDistanceBetweenTowPos(pos, latLng2),
      position: latL,
    ));
  }

  void _clear() {
    markers.clear();
    polygone.clear();
    circle.clear();
  }
}
