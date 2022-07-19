import 'package:flutter/material.dart';
import 'package:newgps/src/ui/alert/temperature/components/config_form_view.dart';
import 'package:provider/provider.dart';

import '../logic/temperature_provider.dart';
import 'configs_list_view.dart';

class BaseFormListView extends StatelessWidget {
  const BaseFormListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // read provider
    final TemperatureBleProvider provider =
        context.read<TemperatureBleProvider>();
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.black,
            width: 1,
          ),
        ),
        child: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: provider.pageController,
          children: const [
            ConfigListView(),
            ConfigFormView(),
          ],
        ),
      ),
    );
  }
}
