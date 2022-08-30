import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/inputs/main_input.dart';
import 'login_provider.dart';

class SousUserCheck extends StatelessWidget {
  const SousUserCheck({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LoginProvider provider = context.read<LoginProvider>();
    bool val =
        context.select((LoginProvider provider) => provider.isUnderCompte);
    return Column(
      children: [
        CheckboxListTile(
          title: const Text('Sous utilisateur'),
          value: val,
          onChanged: provider.setUnderCompte,
        ),
        if (val)
          MainInput(
            icon: Icons.person,
            hint: 'Sous utilisateur',
            controller: provider.underCompteController,
            onEditeComplete: () => FocusScope.of(context).nextFocus(),
          ),
      ],
    );
  }
}
