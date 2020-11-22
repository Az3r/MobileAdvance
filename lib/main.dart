import 'package:SingularSight/pages/splash.dart';
import 'package:SingularSight/utilities/constants.dart';
import 'package:flutter/material.dart';

import 'components/animations/page_routes.dart';
import 'pages/login.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Color(0xFF111111),
      ),
      themeMode: ThemeMode.dark,
      initialRoute: RouteNames.dashboard,
      routes: {
        '/': (context) => Splash(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == RouteNames.login) return loginRoute;
        throw ArgumentError.value(
          settings.name,
          'settings',
          'Unknown route named',
        );
      },
    );
  }

  Route<dynamic> get loginRoute {
    return LongerMaterialPageRoute(
      builder: (context) => Login(),
      duration: Duration(seconds: 1),
    );
  }
}
