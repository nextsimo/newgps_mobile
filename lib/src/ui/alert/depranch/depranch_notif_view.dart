import 'package:flutter/material.dart';
import '../../../models/user_droits.dart';
import '../../../utils/styles.dart';
import '../../login/login_as/save_account_provider.dart';
import '../../navigation/top_app_bar.dart';
import 'package:provider/provider.dart';
import '../widgets/build_label.dart';

class DepranchNotifView extends StatefulWidget {
  const DepranchNotifView({super.key});

  @override
  State<DepranchNotifView> createState() => _DepranchNotifViewState();
}

class _DepranchNotifViewState extends State<DepranchNotifView> {
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
                  label: 'Débranchement',
                  icon: Icons.flash_off_outlined,
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
