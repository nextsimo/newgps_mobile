import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import '../../services/newgps_service.dart';

import '../../models/device.dart';

class SelectedDeviceWidget extends StatelessWidget {
  final Function(List<String>) onSelected;
  final List<String> selectedDevices;

  SelectedDeviceWidget(
      {Key? key, required this.onSelected, required this.selectedDevices})
      : super(key: key);

  final _multiKey = GlobalKey<DropdownSearchState<String>>();

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
        key: _multiKey,
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
          title: _BuildAllWidget(
            isAllSelected:
                selectedDevices.length == deviceProvider.devices.length,
            onSelectedAll: (bool isSelected) {
              if (isSelected) {
                _multiKey.currentState?.popupSelectAllItems();
              } else {
                _multiKey.currentState?.popupDeselectAllItems();
              }
            },
          ),
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
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
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

class _BuildAllWidget extends StatefulWidget {
  final bool isAllSelected;
  final void Function(bool) onSelectedAll;
  const _BuildAllWidget(
      {Key? key, required this.onSelectedAll, this.isAllSelected = false})
      : super(key: key);

  @override
  State<_BuildAllWidget> createState() => _BuildAllWidgetState();
}

class _BuildAllWidgetState extends State<_BuildAllWidget> {
  bool _isSelected = false;

  @override
  void initState() {
    super.initState();
    _isSelected = widget.isAllSelected;
  }

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: _isSelected,
      onChanged: (_) {
        setState(() => _isSelected = !_isSelected);

        widget.onSelectedAll(_isSelected);
      },
      contentPadding: const EdgeInsets.fromLTRB(13, 0, 5, 0),
      title: const Text(
        'Tous les appareils',
        style: TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
