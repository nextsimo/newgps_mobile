import 'package:flutter/material.dart';
import '../../../models/user_droits.dart';
import '../../../utils/styles.dart';
import '../widgets/build_label.dart';
import '../../login/login_as/save_account_provider.dart';
import '../../navigation/top_app_bar.dart';
import 'package:provider/provider.dart';

class HighwayNotifView extends StatefulWidget {
  const HighwayNotifView({super.key});

  @override
  State<HighwayNotifView> createState() => _HighwayNotifViewState();
}

class _HighwayNotifViewState extends State<HighwayNotifView> {
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
                    label: 'Autoroute', icon: Icons.edit_road_rounded),
                const SizedBox(height: 20),
                _buildStatusLabel(),
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
