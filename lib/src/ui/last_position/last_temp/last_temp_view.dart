import 'package:flutter/material.dart';
import 'last_temp_provider.dart';
import 'package:provider/provider.dart';

class LastTempView extends StatelessWidget {
  const LastTempView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LastTempProvider>(
        create: (context) => LastTempProvider(),
        builder: (context, snapshot) {
          // watch the provider
          LastTempProvider provider = context.read<LastTempProvider>();
          return StreamBuilder<Object>(
              stream: Stream.periodic(const Duration(seconds: 20), (_) async {
                return provider.fetchLastTempRepport();
              }),
              builder: (context, snapshot) {
                context.watch<LastTempProvider>();
                final model = provider.model;
                if (model == null) {
                  return const SizedBox();
                }
                return Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Material(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        buildTextWithIcon(
                            'Température',
                            Icons.thermostat_outlined,
                            '${model.temperature1}°C'),
                        const SizedBox(height: 10),
                        buildTextWithIcon(
                            'Humidité',
                            Icons.radio_button_checked_sharp,
                            '${model.humidity1}%'),
                        const SizedBox(height: 10),
                        buildTextWithIcon('Statut', Icons.offline_bolt,
                            (model.isActive) ? 'ON' : 'OFF'),
                      ],
                    ),
                  ),
                );
              });
        });
  }

  // build text with icon
  Widget buildTextWithIcon(String text, IconData icon, String? value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: Colors.black,
          size: 16,
        ),
        const SizedBox(
          width: 20,
        ),
        SizedBox(
          width: 100,
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        SizedBox(
          width: 50,
          child: Text(
            value ?? '',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
