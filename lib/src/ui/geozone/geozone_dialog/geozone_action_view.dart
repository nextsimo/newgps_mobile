import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:newgps/src/services/device_provider.dart';
import 'package:newgps/src/utils/functions.dart';
import 'package:newgps/src/utils/styles.dart';
import 'package:newgps/src/ui/geozone/geozone_dialog/geozone_dialog_provider.dart';
import 'package:newgps/src/widgets/buttons/main_button.dart';
import 'package:newgps/src/widgets/buttons/zoom_button.dart';
import 'package:newgps/src/widgets/map_type_widget.dart';
import 'package:provider/provider.dart';

import '../../../widgets/inputs/select_device_widget.dart';

class GeozoneActionView extends StatelessWidget {
  final GeozoneDialogProvider geozoneDialogProvider;
  final bool readonly;

  const GeozoneActionView(
      {Key? key, required this.geozoneDialogProvider, this.readonly = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GeozoneDialogProvider>.value(
        value: geozoneDialogProvider,
        builder: (context, snapshot) {
          final GeozoneDialogProvider geozoneDialogProvider =
              Provider.of<GeozoneDialogProvider>(context, listen: false);

          bool isPortrait =
              MediaQuery.of(context).orientation == Orientation.portrait;
          if (isPortrait) {
            return _PortraitDialog(
                geozoneDialogProvider: geozoneDialogProvider,
                readonly: readonly);
          }

          return _LandscapeDialog(
              geozoneDialogProvider: geozoneDialogProvider, readonly: readonly);
        });
  }
}

class _LandscapeDialog extends StatelessWidget {
  final bool readonly;
  const _LandscapeDialog({
    Key? key,
    required this.geozoneDialogProvider,
    this.readonly = false,
  }) : super(key: key);

  final GeozoneDialogProvider geozoneDialogProvider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Form(
                  key: geozoneDialogProvider.formKey,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: GeozoneInput(
                          readonly: readonly,
                          hint: 'Nom de la geozone',
                          validator: FormValidatorService.isNotEmpty,
                          controller:
                              geozoneDialogProvider.controllerGeozoneName,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 2,
                        child: TypeSelectionGeozone(
                          readonly: readonly,
                        ),
                      ),
                      const SizedBox(width: 10),
                      if (!readonly)
                        Expanded(
                          flex: 2,
                          child: Row(
                            children: [
                              Expanded(
                                child: MainButton(
                                  backgroundColor: Colors.red,
                                  onPressed: () =>
                                      geozoneDialogProvider.pop(context),
                                  label: 'Annuler',
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (readonly) const CloseButton(color: Colors.black)
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: GeoZoneSelectType(
                        context: context,
                        readonly: readonly,
                      ),
                    ),
                    const SizedBox(width: 7),
                    Expanded(
                      flex: 2,
                      child: GeozoneInput(
                        readonly: readonly,
                        hint: 'Par defaut: 4000 m',
                        validator: FormValidatorService.isNumber,
                        controller:
                            geozoneDialogProvider.controllerGeozoneMetre,
                      ),
                    ),
                    const SizedBox(width: 10),
                    if (!readonly)
                      Expanded(
                        flex: 2,
                        child: MainButton(
                          onPressed: () =>
                              geozoneDialogProvider.onSave(context),
                          label: 'Enregister',
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: GeozoneMap(
            readonly: readonly,
          ),
        ),
      ],
    );
  }
}

class _PortraitDialog extends StatelessWidget {
  const _PortraitDialog({
    Key? key,
    required this.geozoneDialogProvider,
    this.readonly = false,
  }) : super(key: key);

  final GeozoneDialogProvider geozoneDialogProvider;
  final bool readonly;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Form(
                  key: geozoneDialogProvider.formKey,
                  child: Row(
                    children: [
                      Expanded(
                        child: GeozoneInput(
                          readonly: readonly,
                          hint: 'Nom de la geozone',
                          validator: FormValidatorService.isNotEmpty,
                          controller:
                              geozoneDialogProvider.controllerGeozoneName,
                        ),
                      ),
                      if (readonly) const CloseButton(color: Colors.black)
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TypeSelectionGeozone(
                        readonly: readonly,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      flex: 2,
                      child: GeozoneInput(
                        hint: 'Par defaut: 4000 m',
                        readonly: readonly,
                        validator: FormValidatorService.isNumber,
                        controller:
                            geozoneDialogProvider.controllerGeozoneMetre,
                      ),
                    ),
                  ],
                ),
                //
                const SizedBox(height: 10),
                GeoZoneSelectType(
                  readonly: readonly,
                  context: context,
                ),
                const SizedBox(height: 10),
                SelectedDeviceWidget(
                  onSelected: geozoneDialogProvider.zoomToDevice,
                  selectedDevices: geozoneDialogProvider.selectedDevices,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    if (!readonly)
                      Expanded(
                        child: MainButton(
                          onPressed: () =>
                              geozoneDialogProvider.onSave(context),
                          label: 'Enregister',
                        ),
                      ),
                    const SizedBox(width: 4),
                    if (!readonly)
                      Expanded(
                        child: MainButton(
                          backgroundColor: Colors.red,
                          onPressed: () => geozoneDialogProvider.pop(context),
                          label: 'Annuler',
                        ),
                      )
                  ],
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: GeozoneMap(
            readonly: readonly,
          ),
        ),
      ],
    );
  }
}

class GeozoneMap extends StatelessWidget {
  final bool readonly;
  const GeozoneMap({Key? key, this.readonly = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GeozoneDialogProvider geozoneDialogProvider =
        Provider.of<GeozoneDialogProvider>(context);
    final DeviceProvider deviceProvider =
        Provider.of<DeviceProvider>(context, listen: false);
    return Stack(
      children: [
        GoogleMap(
          markers: geozoneDialogProvider.markers..addAll(geozoneDialogProvider.deviceMarkers),
          onTap: readonly ? null : geozoneDialogProvider.addShape,
          circles: geozoneDialogProvider.circle,
          polygons: geozoneDialogProvider.polygone,
          onMapCreated: geozoneDialogProvider.initMap,
          mapToolbarEnabled: false,
          myLocationEnabled: true,
          zoomControlsEnabled: true,
          myLocationButtonEnabled: false,
          mapType: deviceProvider.mapType,
          onCameraMove: (pos) {
            geozoneDialogProvider.currentZoome = pos.zoom;
          },
          initialCameraPosition:
              const CameraPosition(target: LatLng(33.5731, -7.5898), zoom: 5.5),
        ),
        Selector<GeozoneDialogProvider, GoogleMapController?>(
          builder: (_, c, __) {
            if (c == null) return const SizedBox();
            return Positioned(
              top: 10,
              right: 10,
              child: MapZoomWidget(controller: c),
            );
          },
          selector: (_, __) => __.googleMapController,
        ),
        MapTypeWidget(onChange: (mapType) {
          deviceProvider.mapType = mapType;
          geozoneDialogProvider.notify();
        }),
      ],
    );
  }
}

class TypeSelectionGeozone extends StatelessWidget {
  final bool readonly;
  const TypeSelectionGeozone({Key? key, this.readonly = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GeozoneDialogProvider geozoneDialogProvider =
        Provider.of<GeozoneDialogProvider>(context);

    return Container(
      height: 50,
      padding: const EdgeInsets.only(left: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConsts.mainradius),
        border: Border.all(
            width: AppConsts.borderWidth, color: AppConsts.mainColor),
      ),
      child: IgnorePointer(
        ignoring: readonly,
        child: DropdownButton<int>(
          borderRadius: BorderRadius.circular(AppConsts.mainradius),
          underline: const SizedBox(),
          isExpanded: true,
          value: geozoneDialogProvider.selectionType,
          onChanged: readonly
              ? (_) {}
              : (val) {
                  geozoneDialogProvider.selectionType =
                      val ?? geozoneDialogProvider.selectionType;
                },
          hint: const Text('Type de sélection'),
          items: const [
            DropdownMenuItem<int>(
              child: Text(
                'Cercle',
              ),
              value: 0,
            ),
            DropdownMenuItem<int>(
              child: Text(
                'Polygone',
              ),
              value: 1,
            ),
            DropdownMenuItem<int>(
              child: Text(
                'Point',
              ),
              value: 2,
            ),
          ],
        ),
      ),
    );
  }
}

class _InnerOuterMode {
  final int value;
  final String label;

