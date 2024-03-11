import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:label_marker/label_marker.dart';

class RepportMapProvider with ChangeNotifier {
  Set<Marker> markers = {};

  RepportMapProvider(Set<Marker> ms) {
    _init(ms);
  }

  void _init(Set<Marker> ms) {
    _setMarkersStartEnd(ms);
  }

  void _setMarkersStartEnd(Set<Marker> ms) {
    if (ms.length <= 1) {
      markers = ms;
      return;
    }

    Set<Marker> newMarkers = {};
    newMarkers.addLabelMarker(
      LabelMarker(
        label: 'Start',
        markerId: const MarkerId('Start'),
        position: LatLng(
          ms.first.position.latitude,
          ms.first.position.longitude,
        ),
      ),
    );
    newMarkers.addAll(ms);
    newMarkers.addLabelMarker(
      LabelMarker(
        label: 'End',
        markerId: const MarkerId('End'),
        position: LatLng(
          ms.last.position.latitude,
          ms.last.position.longitude,
        ),
      ),
    );
    markers = newMarkers;
  }

  // on create map
  final Completer<GoogleMapController> controller = Completer();
  void onMapCreated(GoogleMapController controller) {
    this.controller.complete(controller);
    _handleZoom();
  }

// zoom to first marker
  Future<void> _zoomToMarker() async {
    final GoogleMapController controller = await this.controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: LatLng(
          markers.first.position.latitude,
          markers.first.position.longitude,
        ),
        zoom: 15,
      ),
    ));
  }

  // handle zoome to marker or bounds
  Future<void> _handleZoom() async {
    await  Future.delayed(const Duration(seconds: 1));
    if (markers.length <= 1) {
      return _zoomToMarker();
    }
    _zoomToBounds();
  }

  // zoom to the bounds of the markers
  Future<void> _zoomToBounds() async {
    final GoogleMapController controller = await this.controller.future;
    final LatLngBounds newBounds = LatLngBounds(
      southwest: LatLng(
        markers.first.position.latitude,
        markers.first.position.longitude,
      ),
      northeast: LatLng(
        markers.last.position.latitude,
        markers.last.position.longitude,
      ),
    );
    controller.animateCamera(CameraUpdate.newLatLngBounds(newBounds, 50));
  }

  @override
  void dispose() {
    markers.clear();
    controller.future.then((GoogleMapController controller) {
      controller.dispose();
    });
    super.dispose();
  }
}
