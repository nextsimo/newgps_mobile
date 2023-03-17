import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/classic_bloc.dart';
import 'classic_page.dart';

class ClassicScreen extends StatelessWidget {
  const ClassicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ClassicBloc()..add(ClassicLoadDevices()),
      child: const ClassicPage(),
    );
  }
}
