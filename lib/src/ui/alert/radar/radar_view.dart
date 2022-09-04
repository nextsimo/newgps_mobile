import 'package:flutter/material.dart';
import '../../../models/user_droits.dart';
import '../../../utils/styles.dart';
import '../../login/login_as/save_account_provider.dart';
import '../../navigation/top_app_bar.dart';
import 'package:provider/provider.dart';
import '../widgets/build_label.dart';

class RadarNotifView extends StatefulWidget {
  const RadarNotifView({Key? key}) : super(key: key);

  @override
  State<RadarNotifView> createState() => _RadarNotifViewState();
}

class _RadarNotifViewState extends State<RadarNotifView> {
  bool _isActive = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        actions: [CloseButton(color: Colors.black)],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Padding(
            padding: const EdgeInsets.all(AppConsts.outsidePadding),
            child: Column(
              children: [
                const SizedBox(height: 10),
                const BuildLabel(
                  label: 'radar',
                  icon: Icons.radio_button_on_sharp,
                ),
                const SizedBox(height: 20),
                _buildStatusLabel(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildStatusLabel() {
    Droit droit = Provider.of<SavedAcountProvider>(context, listen: false)
        .userDroits
        .droits[4];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Notification statut:'),
        Switch(
            value: _isActive,
            onChanged: droit.write
                ? (_) {
                    setState(() {
                      _isActive = !_isActive;
                    });
                  }
                : null),
      ],
    );
  }
}
