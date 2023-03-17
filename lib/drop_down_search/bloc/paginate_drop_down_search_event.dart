part of 'paginate_drop_down_search_bloc.dart';

@immutable
abstract class PaginateDropDownSearchEvent {}



class InputTextFieldClicked extends PaginateDropDownSearchEvent {}

class InputTextFieldUnfocused extends PaginateDropDownSearchEvent {}

class LoadMoreDevices extends PaginateDropDownSearchEvent {
  final int nextPageKey;
  final List<Device> lastItems;

  LoadMoreDevices({required this.nextPageKey, required this.lastItems});
}