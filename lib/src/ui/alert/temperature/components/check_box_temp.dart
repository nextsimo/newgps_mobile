import 'package:flutter/material.dart';
import '../../../../utils/styles.dart';
import 'package:provider/provider.dart';

import '../logic/temperature_provider.dart';

class CheckBoxTemp extends StatelessWidget {
  const CheckBoxTemp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // read provider
    final TemperatureBleProvider provider =
        context.read<TemperatureBleProvider>();
    final int _selectedIndex = context
        .select<TemperatureBleProvider, int>(((value) => value.selectedIndex));

    return Row(
      children: [
        _MyCheckBox(
          label: "Dans l'intervalle",
          index: 0,
          selected: _selectedIndex == 0,
          onTap: provider.setSelectedIndex,
        ),
        const SizedBox(width: 10),
        _MyCheckBox(
          label: "Hors intervalle",
          index: 1,
          selected: _selectedIndex == 1,
          onTap: provider.setSelectedIndex,
        ),
      ],
    );
  }
}

class _MyCheckBox extends StatelessWidget {
  final void Function(int index) onTap;
  final String label;
  final int index;
  final bool selected;
  const _MyCheckBox(
      {Key? key,
      required this.label,
      required this.index,
      required this.selected,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        child: Container(
          decoration: BoxDecoration(
            // add raedius to the container
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            border: Border.all(
              color: selected ? AppConsts.mainColor : Colors.grey,
              width: 2,
            ),
            // add shadow
            boxShadow: [
              if (!selected)
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 5,
                  offset: const Offset(0, 5),
                ),
            ],
          ),
          height: 57,
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 17,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
