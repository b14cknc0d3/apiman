import 'package:flutter/material.dart';
import 'package:apiman/ui/screens/api/apiPageData.dart';

// ignore: must_be_immutable
class CustomTabView extends StatefulWidget {
  final int? itemCount;
  final IndexedWidgetBuilder? tabBuilder;
  final IndexedWidgetBuilder? pageBuilder;
  final Widget? stub;
  final ValueChanged<int>? onPositionChange;
  final ValueChanged<double>? onScroll;
  final int? initPosition;
  final List<ApiPagedata> tData;
  // ignore: non_constant_identifier_names
  final Function(List) callback2;
  CustomTabView({
    this.itemCount,
    this.tabBuilder,
    this.pageBuilder,
    this.stub,
    this.onPositionChange,
    this.onScroll,
    this.initPosition,
    required this.callback2,
    required this.tData,
  });

  @override
  _CustomTabsState createState() => _CustomTabsState();
}

class _CustomTabsState extends State<CustomTabView>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController controller;
  late int _currentCount;
  late int _currentPosition;

  @override
  void initState() {
    _currentPosition = widget.initPosition!;
    controller = TabController(
      length: widget.itemCount!,
      vsync: this,
      initialIndex: _currentPosition,
    );
    controller.addListener(onPositionChange);
    controller.animation!.addListener(onScroll);
    _currentCount = widget.itemCount!;
    super.initState();
  }

  @override
  void didUpdateWidget(CustomTabView oldWidget) {
    if (_currentCount != widget.itemCount) {
      controller.animation!.removeListener(onScroll);
      controller.removeListener(onPositionChange);
      controller.dispose();

      if (widget.initPosition != null) {
        _currentPosition = widget.initPosition!;
      }

      if (_currentPosition > widget.itemCount! - 1) {
        _currentPosition = widget.itemCount! - 1;
        _currentPosition = _currentPosition < 0 ? 0 : _currentPosition;
        if (widget.onPositionChange is ValueChanged<int>) {
          WidgetsBinding.instance!.addPostFrameCallback((_) {
            if (mounted) {
              widget.onPositionChange!(_currentPosition);
            }
          });
        }
      }

      _currentCount = widget.itemCount!;
      setState(() {
        controller = TabController(
          length: widget.itemCount!,
          vsync: this,
          initialIndex: _currentPosition,
        );
        controller.addListener(onPositionChange);
        controller.animation!.addListener(onScroll);
      });
    } else if (widget.initPosition != null) {
      controller.animateTo(widget.initPosition!);
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    controller.animation!.removeListener(onScroll);
    controller.removeListener(onPositionChange);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (widget.itemCount! < 1) return widget.stub ?? Container();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        alignment: Alignment.topLeft,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(
                            4.0,
                          ),
                        ),
                        child: TabBar(
                          onTap: (index) {
                            print("tapped $index");
                          },
                          isScrollable: true,
                          controller: controller,
                          labelColor: Colors.white,
                          unselectedLabelColor:
                              Theme.of(context).primaryColorLight,
                          indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              4.0,
                            ),
                            color: Colors.green,
                          ),
                          // indicator: BoxDecoration(
                          //   border: Border(
                          //     bottom: BorderSide(
                          //       color: Theme.of(context).primaryColor,
                          //       width: 2,
                          //     ),
                          //   ),
                          // ),
                          tabs: List.generate(
                            widget.itemCount!,
                            (index) => widget.tabBuilder!(context, index),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: IconButton(
                    icon: Icon(
                      Icons.add,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: () {
                      widget.callback2(widget.tData);
                    }),
              )
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: controller,
              children: widget.tData,
              // List.generate(
              //   widget.itemCount!,
              //   (index) => widget.pageBuilder!(context, index),
              // ),
            ),
          ),
        ],
      ),
    );
  }

  onPositionChange() {
    if (!controller.indexIsChanging) {
      _currentPosition = controller.index;
      if (widget.onPositionChange is ValueChanged<int>) {
        widget.onPositionChange!(_currentPosition);
      }
    }
  }

  onScroll() {
    if (widget.onScroll is ValueChanged<double>) {
      widget.onScroll!(controller.animation!.value);
    }
  }

  @override
  bool get wantKeepAlive => true;
}
