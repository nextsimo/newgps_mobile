import 'package:flutter/material.dart';
import '../../utils/styles.dart';
import 'connected_device_model.dart';
import 'connected_device_provider.dart';
import '../../utils/functions.dart';
import '../../widgets/buttons/main_button.dart';
import 'package:provider/provider.dart';

class ConnectedDeviceView extends StatelessWidget {
  const ConnectedDeviceView({super.key});
  
  @override
  Widget build(BuildContext context) {
    final List<ConnectedDeviceModel> connectedDevices =
        context.select<ConnectedDeviceProvider, List<ConnectedDeviceModel>>(
            (value) => value.conctedDevices);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Navigator.of(context).pop(),
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppConsts.mainradius),
              color: Colors.white,
            ),
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                ListView.separated(
                  padding: const EdgeInsets.fromLTRB(15, 50, 15, 15),
                  itemCount: connectedDevices.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (_, int index) {
                    return _BuildConnectedWidget(
                        mode: connectedDevices.elementAt(index));
                  },
                ),
                const CloseButton(color: Colors.black),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BuildConnectedWidget extends StatelessWidget {
  final ConnectedDeviceModel mode;
  const _BuildConnectedWidget({
    required this.mode,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.brightness_1,
                  color: mode.isConnected ? Colors.green : Colors.red),
              const SizedBox(width: 4),
              Text(
                '${mode.deviceBrand} ${mode.platform} ${mode.os}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: 5),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Périphérique ID:',
                  style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 5),
              Text(
                mode.deviceUid,
                overflow: TextOverflow.visible,
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),
          if (mode.phoneNumber.isNotEmpty)
            Row(
              children: [
                Text(
                  mode.phoneNumber,
                  style: const TextStyle(
                    decoration: TextDecoration.underline,
                  ),
                ),
                const SizedBox(width: 5),
                MainButton(
                  onPressed: () {},
                  label: 'Appeler',
                  height: 25,
                  width: 77,
                  fontSize: 12,
                  icon: Icons.call,
                ),
              ],
            ),
          const SizedBox(height: 5),
          Row(
            children: [
              Text('Dèrniere connexion:',
                  style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(width: 4),
              Text(formatSimpleDate(mode.lastConnectedDate, true),
                  style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ],
      ),
    );
  }
}
