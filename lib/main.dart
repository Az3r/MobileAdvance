import 'dart:io';

import 'package:SingularSight/pages/home.dart';
import 'package:SingularSight/services/locator_service.dart';
import 'package:SingularSight/utilities/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'components/animations/page_routes.dart';
import 'pages/dashboard.dart';
import 'pages/login.dart';
import 'pages/splash.dart';

void main() async {
  await initialize(true);
  runApp(MainApp());
}

Future<void> initialize([debug = false]) async {
  // initializw firebase app
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // initialize services
  await LocatorService().register();

  // setup cloud firestore
  FirebaseFirestore.instance.settings = Settings(
    host: localhost(8080),
    sslEnabled: false,
    persistenceEnabled: true,
  );

  // setup clould functions
  FirebaseFunctions.instance.useFunctionsEmulator(origin: localhost(5001));
}

String localhost(int port) =>
    Platform.isAndroid ? '10.0.2.2:$port' : 'localhost:$port';

class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData(
        typography: Typography.material2018(),
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Color(0xFF111111),
        textTheme: TextTheme(),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: Color(0xFF232323),
          contentTextStyle: TextStyle(
            color: Colors.white70,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      themeMode: ThemeMode.dark,
      initialRoute: '/',
      routes: {
        '/': (context) => const Splash(),
        RouteNames.dashboard: (context) => const Dashboard(),
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
