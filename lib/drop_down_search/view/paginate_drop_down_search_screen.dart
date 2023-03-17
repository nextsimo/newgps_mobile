import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../src/models/device.dart';
import '../bloc/paginate_drop_down_search_bloc.dart';
import 'paginate_drop_down_search_page.dart';

class PaginateDropDownSearchScreen extends StatelessWidget {
  final void Function(Device?) onDeviceSelected;

  const PaginateDropDownSearchScreen(
      {super.key, required this.onDeviceSelected});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PaginateDropDownSearchBloc(),
      child: PaginateDropDownSearchPage(
        onDeviceSelected: onDeviceSelected,
      ),
    );
  }
}
