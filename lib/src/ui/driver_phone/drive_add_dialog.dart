import 'package:flutter/material.dart';
import 'package:newgps/src/models/account.dart';
import 'package:newgps/src/models/device.dart';
import 'package:newgps/src/services/newgps_service.dart';
import 'package:newgps/src/utils/functions.dart';
import 'package:newgps/src/widgets/buttons/main_button.dart';
import 'package:newgps/src/widgets/inputs/main_input.dart';

class DriverAddDialog extends StatefulWidget {
  final Device device;
  const DriverAddDialog({Key? key, required this.device}) : super(key: key);

  @override
  State<DriverAddDialog> createState() => _DriverAddDialogState();
}

class _DriverAddDialogState extends State<DriverAddDialog> {
  final TextEditingController _phone1controller = TextEditingController();
  final TextEditingController _phone2controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    super.dispose();
    _phone1controller.dispose();
    _phone2controller.dispose();
  }

  Future<void> _savePhone() async {
    Account? account = shared.getAccount();
    if (_formKey.currentState!.validate()) {
      String res = await api.post(url: '/driver/add/phones', body: {
        'account_id': account?.account.accountId,
        'device_id': widget.device.deviceId,
        'phone1': _phone1controller.text,
        'phone2': _phone2controller.text.isEmpty ? ' ' : _phone2controller.text,
      });

      if (res == 'succes') {
        Navigator.of(context).pop<bool>(true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Material(
        color: Colors.transparent,
        child: Align(
          alignment: isPortrait ? Alignment.center : Alignment.topCenter,
          child: Container(
            width: 450,
            padding: const EdgeInsets.all(8.0),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            color: Colors.white,
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Veuillez insérer le numéro du conducteur',
                        style: Theme.of(context).textTheme.subtitle1),
                    const SizedBox(height: 5),
                    MainInput(
                      validator: FormValidatorService.isMoroccanPhoneNumber,
                      textInputType: TextInputType.phone,
                      controller: _phone1controller,
                      icon: Icons.phone,
                      hint: 'Téléphone 1',
                      autofocus: true,
                    ),
                    const SizedBox(height: 6),
                    MainInput(
                      validator:
                          FormValidatorService.isMoroccanPhoneNumberNotEmpty,
                      controller: _phone2controller,
                      textInputType: TextInputType.phone,
                      icon: Icons.phone_android,
                      hint: 'Téléphone 2',
                    ),
                    const SizedBox(height: 6),
                    MainButton(
                      onPressed: _savePhone,
                      label: 'Enregister',
                    ),
                    const SizedBox(height: 6),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
