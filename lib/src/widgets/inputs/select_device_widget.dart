import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:newgps/src/services/newgps_service.dart';

import '../../models/device.dart';

class SelectedDeviceWidget extends StatelessWidget {
  final Function(List<String>) onSelected;
  final List<String> selectedDevices;

  const SelectedDeviceWidget({Key? key, required this.onSelected, required this.selectedDevices})
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
      child: DropdownSearch<String>.multiSelection(
        items: List<String>.from(
          deviceProvider.devices.map((Device device) => device.description),
        ),
        dropdownDecoratorProps: const DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
            hintText: "",
            contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          ),
        ),
        onChanged: (List<String> d) {
          onSelected(d);
        },
        selectedItems: selectedDevices,
        popupProps: PopupPropsMultiSelection.modalBottomSheet(
          showSelectedItems: false,
          showSearchBox: true,
          emptyBuilder: (context, ___) =>
              const Center(child: Text('Aucun appareil trouvé')),
          itemBuilder: (context, item, isSelected) => Row(
            children: [
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  item,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
