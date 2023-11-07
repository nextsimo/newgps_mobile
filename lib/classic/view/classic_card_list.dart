import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newgps/widgets/loading_bar.dart';

import '../../src/models/device.dart';
import '../../widgets/device_card.dart';
import '../bloc/classic_bloc.dart';

class ClassicCardList extends StatefulWidget {
  final List<Device> devices;
  const ClassicCardList({super.key, required this.devices});

  @override
  State<ClassicCardList> createState() => _ClassicCardListState();
}

class _ClassicCardListState extends State<ClassicCardList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_listenScroll);
  }

  void _listenScroll() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      debugPrint('End of list');
      _currentPage++;
      context.read<ClassicBloc>().add(ClassicLoadDevices(
            page: _currentPage,
            previousDevices: widget.devices,
          ));
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_listenScroll);
    _scrollController.dispose();
    super.dispose();
  }

  int _currentPage = 1;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        ListView.separated(
          controller: _scrollController,
          separatorBuilder: (context, index) => const Divider(),
          padding: const EdgeInsets.only(
            top: 70,
            bottom: 160,
            left: 10,
            right: 10,
          ),
          itemCount: widget.devices.length,
          itemBuilder: (context, index) {
            final device = widget.devices[index];
            return DeviceCard(
              device: device,
              onTap: () {
                debugPrint('Selected device: ${device.description}');
                context.read<ClassicBloc>().add(
                      ClassicLoadDevice(
                        device: device,
                        dateTimeRange: DateTimeRange(
                            start: DateTime.now()
                                .subtract(const Duration(days: 1)),
                            end: DateTime.now()),
                      ),
                    );
              },
            );
          },
        ),
        BlocBuilder<ClassicBloc, ClassicState>(
          builder: (context, state) {
            if (state is ClassicLoadingMore) {
              return const Padding(
                padding: EdgeInsets.only(bottom: 140),
                child: MyLoadingBar(),
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ],
    );
  }
}
