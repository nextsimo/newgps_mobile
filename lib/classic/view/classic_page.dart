import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newgps/classic/bloc/classic_bloc.dart';
import 'package:newgps/classic/view/classic_card_list.dart';
import 'package:newgps/src/ui/navigation/top_app_bar.dart';

import '../../drop_down_search/view/paginate_drop_down_search_screen.dart';
import '../../widgets/loading_bar.dart';
import 'classic_device_info.dart';

class ClassicPage extends StatelessWidget {
  const ClassicPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Stack(
        children: [
          BlocBuilder<ClassicBloc, ClassicState>(
            buildWhen: (_, current) => current is! ClassicLoadingMore,
            builder: (context, state) {
              if (state is ClassicLoading) {
                return const Center(
                  child: MyLoadingBar(),
                );
              } else if (state is ClassicLoaded) {
                return ClassicCardList(devices: state.devices);
              } else if (state is ClassicLoadDeviceInfo) {
                return ClassicDeviceInfo(
                  initialDateRange: state.dateTimeRange,
                  deviceInfos: state.deviceInfos,
                  device: state.device,
                );
              } else if (state is ClassicError) {
                return Center(
                  child: Text(
                    'Classic Error: ${state.message}',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
          Column(
            children: [
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: PaginateDropDownSearchScreen(
                  onDeviceSelected: (device) {
                    if (device == null) {
                      context.read<ClassicBloc>().add(ClassicLoadDevices());
                      return;
                    }

                    debugPrint('Selected device: ${device.description}');
                    context.read<ClassicBloc>().add(
                          ClassicLoadDevice(
                            device: device,
                            dateTimeRange: DateTimeRange(
                              start: DateTime.now().subtract(
                                const Duration(days: 1),
                              ),
                              end: DateTime.now(),
                            ),
                          ),
                        );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
