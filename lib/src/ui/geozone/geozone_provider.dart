import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../models/account.dart';
import '../../models/geozne_sttings_alert.dart';
import '../../models/geozone.dart';
import '../../services/firebase_messaging_service.dart';
import '../../services/geozone_service.dart';
import '../../services/newgps_service.dart';
import 'geozone_dialog/geozone_action_view.dart';
import 'geozone_dialog/geozone_dialog_provider.dart';
import '../../utils/locator.dart';
import '../../widgets/buttons/main_button.dart';

class GeozoneProvider with ChangeNotifier {
  late List<GeozoneModel> _geozones = [];

  FirebaseMessagingService? firebaseMessagingService;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();

  List<GeozoneModel> get geozones => _geozones;

  GeozoneSttingsAlert? geozoneSttingsAlert;

  final GeozoneDialogProvider geozoneDialogProvider = GeozoneDialogProvider();

  bool loading = false;

  String _errorText = '';

  String get errorText => _errorText;

  set errorText(String errorText) {
    _errorText = errorText;
    notifyListeners();
  }

  set geozones(List<GeozoneModel> geozones) {
    _geozones = geozones;
    notifyListeners();
  }

  GeozoneProvider({FirebaseMessagingService? m}) {
    firebaseMessagingService = m;
    if (m != null) init();
  }

  void init() {
    fetchGeozones();
    _fetchAlertSettings();
  }

  Future<void> _fetchAlertSettings() async {
    int notifID = firebaseMessagingService!.notificationID;

    String res = await api.post(
      url: '/alert/geozone/settings',
      body: {
        'notification_id': notifID,
        'account_id': shared.getAccount()?.account.accountId,
      },
    );

    if (res.isNotEmpty) {
      geozoneSttingsAlert = geozoneSttingsAlertFromJson(res);
      notifyListeners();
    }
  }

  Future<void> updateSettings(bool newValue) async {
    int notifID = firebaseMessagingService!.notificationID;
    await api.post(
      url: '/alert/geozone/update',
      body: {
        'notification_id': notifID,
        'is_active': newValue,
      },
    );
    await _fetchAlertSettings();
  }

  bool activeAlert = false;

  void updateActiveAlert(bool val) {
    activeAlert = val;
    notifyListeners();
  }

  Future<void> addGeozone(double radius, LatLng center, String description,
      BuildContext context) async {
    Account? account = shared.getAccount();

    // print the data before sending it to the server
    print({
      'accountId': account?.account.accountId,
      'devices': geozoneDialogProvider.selectedDevices.isEmpty
          ? ''
          : geozoneDialogProvider.selectedDevices.join(','),
      'cordinates': geozoneDialogProvider.selectionType == 0 ||
              geozoneDialogProvider.selectionType == 2
          ? json.encode(List<List<double>>.from(geozoneDialogProvider.markers
              .map((e) => [e.position.latitude, e.position.longitude])
              .toList()))
          : json.encode(List<List<double>>.from(geozoneDialogProvider.pointLines
              .map((e) => [e.latitude, e.longitude])
              .toList())),
      'radius': radius,
      'description': description,
      'geozone_type': geozoneDialogProvider.selectionType,
      'innerOuterValue': geozoneDialogProvider.innerOuterValue,
      'zoom': geozoneDialogProvider.currentZoome,
    });

    String res = await api.post(
      url: '/add/geozone',
      body: {
        'accountId': account?.account.accountId,
        'devices': geozoneDialogProvider.selectedDevices.isEmpty
            ? ''
            : geozoneDialogProvider.selectedDevices.join(','),
        'cordinates': geozoneDialogProvider.selectionType == 0 ||
                geozoneDialogProvider.selectionType == 2
            ? json.encode(List<List<double>>.from(geozoneDialogProvider.markers
                .map((e) => [e.position.latitude, e.position.longitude])
                .toList()))
            : json.encode(List<List<double>>.from(geozoneDialogProvider
                .pointLines
                .map((e) => [e.latitude, e.longitude])
                .toList())),
        'radius': geozoneDialogProvider.selectionType == 0 ? radius : 1,
        'description': description,
        'geozone_type': geozoneDialogProvider.selectionType,
        'innerOuterValue': geozoneDialogProvider.innerOuterValue,
        'zoom': geozoneDialogProvider.currentZoome,
      },
    );

    if (res.isEmpty) {
      // show dialog that the geozone is already exists in frensh
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Geozone déjà existante'),
          content: const Text('Veuillez choisir un autre nom'),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
      debugPrint(res);
      return;
    }
    fetchGeozones();
  }

