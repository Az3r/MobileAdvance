import 'package:flutter/material.dart';

class DynamicSliverList<T> extends StatefulWidget {
  final Widget Function(BuildContext context, int index, T data) itemBuilder;
  final Future<List<T>> Function() getNext;
  final List<T> initialItems;
  DynamicSliverList({
    Key key,
    @required this.itemBuilder,
    @required this.getNext,
    this.initialItems,
  })  : assert(itemBuilder != null),
        assert(getNext != null),
        super(key: key);

  @override
  DynamicSliverListState<T> createState() => DynamicSliverListState();
}

class DynamicSliverListState<T> extends State<DynamicSliverList<T>> {
  List<T> _items = [];
  @override
  void initState() {
    super.initState();
    _items.addAll(widget.initialItems ?? []);
  }

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => widget.itemBuilder(context, index, _items[index]),
        childCount: _items.length,
      ),
    );
  }

  void displayNext() async {
    final more = await widget.getNext();
    _items.addAll(more ?? []);
    setState(() {});
  }
}

class DynamicList<T> extends StatefulWidget {
  final Widget Function(BuildContext context, int index, T data) itemBuilder;
  final Future<List<T>> Function() getNext;
  final List<T> initialItems;
  DynamicList({
    Key key,
    @required this.itemBuilder,
    @required this.getNext,
    this.initialItems,
  })  : assert(itemBuilder != null),
        assert(getNext != null),
        super(key: key);

  @override
  DynamicListState<T> createState() => DynamicListState();
}

class DynamicListState<T> extends State<DynamicList<T>> {
  List<T> _items = [];
  @override
  void initState() {
    super.initState();
    _items.addAll(widget.initialItems ?? []);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _items.length,
      itemBuilder: (context, index) =>
          widget.itemBuilder(context, index, _items[index]),
    );
  }

  void displayNext() async {
    final more = await widget.getNext();
    _items.addAll(more ?? []);
    setState(() {});
  }

  void clear() {
    setState(() => _items.clear());
  }
}
