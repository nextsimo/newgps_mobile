import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newgps/repository/devices_repository.dart';

import '../../src/models/device.dart';

part 'paginate_drop_down_search_event.dart';
part 'paginate_drop_down_search_state.dart';

class PaginateDropDownSearchBloc
    extends Bloc<PaginateDropDownSearchEvent, PaginateDropDownSearchState> {
  PaginateDropDownSearchBloc() : super(PaginateDropDownSearchInitial()) {
    on<PaginateDropDownSearchEvent>((event, emit) async {
      // unfocus state
      if (event is InputTextFieldUnfocused) {
        emit(PaginateDropDownSearchDismissed());
      }

      if (event is InputTextFieldClicked) {
        emit(PaginateDropDownSearchLoading());
        try {
          final DevicesRepository devicesRepository = DevicesRepository();
          final res =
              await devicesRepository.fetchDevices(numberOfDevice: 60, page: 1);
          final List<Device> devices = res['devices'];

          emit(PaginateDropDownSearchLoaded(
              items: devices, nextPageKey: res['current_page'] + 1));
        } catch (e) {
          final PaginateDropDownSearchError paginateDropDownSearchError =
              PaginateDropDownSearchError(message: e.toString());
          emit(paginateDropDownSearchError);
        }
      }
      if (event is LoadMoreDevices) {
        emit(MoreDevicesLoading());
        try {
          final DevicesRepository devicesRepository = DevicesRepository();
          final res =
              await devicesRepository.fetchDevices(numberOfDevice: 20, page: event.nextPageKey);
          final List<Device> devices = res['devices'];
          emit(
            PaginateDropDownSearchLoaded(
              items: event.lastItems + devices,
              nextPageKey: res['current_page'] + 1,
            ),
          );
          // check reach the end of the list
          if (res['current_page'] == res['last_page']) {
            emit(DeivecesReachedMax());
          }
        } catch (e) {
          final PaginateDropDownSearchError paginateDropDownSearchError =
              PaginateDropDownSearchError(message: e.toString());
          emit(paginateDropDownSearchError);
        }
      }
    });
  }
}
