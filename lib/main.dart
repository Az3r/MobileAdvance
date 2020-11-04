import 'package:flutter/material.dart';
import 'components/navigation.dart';
import 'pages/browse_page.dart';
import 'pages/home_page.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PageNavigator(pages: pages),
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}

final pages = const [
  NavItem(
    navbar: BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Home',
    ),
    content: HomePage(),
  ),
  NavItem(
    navbar: BottomNavigationBarItem(
      icon: Icon(Icons.apps),
      label: 'Browse',
    ),
    content: BrowsePage(),
  )
];
