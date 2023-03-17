import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newgps/repository/devices_repository.dart';

import '../../src/models/device.dart';

part 'classic_event.dart';
part 'classic_state.dart';

class ClassicBloc extends Bloc<ClassicEvent, ClassicState> {
  final DevicesRepository devicesRepository = DevicesRepository();
  ClassicBloc() : super(ClassicInitial()) {
    on<ClassicEvent>((event, emit) async {
      if (event is ClassicLoadDevice) {
        debugPrint('ClassicLoadDevice: ${event.device.description}');
        emit(ClassicLoading());
        await Future.delayed(const Duration(seconds: 2));
        emit(ClassicLoadDeviceInfo(event.device));
      } else if (event is ClassicLoadDevices) {
        emit(event.page == 1 ? ClassicLoading() : ClassicLoadingMore());
        final res = await devicesRepository.fetchDevices(
            numberOfDevice: 40, page: event.page);
        final List<Device> devices = res['devices'];
        emit(ClassicLoaded(event.page == 1
            ? devices
            : [...event.previousDevices, ...devices]));
      }
    });
  }
}
