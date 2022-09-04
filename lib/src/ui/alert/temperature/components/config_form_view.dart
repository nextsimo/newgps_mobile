import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../widgets/buttons/main_button.dart';
import 'package:provider/provider.dart';

import '../logic/temperature_provider.dart';
import 'check_box_temp.dart';
import 'devices_list.dart';
import 'input_text_field.dart';
import 'validation_message.dart';

class ConfigFormView extends StatelessWidget {
  const ConfigFormView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // read provider
    final TemperatureBleProvider provider =
        context.read<TemperatureBleProvider>();
    return Column(
      children: [
        // add row with back button and save button
        _BuildHeader(provider: provider),

        Expanded(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(18),
            children: [
              const _BuildState(),
              MyInputTextField(
                placeholder: 'Nom de la configuration',
                icon: CupertinoIcons.settings,
                controller: provider.configNameController,
              ),
              const SizedBox(height: 10),
              const CheckBoxTemp(),
              const SizedBox(height: 10),
              const _IntervalWidget(),
              const SizedBox(height: 10),
              // error message widget
              const MyDevicesList(),
              const SizedBox(height: 10),
              const ValidationMessage(),
            ],
          ),
        ),
      ],
    );
  }
}

class _IntervalWidget extends StatelessWidget {
  const _IntervalWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TemperatureBleProvider provider =
        context.read<TemperatureBleProvider>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Intervalle (De -40°C à +85°C)',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: MyInputTextField(
                icon: CupertinoIcons.minus_circle,
                keyboardType: TextInputType.number,
                controller: provider.minController,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: MyInputTextField(
                icon: CupertinoIcons.plus_circle,
                keyboardType: TextInputType.number,
                controller: provider.maxController,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _BuildHeader extends StatelessWidget {
  const _BuildHeader({
    Key? key,
    required this.provider,
  }) : super(key: key);

  final TemperatureBleProvider provider;

  @override
  Widget build(BuildContext context) {
    // read provider
    final TemperatureBleProvider provider =
        context.read<TemperatureBleProvider>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: provider.showConfigListView,
          ),
          Expanded(
              child: MainButton(
            onPressed: () => provider.updateOrSaveConfig(context),
            label: 'Enregistrer',
          )),
        ],
      ),
    );
  }
}

class _BuildState extends StatelessWidget {
  const _BuildState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // read provider
    final TemperatureBleProvider provider =
        context.read<TemperatureBleProvider>();
    return Selector<TemperatureBleProvider, bool>(
        selector: (context, temperatureBleProvider) =>
            temperatureBleProvider.configIsEnabled,
        builder: (context, configIsEnabled, _) {
          return SwitchListTile(
            title: const Text('Statut:'),
            value: configIsEnabled,
            onChanged: provider.setConfigIsEnabled,
          );
        });
  }
}
