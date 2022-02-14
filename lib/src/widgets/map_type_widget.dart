import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapTypeWidget extends StatelessWidget {
  final void Function(MapType) onChange;
  const MapTypeWidget({Key? key, required this.onChange}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MapType>(
      onSelected: onChange,
      child: Container(
        padding: EdgeInsets.zero,
        width: 35,
        height: 35,
        child: const Icon(
          Icons.map_outlined,
          color: Colors.black,
        ),
      ),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<MapType>>[
        const PopupMenuItem<MapType>(
          value: MapType.normal,
          child: Text('Vue normale'),
        ),
        const PopupMenuItem<MapType>(
          value: MapType.hybrid,
          child: Text('Vue hybride'),
        ),
        const PopupMenuItem<MapType>(
          value: MapType.satellite,
          child: Text('Vue satellite'),
        ),
        const PopupMenuItem<MapType>(
          value: MapType.terrain,
          child: Text('Vue Terrain'),
        ),
      ],
    );
  }
}
