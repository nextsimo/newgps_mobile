import 'package:flutter/material.dart';
import 'package:newgps/src/models/user_droits.dart';
import 'package:newgps/src/utils/styles.dart';
import 'package:newgps/src/ui/login/login_as/save_account_provider.dart';
import 'package:newgps/src/ui/navigation/top_app_bar.dart';
import 'package:provider/provider.dart';
import '../widgets/build_label.dart';

class TemperatureView extends StatefulWidget {
  const TemperatureView({Key? key}) : super(key: key);

  @override
  State<TemperatureView> createState() => _TemperatureViewState();
}

class _TemperatureViewState extends State<TemperatureView> {
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
                  label: 'température',
                  icon: Icons.fireplace,
                ),
                const SizedBox(height: 20),
                _buildStatusLabel(),
                const SizedBox(height: 20),
                _buildHistoric(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHistoric() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Historiques:'),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(AppConsts.outsidePadding),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                childAspectRatio: 2.8,
                crossAxisSpacing: AppConsts.outsidePadding,
                maxCrossAxisExtent: 400,
                mainAxisSpacing: AppConsts.outsidePadding,
              ),
              itemCount: 0,
              itemBuilder: (_, int index) {
                return const SizedBox();
              },
            ),
          ),
        ],
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
