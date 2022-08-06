import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:newgps/src/ui/alert/parking/models/slot_time.dart';

import '../../../utils/functions.dart';
import '../../../widgets/date_time_picker/time_range_widget.dart';

class ParkingAlertProvider extends ChangeNotifier {
  bool _isActive = false;

  bool get isActive => _isActive;

  List<int> selectedDays = [];

  List<SlotTimeModel> timeSlots = [];

  void setIsActive(bool isActive) {
    _isActive = isActive;
    notifyListeners();
  }

  List<int> showDays = [
    1,
    2,
    3,
    4,
    5,
    6,
    7,
  ];

  // check if day is already in timeSlots list
  bool isDayInTimeSlots(int day) {
    return timeSlots.any((e) => e.day == day);
  }

  // add day to selectedDays list
  void toggleDay(int day) {
    if (isDayInTimeSlots(day)) {
      Fluttertoast.showToast(
        msg: 'Jour déjà ajouté',
      );
      return;
    }
    List<int> newDays = List.from(selectedDays);
    if (newDays.contains(day)) {
      newDays.remove(day);
    } else {
      newDays.add(day);
    }
    selectedDays = newDays;
    notifyListeners();
  }

  // is day in selectedDays list
  bool isDaySelected(int day) {
    return selectedDays.contains(day);
  }

  // is at least one day selected
  bool isAtLeastOneDaySelected() {
    return selectedDays.isNotEmpty;
  }

  // add time slot to selectedDays list
  void toggleTimeSlot(BuildContext context) {
    if (!isAtLeastOneDaySelected()) return;
    _showTimeSlotRange(context);
    debugPrint("toggleTimeSlot");
  }

  DateTime selectedTimeFrom = DateTime.now();
  DateTime selectedTimeTo = DateTime.now();

  // check if time slot is valid
  bool isTimeSlotValid() {
    return selectedTimeFrom.isBefore(selectedTimeTo);
  }

  // remove show days from selectedDays list
  void _removeShowDays(List<int> days) {
    List<int> newShowDays = List.from(showDays);
    List<int> newSelectedDays = List.from(selectedDays);
    newShowDays.removeWhere((e) => days.contains(e));
    newSelectedDays.removeWhere((e) => days.contains(e));
    selectedDays = newSelectedDays;
    showDays = newShowDays;
  }

  // add to showDays list
  void _addShowDays(int day) {
    List<int> newShowDays = List.from(showDays);
    newShowDays.add(day);
    showDays = newShowDays;
  }

  // add time slot to timeSlots list
  void _addToTimeSlotList() {
    List<SlotTimeModel> newTimeSlots = List.from(timeSlots);
    DateTimeRange timeRange = DateTimeRange(
      start: selectedTimeFrom,
      end: selectedTimeTo,
    );
    for (var day in selectedDays) {
      newTimeSlots.add(SlotTimeModel(
        timeSlots: [timeRange],
        day: day,
      ));
    }
    timeSlots = newTimeSlots;
    _removeShowDays(selectedDays);
    notifyListeners();
  }

  // show time range picker
  void _showTimeSlotRange(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        child: TimeRangeWigdet(
          provider: this,
          onSaveAndClose: () {
            if (isTimeSlotValid()) {
              debugPrint("time saved");
              _addToTimeSlotList();
              return true;
            }
            Fluttertoast.showToast(
              msg: "Veuillez choisir une plage d'horaire valide",
              toastLength: Toast.LENGTH_LONG,
            );
            return false;
          },
          restaure: false,
        ),
      ),
    );
  }

  // get day name from day number
  String getDayName(int day) {
    switch (day) {
      case 1:
        return "Lundi";
      case 2:
        return "Mardi";
      case 3:
        return "Mercredi";
      case 4:
        return "Jeudi";
      case 5:
        return "Vendredi";
      case 6:
        return "Samedi";
      case 7:
        return "Dimanche";
      default:
        return "";
    }
  }

  // conver date time to HH:mm format
  String getHourMinute(DateTime dateTime) {
    return "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
  }

  // show delete  confirmation dialog
  void showDeleteConfirmationDialog( int day, int index) {
    showDeleteDialog(
         'Supprimer', 'Voulez-vous supprimer cette plage d\'horaire ?',
        () {
      _deleteTimeSlot(day,index);
      
      notifyListeners();
    });
  }

  // delete time slot from timeSlots list
  void _deleteTimeSlot(int day, int index) {
    List<SlotTimeModel> newTimeSlots = List.from(timeSlots);
    newTimeSlots.removeAt(index);
    timeSlots = newTimeSlots;
    _addShowDays(day);
    notifyListeners();
  }
}
