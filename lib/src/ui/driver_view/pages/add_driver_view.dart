import 'package:flutter/material.dart';
import '../../../utils/styles.dart';
import 'package:provider/provider.dart';

import '../providers/add_driver_provider.dart';
import '../widgets/my_input.dart';
import '../widgets/my_main_button.dart';

class AddDriverView extends StatelessWidget {
  const AddDriverView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // read the provider

    return ChangeNotifierProvider<AddDriverProvider>(
        create: (_) => AddDriverProvider(),
        builder: (context, snapshot) {
          return Column(
            children: const [
              _BuildHeader(),
              _AddDriverForm(),
            ],
          );
        });
  }
}

class _AddDriverForm extends StatelessWidget {
  const _AddDriverForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.read<AddDriverProvider>();

    return Selector<AddDriverProvider, bool>(
      selector: (context, provider) => provider.showAddDriver,
      builder: (context, showAddDriver, _) {
        return AnimatedContainer(
          height: provider.height,
          duration: const Duration(milliseconds: 230),
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: Colors.grey),
          curve: Curves.ease,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            children: [
              const SizedBox(height: 20),
              Row(
                children: const [
                  NewgInput(
                    placeholder: 'Nom',
                  ),
                  SizedBox(width: 10),
                  NewgInput(
                    placeholder: 'Prénom',
                  ),
                ],
              ),
              const SizedBox(height: 12),
              NewgInput(
                placeholder: 'Numéro de téléphone',
                prefix: InputPrefix.phonePrefix(),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 12),
              NewgInput(
                placeholder: 'IButton ID',
                prefix: InputPrefix.idPrefix(),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              MyMainButton(
                label: 'Ajouter',
                onTap: () {},
              ),
            ],
          ),
        );
      },
    );
  }
}

class _BuildHeader extends StatelessWidget {
  const _BuildHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.read<AddDriverProvider>();

    return ListTile(
      title: const Text(
        'Ajouter un conducteur',
      ),
      trailing: _buildAddRemove(),
      onTap: provider.toggleAddDriver,
    );
  }

  Selector<AddDriverProvider, bool> _buildAddRemove() {
    return Selector<AddDriverProvider, bool>(
      selector: (_, provider) => provider.showAddDriver,
      builder: (_, showAddDriver, __) {
        if (showAddDriver) {
          return const Icon(Icons.remove_circle, color: AppConsts.mainColor);
        } else {
          return const Icon(Icons.add_circle, color: AppConsts.mainColor);
        }
      },
    );
  }
}