  const _InnerOuterMode({required this.value, required this.label});
}

class GeoZoneSelectType extends StatelessWidget {
  final BuildContext context;
  final bool readonly;
  const GeoZoneSelectType(
      {Key? key, required this.context, this.readonly = false})
      : super(key: key);

  final List<_InnerOuterMode> _items = const [
    _InnerOuterMode(value: 0, label: 'Entrée'),
    _InnerOuterMode(value: 1, label: 'Sortie'),
    _InnerOuterMode(value: 2, label: 'Entrée-Sortie'),
  ];

  @override
  Widget build(BuildContext context) {
    int innerOuterValue =
        context.select<GeozoneDialogProvider, int>((p) => p.innerOuterValue);

    return Row(
      children: _items.map<Widget>((item) {
        return _InnerOuterWigdet(
          readOnly: readonly,
          label: item.label,
          value: item.value,
          isSelected: innerOuterValue == item.value,
        );
      }).toList(),
    );
  }
}

class _InnerOuterWigdet extends StatelessWidget {
  final String label;
  final int value;
  final bool isSelected;
  final bool readOnly;

  const _InnerOuterWigdet(
      {Key? key,
      required this.label,
      required this.value,
      required this.isSelected,
      this.readOnly = false})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final GeozoneDialogProvider provider =
        Provider.of<GeozoneDialogProvider>(context, listen: false);
    return Expanded(
      child: InkWell(
        onTap: readOnly ? () {} : () => provider.updateInnerOuterValue(value),
        child: Container(
          height: 50,
          margin: const EdgeInsets.only(right: 1),
          decoration: BoxDecoration(
            border: Border.all(
              width: AppConsts.borderWidth,
              color: Colors.green,
            ),
            color: isSelected ? Colors.green : Colors.white,
            borderRadius: BorderRadius.circular(AppConsts.mainradius),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(label,
                    style: TextStyle(
                      fontSize: 10,
                      color: isSelected ? Colors.white : Colors.black,
                    )),
                if (isSelected)
                  const Padding(
                    padding: EdgeInsets.only(left: 3),
                    child: Icon(Icons.check, size: 13, color: Colors.white),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GeozoneInput extends StatelessWidget {
  final String? Function(String?)? validator;
  final String hint;
  final bool readonly;
  final TextEditingController? controller;
  const GeozoneInput(
      {Key? key,
      required this.hint,
      this.controller,
      this.validator,
      this.readonly = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var outlineInputBorder = OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConsts.mainradius),
        borderSide: const BorderSide(color: AppConsts.mainColor, width: 1.5));
    return TextFormField(
      validator: validator,
      controller: controller,
      readOnly: readonly,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        border: outlineInputBorder,
        enabledBorder: outlineInputBorder,
        focusedBorder: outlineInputBorder,
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}
