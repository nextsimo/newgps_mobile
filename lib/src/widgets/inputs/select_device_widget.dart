import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:newgps/src/services/newgps_service.dart';

import '../../models/device.dart';

class SelectedDeviceWidget extends StatelessWidget {
  final Function(Device) onSelected;

  const SelectedDeviceWidget({Key? key, required this.onSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.green,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: DropdownSearch<Device>(
        items: deviceProvider.devices,
        dropdownDecoratorProps: const DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
            hintText: "Selectioné une appareil",
            contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          ),
        ),
        itemAsString: (item) => item.description,
        onChanged: (Device? d) {
          if (d != null) {
            onSelected(d);
          }
        },
        popupProps: PopupProps.menu(
          showSearchBox: true,
          emptyBuilder: (context, ___) =>
              const Center(child: Text('Aucun appareil trouvé')),
          itemBuilder: (context, item, isSelected) => ListTile(
            title: Text(
              item.description,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            selected: isSelected,
          ),
        ),
      ),
    );
  }
}
