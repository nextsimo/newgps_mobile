import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../utils/styles.dart';

class MapZoomWidget extends StatelessWidget {
  final GoogleMapController controller;

  const MapZoomWidget({super.key, required this.controller});
  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;

    if (orientation == Orientation.landscape) {
      return SafeArea(
        bottom: false,
        right: false,
        top: false,
        minimum: EdgeInsets.zero,
        child: Container(
          width: 38,
          height: 85,
          margin: const EdgeInsets.only(top: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConsts.mainradius),
            color: Colors.grey[50],
            border: Border.all(
              width: 1.0,
              color: Colors.grey[400]!,
            ),
          ),
          child: Center(
            child: Column(
              children: [
                Expanded(
                  child: IconButton(
                      icon: const Icon(Icons.add),
                      iconSize: 16,
                      onPressed: () {
                        controller.animateCamera(CameraUpdate.zoomIn());
                        //controller.animateCamera(CameraUpdate.zoomIn());
                      }),
                ),
                Container(
                  height: 1.1,
                  color: Colors.grey[400],
                ),
                Expanded(
                  child: Center(
                    child: IconButton(
                      icon: const Icon(Icons.remove),
                      iconSize: 16,
                      onPressed: () {
                        controller.animateCamera(CameraUpdate.zoomOut());
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }
    return Container(
      width: 38,
      height: 85,
      margin: const EdgeInsets.only(top: 3.5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConsts.mainradius),
          color: Colors.grey[50],
          border: Border.all(
            width: 1.2,
            color: Colors.grey[400]!,
          )),
      child: Center(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: IconButton(
                    icon: const Icon(Icons.add),
                    iconSize: 16,
                    onPressed: () {
                      controller.animateCamera(CameraUpdate.zoomIn());

                      //controller.animateCamera(CameraUpdate.zoomIn());
                    }),
              ),
            ),
            Container(
              height: 1.1,
              color: Colors.grey[400],
            ),
            Expanded(
              child: Center(
                child: IconButton(
                  icon: const Icon(Icons.remove),
                  iconSize: 16,
                  onPressed: () {
                    controller.animateCamera(CameraUpdate.zoomOut());
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