  Future<void> updateGeozone(double radius, LatLng center, String description,
      BuildContext context) async {
    Account? account = shared.getAccount();
    String res = await api.post(url: '/update/geozone', body: {
      'accountId': account?.account.accountId,
      'cordinates': geozoneDialogProvider.selectionType == 0 ||
              geozoneDialogProvider.selectionType == 2
          ? json.encode(List<List<double>>.from(geozoneDialogProvider.markers
              .map((e) => [e.position.latitude, e.position.longitude])
              .toList()))
          : json.encode(List<List<double>>.from(geozoneDialogProvider.pointLines
              .map((e) => [e.latitude, e.longitude])
              .toList())),
      'radius': radius,
      'description': description,
      'geozone_type': geozoneDialogProvider.selectionType,
      'innerOuterValue': geozoneDialogProvider.innerOuterValue,
      'zoom': geozoneDialogProvider.currentZoome,
      'devices': geozoneDialogProvider.selectedDevices.join(','),
    });

    if (res.isEmpty) {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (_) =>
            const AlertDialog(title: Text('Nom de geozone déja exister')),
      );
    }
    debugPrint(res);
    fetchGeozones();
  }

  Future<void> onClickUpdate(GeozoneModel geozone, BuildContext context,
      {bool readonly = false}) async {
    geozoneDialogProvider.selectedDevices = geozone.devices;
    geozoneDialogProvider.onClickUpdate(geozone);
    bool? saved = await showDialog(
      context: context,
      builder: (_) => Dialog(
          child: GeozoneActionView(
              geozoneDialogProvider: geozoneDialogProvider,
              readonly: readonly)),
    );

    if (saved!) {
      // ignore: use_build_context_synchronously
      await updateGeozone(
          double.parse(geozoneDialogProvider.controllerGeozoneMetre.text),
          geozoneDialogProvider.pos,
          geozoneDialogProvider.controllerGeozoneName.text,
          context);
    }

    await fetchGeozones();
    geozoneDialogProvider.clear();
  }

  Future<void> fetchGeozones({String search = ''}) async {
    loading = true;
    Account? account = shared.getAccount();
    late String res;
    if (search.isEmpty) {
      res = await api.post(
          url: '/geozones', body: {"accountId": account?.account.accountId});
    } else {
      res = await api.post(
          url: '/geozones',
          body: {"accountId": account?.account.accountId, 'search': search});
    }

    if (res.isNotEmpty) {
      geozones = geozoneModelFromJson(res);
      locator<GeozoneService>().fetchGeozoneFromApi();
    }
    loading = false;
  }

  void deleteGeozone(BuildContext context, String geozoneId) async {
    bool res = await customDialog(context);
    Account? account = shared.getAccount();
    log('$res');
    if (res) {
      await api.post(url: '/delete/geozone', body: {
        'accountId': account?.account.accountId,
        'geozoneId': geozoneId,
      });
      fetchGeozones();
    }
  }

  Future<void> showAddDialog(BuildContext context) async {
    bool? saved = await showDialog(
      context: context,
      builder: (_) => Dialog(
        child: GeozoneActionView(
          geozoneDialogProvider: geozoneDialogProvider,
        ),
      ),
    );

    if (saved != null && saved) {
      // ignore: use_build_context_synchronously
      await addGeozone(
          double.parse(geozoneDialogProvider.controllerGeozoneMetre.text),
          geozoneDialogProvider.pos,
          geozoneDialogProvider.controllerGeozoneName.text,
          context);
    }
    geozoneDialogProvider.clear();
  }

  Future<bool> customDialog(BuildContext context) async {
    bool res = false;
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Icon(
              Icons.delete,
              color: Colors.red,
              size: 40,
            ),
            content: const Text(
                'Etes-vous sûr que vous voulez supprimer ce geoszone'),
            actions: [
              MainButton(
                width: 90,
                height: 40,
                onPressed: () {
                  res = true;
                  Navigator.of(context).pop();
                  return;
                },
                label: 'Oui',
              ),
              const SizedBox(
                height: 20,
              ),
              MainButton(
                width: 90,
                height: 40,
                onPressed: () {
                  res = false;
                  Navigator.of(context).pop();
                  return;
                },
                label: 'Annuler',
              ),
            ],
          );
        });

    return res;
  }
}
