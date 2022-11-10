import 'package:flutter/material.dart';
import '../../../../utils/styles.dart';
import '../logic/config_temp_ble_model.dart';
import 'package:provider/provider.dart';

import '../logic/temperature_provider.dart';
import 'add_button.dart';
import 'empty_widget.dart';

class ConfigListView extends StatelessWidget {
  const ConfigListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const AddButton(),
        Expanded(
          child: Selector<TemperatureBleProvider, List<ConfigTempBle>>(
            selector: (context, provider) => provider.configs,
            builder: (context, configs, _) {
              if (configs.isEmpty) {
                return const MyEmptyWidget();
              }
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 15),
                itemCount: configs.length,
                itemBuilder: (context, index) {
                  final config = configs[index];
                  return _BuildCard(config: config);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _BuildCard extends StatelessWidget {
  const _BuildCard({
    Key? key,
    required this.config,
  }) : super(key: key);

  final ConfigTempBle config;

  @override
  Widget build(BuildContext context) {
    // read provider
    final TemperatureBleProvider provider =
        context.read<TemperatureBleProvider>();
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppConsts.mainradius),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        onTap: () => provider.navigateToConfigFormViewFromConfigCard(config),
        title: Text(
          config.name,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          "${config.minValue} °C - ${config.maxValue} °C",
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xffabb8d6),
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () => provider.showConfirmationDialog(context, config.id),
        ),
      ),
    );
  }
}
