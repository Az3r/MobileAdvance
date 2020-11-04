import 'package:flutter/material.dart';

class PageNavigator extends StatefulWidget {
  final List<NavItem> pages;
  final List<Widget> actions;

  const PageNavigator({
    Key key,
    List<NavItem> pages = const [],
    List<Widget> actions = const [],
  })  : assert(pages != null),
        assert(actions != null),
        this.pages = pages,
        this.actions = actions,
        super(key: key);

  @override
  _PageNavigatorState createState() => _PageNavigatorState();
}

class _PageNavigatorState extends State<PageNavigator> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pages[_selectedIndex].navbar.label),
        automaticallyImplyLeading: false,
        actions: widget.actions,
      ),
      body: widget.pages[_selectedIndex].content,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        items: [for (final item in widget.pages) item.navbar],
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.pink,
        onTap: (value) => onSwitchPage(value),
      ),
    );
  }

  void onSwitchPage(int value) {
    setState(() => _selectedIndex = value);
  }
}

class NavItem {
  /// widget used to display in BottomNavigationBar
  final BottomNavigationBarItem navbar;

  /// the page to display when navbar is selected
  final Widget content;

  const NavItem({
    @required this.navbar,
    @required this.content,
  });
}
