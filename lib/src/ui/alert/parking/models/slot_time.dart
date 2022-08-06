import 'package:flutter/material.dart';

class SlotTimeModel {
  final List<DateTimeRange> timeSlots;
  final int day;

  const SlotTimeModel({
    this.timeSlots = const [],
    required this.day,
  });
}
