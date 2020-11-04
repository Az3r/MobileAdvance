import 'package:flutter/material.dart';

/// item to be passed in [PopupMenuButton]'s children  when select Setting action in [AppBar]
class MenuPage {
  /// the label of [PopupMenuItem] so that user can be able to select
  final String label;

  /// the widget to navigate to when being selected, should have [Scaffold] as
  /// root
  final Widget page;

  MenuPage({
    @required this.label,
    @required this.page,
  })  : assert(label != null),
        assert(page != null);
}
