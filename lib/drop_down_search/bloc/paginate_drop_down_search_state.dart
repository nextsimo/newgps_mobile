part of 'paginate_drop_down_search_bloc.dart';

@immutable
abstract class PaginateDropDownSearchState {}

class PaginateDropDownSearchInitial extends PaginateDropDownSearchState {}

class PaginateDropDownSearchLoading extends PaginateDropDownSearchState {}

class PaginateDropDownSearchLoaded extends PaginateDropDownSearchState {
  final List<Device> items;
  final int nextPageKey;

  PaginateDropDownSearchLoaded({
    required this.items,
    required this.nextPageKey,
  });

  PaginateDropDownSearchLoaded copyWith({
    List<Device>? items,
    int? nextPageKey,
  }) {
    return PaginateDropDownSearchLoaded(
      items: items ?? this.items,
      nextPageKey: nextPageKey ?? this.nextPageKey,
    );
  }

  @override
  String toString() =>
      'PaginateDropDownSearchLoaded { items: ${items.length}, hasReachedMax: $nextPageKey }';
}

class DeivecesReachedMax extends PaginateDropDownSearchState {}

class MoreDevicesLoading extends PaginateDropDownSearchState {}


class PaginateDropDownSearchError extends PaginateDropDownSearchState {
  final String message;

  PaginateDropDownSearchError({required this.message});

  @override
  String toString() => 'PaginateDropDownSearchError { message: $message }';
}

class PaginateDropDownSearchEmpty extends PaginateDropDownSearchState {}

class PaginateDropDownSearchHasFocus extends PaginateDropDownSearchState {}

class PaginateDropDownSearchDismissed extends PaginateDropDownSearchState {}