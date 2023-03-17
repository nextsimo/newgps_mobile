import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newgps/src/models/device.dart';
import 'package:newgps/src/utils/styles.dart';
import '../../widgets/loading_bar.dart';
import '../bloc/paginate_drop_down_search_bloc.dart';

class PaginateDropDownSearchPage extends StatefulWidget {
  final void Function(Device?) onDeviceSelected;
  const PaginateDropDownSearchPage({super.key, required this.onDeviceSelected});

  @override
  State<PaginateDropDownSearchPage> createState() =>
      _PaginateDropDownSearchPageState();
}

class _PaginateDropDownSearchPageState
    extends State<PaginateDropDownSearchPage> {
  final TextEditingController _controller = TextEditingController();

  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_focusNodeListener);
  }

  void _focusNodeListener() {
    if (_focusNode.hasFocus) {
      BlocProvider.of<PaginateDropDownSearchBloc>(context)
          .add(InputTextFieldClicked());
    } else {
      BlocProvider.of<PaginateDropDownSearchBloc>(context)
          .add(InputTextFieldUnfocused());
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_focusNodeListener);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var boxDecoration = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.grey.shade300),
    );
    return Column(
      children: [
        CupertinoTextField(
          focusNode: _focusNode,
          controller: _controller,
          decoration: boxDecoration,
        ),
        const SizedBox(height: 10),
        BlocBuilder<PaginateDropDownSearchBloc, PaginateDropDownSearchState>(
          // build only when the previous state is PaginateDropDownSearchLoading and the current state is PaginateDropDownSearchLoaded
          // or the curent state is PaginateDropDownSearchError InputTextFieldUnfocused
          buildWhen: (previous, current) {
            return (previous is PaginateDropDownSearchLoading &&
                    current is PaginateDropDownSearchLoaded) ||
                current is PaginateDropDownSearchDismissed ||
                current is PaginateDropDownSearchLoading;
          },

          builder: (context, state) {
            if (state is PaginateDropDownSearchLoading) {
              return const _LoadingDropDown();
            }
            if (state is PaginateDropDownSearchLoaded) {
              return _DropDownSearch(
                state: state,
                onDeviceSelected: (d) {
                  widget.onDeviceSelected(d);
                  _controller.text = d?.description ?? '';
                  FocusScope.of(context).unfocus();
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}

class _DropDownSearch extends StatefulWidget {
  final PaginateDropDownSearchLoaded state;
  final void Function(Device?) onDeviceSelected;

  const _DropDownSearch({required this.state, required this.onDeviceSelected});

  @override
  State<_DropDownSearch> createState() => _DropDownSearchState();
}

class _DropDownSearchState extends State<_DropDownSearch> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    currentState = widget.state;
    _scrollController.addListener(_scrollListener);
  }

  late PaginateDropDownSearchLoaded currentState;

  void _scrollListener() {
/*     if (context.read<PaginateDropDownSearchBloc>().state
        is DeivecesReachedMax) {
      _scrollController.removeListener(_scrollListener);
      return;
    } */
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        (context.read<PaginateDropDownSearchBloc>().state
            is! MoreDevicesLoading) &&
        (context.read<PaginateDropDownSearchBloc>().state
            is! DeivecesReachedMax)) {
      BlocProvider.of<PaginateDropDownSearchBloc>(context).add(LoadMoreDevices(
          nextPageKey: currentState.nextPageKey,
          lastItems: currentState.items));
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var boxDecoration = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.grey.shade300),
    );
    return Container(
      decoration: boxDecoration,
      constraints: BoxConstraints(
        maxHeight: 200.h,
      ),
      child: Column(
        children: [
          Expanded(
            child: BlocConsumer<PaginateDropDownSearchBloc,
                PaginateDropDownSearchState>(
              listener: (context, state) {
                if (state is PaginateDropDownSearchLoaded) {
                  currentState = state;
                }
              },
              buildWhen: (previous, current) {
                return current is PaginateDropDownSearchLoaded;
              },
              listenWhen: (previous, current) {
                return current is PaginateDropDownSearchLoaded;
              },
              builder: (context, state) {
                if (state is PaginateDropDownSearchLoaded) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          widget.onDeviceSelected(null);
                          FocusScope.of(context).unfocus();
                        },
                        child: Container(
                          width: double.infinity,
                          height: 45,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: const Center(
                            child: Text(
                              'Tous les véhicules',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(0),
                          shrinkWrap: true,
                          itemCount: state.items.length,
                          controller: _scrollController,
                          itemBuilder: (context, index) {
                            final device = state.items[index];
                            return ListTile(
                              onTap: () => widget.onDeviceSelected(device),
                              title: Text(device.description),
                              trailing: Container(
                                width: 80,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(device.colorR,
                                      device.colorG, device.colorB, 1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    device.statut,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          BlocBuilder<PaginateDropDownSearchBloc, PaginateDropDownSearchState>(
            // build only when state is MoreDevicesLoading or if the previous state was MoreDevicesLoading and the current state is DeivecesReachedMax or if the previous state was DeivecesReachedMax and the current state is MoreDevicesLoaded
            buildWhen: (previous, current) {
              if (current is MoreDevicesLoading) {
                return true;
              }
              if (previous is MoreDevicesLoading &&
                  current is DeivecesReachedMax) {
                return true;
              }
              if (previous is DeivecesReachedMax ||
                  current is PaginateDropDownSearchLoaded) {
                return true;
              }
              return false;
            },
            builder: (context, state) {
              if (state is MoreDevicesLoading) {
                return const SizedBox(
                  child: Center(
                    child: LinearProgressIndicator(
                      color: AppConsts.mainColor,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}

class _LoadingDropDown extends StatelessWidget {
  const _LoadingDropDown();

  @override
  Widget build(BuildContext context) {
    var boxDecoration = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.grey.shade300),
    );
    return Animate(
      effects: const [
        SlideEffect(
          duration: Duration(milliseconds: 200),
          // slide from top to bottom
          curve: Curves.ease,
          begin: Offset(0, -0.5),
          end: Offset(0, 0),
        ),
        FadeEffect(),
      ],
      child: Container(
        decoration: boxDecoration,
        height: 200.h,
        child: const Center(
          child: MyLoadingBar(),
        ),
      ),
    );
  }
}
