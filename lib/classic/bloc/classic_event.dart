part of 'classic_bloc.dart';

@immutable
abstract class ClassicEvent {}

class ClassicLoadDevice extends ClassicEvent {
  final Device device;

  ClassicLoadDevice(this.device);
}

class ClassicLoadDevices extends ClassicEvent {
  final int page;
  final List<Device> previousDevices;

  ClassicLoadDevices({this.page = 1,  this.previousDevices = const []});
}
