import 'package:flutter/material.dart';

class SlotTimeModel {
   List<DateTimeRange> timeSlots;
  final int day;

   SlotTimeModel({
    this.timeSlots = const [],
    required this.day,
  });
}
