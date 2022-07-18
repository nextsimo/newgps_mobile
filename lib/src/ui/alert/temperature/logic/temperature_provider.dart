import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:newgps/src/services/firebase_messaging_service.dart';
import 'package:newgps/src/services/newgps_service.dart';
import 'package:newgps/src/ui/alert/temperature/logic/config_temp_ble_model.dart';
import 'package:newgps/src/ui/alert/temperature/logic/temp_global_setting.dart';

class TemperatureBleProvider with ChangeNotifier {
  late int notificationId;

  late TempGlobalSetting _globalSetting;

  final PageController pageController = PageController();

  String? accountId;

// start initalization
  TemperatureBleProvider([FirebaseMessagingService? service]) {
    if (service != null) {
      notificationId = service.notificationID;
      _init();
    }
  }

  void _init() async {
    // init accountId
    accountId = shared.getAccount()?.account.accountId;
    await _fetchGlobaleNotificationState();
    _fetchConfigs();
  }

  // dispose page controller
  @override
  void dispose() {
    pageController.dispose();
    configNameController.dispose();
    minController.dispose();
    maxController.dispose();
    super.dispose();
  }

// end initalization

  ///* start handle globale notification *///
  bool _globaleNotificationEnabled = false;

  bool get globaleNotificationEnabled => _globaleNotificationEnabled;

  set globaleNotificationEnabled(bool globaleNotificationEnabled) {
    _globaleNotificationEnabled = globaleNotificationEnabled;
    notifyListeners();
  }

  // Update the globaleNotificationEnabled value
  void updateGlobaleNotificationEnabled(bool newValue) {
    globaleNotificationEnabled = newValue;
    _updateGlobaleNotificationState();
  }

  // fetch gloable notification state from server
  Future<void> _fetchGlobaleNotificationState() async {
    String res = await api.post(
      url: '/thermometer/settings',
      body: {
        'account_id': accountId,
        'notification_id': notificationId,
      },
    );

    if (res.isNotEmpty) {
      log(res);
      _globalSetting = tempGlobalSettingFromJson(res);
      globaleNotificationEnabled = _globalSetting.isActive;
    }
  }

  // udpate globale notification state on server
  Future<void> _updateGlobaleNotificationState() async {
    String res = await api.post(
      url: '/thermometer/settings/update/state',
      body: {
        'id': _globalSetting.id,
        'is_active': globaleNotificationEnabled,
      },
    );

    if (res.isNotEmpty) {
      log(res);
    }
  }

  ///* end handle globale notification *///

  // method to show config_view
  // define const duration and const curve
  final Duration _duration = const Duration(milliseconds: 300);
  final Curve _curve = Curves.easeIn;
  void _showConfigFormView() {
    pageController.nextPage(duration: _duration, curve: _curve);
  }

  // show config_form_view
  void showConfigListView() {
    pageController.previousPage(duration: _duration, curve: _curve);
  }

  // form view params

  final TextEditingController configNameController = TextEditingController();
  final TextEditingController minController =
      TextEditingController(text: '-40');
  final TextEditingController maxController = TextEditingController(text: '85');

  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void setSelectedIndex(int selectedIndex) {
    _selectedIndex = selectedIndex;
    notifyListeners();
  }

  String _validationMessage = '';

  String get validationMessage => _validationMessage;

  set validationMessage(String validationMessage) {
    _validationMessage = validationMessage;
    notifyListeners();
  }

  List<ConfigTempBle> _configs = [];

  List<ConfigTempBle> get configs => _configs;

  set configs(List<ConfigTempBle> configs) {
    _configs = configs;
    notifyListeners();
  }

  // fetch list of configs from server
  Future<void> _fetchConfigs() async {
    String res = await api.post(
      url: '/thermometer/config/index',
      body: {'setting_id': _globalSetting.id},
    );

    if (res.isNotEmpty) {
      configs = configTempBleFromJson(res);
      log(res);
    }
  }

  // handle validation message from form content
  bool _handleValidationMessage() {
    if (configNameController.text.isEmpty ||
        minController.text.isEmpty ||
        maxController.text.isEmpty) {
      validationMessage = 'Merci de compléter tous les champs.';
      return false;
    }
    if (!_isNumeric(minController.text) || !_isNumeric(maxController.text)) {
      validationMessage = 'Merci de saisir des nombres pour les températures.';
      return false;
    }
    if (double.parse(minController.text) > double.parse(maxController.text)) {
      validationMessage =
          'La température minimum doit être inférieure à la température maximum.';
      return false;
    }
    if (selectedDevice.isEmpty) {
      validationMessage = 'Merci de sélectionner au moins un appareil.';
      return false;
    }
    validationMessage = '';
    return true;
  }

