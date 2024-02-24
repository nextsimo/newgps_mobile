import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../widgets/buttons/main_button.dart';
import '../logic/temperature_provider.dart';

class AddButton extends StatelessWidget {
  const AddButton({super.key});

  @override
  Widget build(BuildContext context) {

    final TemperatureBleProvider provider = context.read<TemperatureBleProvider>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: MainButton(
        onPressed:provider.navigateToAddConfigView,
        label: 'Ajouter une configration',
         
      ),
    );
  }
}
