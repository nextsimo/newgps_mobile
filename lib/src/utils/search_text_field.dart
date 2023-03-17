import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  final List<SearchFieldModel> fields;
  const SearchField({super.key, this.fields = const []});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class SearchFieldModel {
  final String label;
  final String id;

  const SearchFieldModel({required this.label, required this.id});
}