  // check if string is numeric
  bool _isNumeric(String str) {
    return double.tryParse(str) != null;
  }

  bool configIsEnabled = true;

  void setConfigIsEnabled(bool newValue) {
    configIsEnabled = newValue;
    notifyListeners();
  }


  // update or save new config
  Future<void> updateOrSaveConfig(BuildContext context) async {
    // uncfocus all text fields
    FocusScope.of(context).unfocus();
    if (!_handleValidationMessage()) return;
    if (_configId != null) {
      _updateConfig(_configId as int);
    } else {
      _saveForm();
    }
  }

  // save form
  Future<void> _saveForm() async {
    String res = await api.post(
      url: '/thermometer/config/create',
      body: {
        'account_id': shared.getAccount()?.account.accountId,
        'notification_id': notificationId,
        'config_name': configNameController.text,
        'is_active': configIsEnabled,
        'in_range': _selectedIndex == 0,
        'min_value': int.parse(minController.text),
        'max_value': int.parse(maxController.text),
        'devices': selectedDevice.join(','),
        'setting_id': _globalSetting.id,
        'id': _globalSetting.id,
      },
    );

    if (res.isNotEmpty) {
      log(res);
      _fetchConfigs();
      showConfigListView();
    }
  }

  List<String> _selectedDevice = [];

  List<String> get selectedDevice => _selectedDevice;

  set selectedDevice(List<String> selectedDevice) {
    _selectedDevice = selectedDevice;
    notifyListeners();
  }

  // show confirmation dialog to delete config
  Future<void> showConfirmationDialog(BuildContext context, int configid) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Supprimer la configuration'),
          content:
              const Text('Voulez-vous vraiment supprimer la configuration ?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Supprimer'),
              onPressed: () {
                _removeConfig(configid);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // delete config by id
  Future<void> _removeConfig(int id) async {
    await api.post(
      url: '/thermometer/config/delete',
      body: {
        'config_id': id,
      },
    );

    _fetchConfigs();
  }

  // check id device id is in list of devices
  bool isDeviceIdInList(String deviceId) {
    return _selectedDevice.contains(deviceId);
  }

  // add to device list or remove
  void addOrRemoveDevice(String deviceId) {
    // new list from selectedDevice
    List<String> newList = List<String>.from(_selectedDevice);

    if (isDeviceIdInList(deviceId)) {
      newList.remove(deviceId);
    } else {
      newList.add(deviceId);
    }

    selectedDevice = List.from(newList);
  }

  // form view params

  // init all params and input with default values
  void _initFormViewParams() {
    configNameController.text = '';
    minController.text = '-40';
    maxController.text = '85';
    selectedDevice = [];
    configIsEnabled = true;
  }

  // init all params and inputs in config_form_view from config object
  void _initConfigFormViewFromModel(ConfigTempBle config) {
    configNameController.text = config.name;
    minController.text = config.minValue.toString();
    maxController.text = config.maxValue.toString();
    configIsEnabled = config.isActive;
    _selectedIndex = config.inRange ? 0 : 1;
    selectedDevice = config.selectedDevices;
  }

  // navigate to add config view
  void navigateToAddConfigView() {
    _configId = null;
    _initFormViewParams();
    _showConfigFormView();
  }

  // navigate to config_form_view from config card and init form view params
  void navigateToConfigFormViewFromConfigCard(ConfigTempBle config) {
    _configId = config.id;
    _initConfigFormViewFromModel(config);
    _showConfigFormView();
  }

  int? _configId;

  // update config by id
  Future<void> _updateConfig(int id) async {
    if (!_handleValidationMessage()) {
      return;
    }
    String res = await api.post(
      url: '/thermometer/config/update',
      body: {
        'account_id': shared.getAccount()?.account.accountId,
        'notification_id': notificationId,
        'config_name': configNameController.text,
        'is_active': configIsEnabled,
        'in_range': _selectedIndex == 0,
        'min_value': int.parse(minController.text),
        'max_value': int.parse(maxController.text),
        'devices': selectedDevice.join(','),
        'setting_id': _globalSetting.id,
        'id': id,
      },
    );

    if (res.isNotEmpty) {
      log(res);
      _fetchConfigs();
      showConfigListView();
    }
  }
}
