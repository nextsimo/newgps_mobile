import 'dart:convert';

import 'package:flutter/material.dart';

class SlotTimeModel {
  List<DateTimeRange> timeSlots;
  final int day;

  SlotTimeModel({
    this.timeSlots = const [],
    required this.day,
  });

  factory SlotTimeModel.fromJson(Map<String, dynamic> json) {
    return SlotTimeModel(
      timeSlots: convertStringToTimeSlots(json['timeSlots']),
      day: json['day'],
    );
  }

  // to json function
  Map<String, dynamic> toJson() => {
    'timeSlots': json.encode(convertTimeSlotsToString()),
    'day': day,
  };

  // convert dateTimeRange list to this format: [[date_time_start, date_time_end], [date_time_start, date_time_end], ...]
  List<List<String>> convertTimeSlotsToString() {
    List<List<String>> timeSlotsString = [];
    for (DateTimeRange timeSlot in timeSlots) {
      timeSlotsString.add([
        timeSlot.start.toString(),
        timeSlot.end.toString(),
      ]);
    }
    return timeSlotsString;
  }

  // convert string to dateTimeRange list
  static List<DateTimeRange> convertStringToTimeSlots(List<List<String>> timeSlotsString) {
    List<DateTimeRange> timeSlots = [];
    for (List<String> timeSlot in timeSlotsString) {
      timeSlots.add(DateTimeRange(
        start: DateTime.parse(timeSlot[0]),
        end: DateTime.parse(timeSlot[1]),
      ));
    }
    return timeSlots;
  }
}


// convert list of  SlotTimeModel model to string
String convertSlotTimeModelToString(List<SlotTimeModel> slotTimeModels) {
  List<Map<String, dynamic>> slotTimeModelsMap = [];
  for (SlotTimeModel slotTimeModel in slotTimeModels) {
    slotTimeModelsMap.add(slotTimeModel.toJson());
  }
  return json.encode(slotTimeModelsMap);
}

// get list of SlotTimeModel model from string
List<SlotTimeModel> convertStringToSlotTimeModel(String slotTimeModelsString) {
  List<dynamic> slotTimeModelsMap = json.decode(slotTimeModelsString);
  List<SlotTimeModel> slotTimeModels = [];
  for (Map<String, dynamic> slotTimeModelMap in slotTimeModelsMap) {
    slotTimeModels.add(SlotTimeModel.fromJson(slotTimeModelMap));
  }
  return slotTimeModels;
}

