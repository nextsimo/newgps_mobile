part of 'classic_bloc.dart';

@immutable
abstract class ClassicState {}

class ClassicInitial extends ClassicState {}

class ClassicLoading extends ClassicState {
}

class ClassicLoaded extends ClassicState {
  final List<Device> devices;

  ClassicLoaded(this.devices);
}

class ClassicLoadingMore extends ClassicState {
}

class ClassicError extends ClassicState {
  final String message;

  ClassicError(this.message);
}


class ClassicLoadDeviceInfo extends ClassicState {
  final Device device;

  ClassicLoadDeviceInfo(this.device);
}