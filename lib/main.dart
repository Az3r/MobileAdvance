import 'dart:io';

import 'package:SingularSight/models/playlist_model.dart';
import 'package:SingularSight/services/locator_service.dart';
import 'package:SingularSight/utilities/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'components/routings.dart';
import 'pages/dashboard.dart';
import 'pages/network_error.dart';
import 'pages/login.dart';
import 'pages/register.dart';
import 'pages/settings.dart';
import 'pages/splash.dart';
import 'pages/bookmark.dart';
import 'pages/history.dart';
import 'pages/favorite.dart';

void main() async {
  await _initialize(false);
  runApp(MainApp());
}

Future<void> _initialize([debug = false]) async {
  // initializw firebase app
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // initialize services
  await LocatorService().register();

  if (debug) {
    FirebaseFirestore.instance.settings = Settings(
      host: localhost(8080),
      sslEnabled: false,
      persistenceEnabled: true,
    );
    FirebaseFunctions.instance.useFunctionsEmulator(origin: localhost(5001));
  }
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
        RouteNames.register: (context) => const Register(),
        RouteNames.settings: (context) => const UserSettings(),
        RouteNames.bookmarks: (context) => const Bookmarks(),
        RouteNames.favorites: (context) => const Favorites(),
        RouteNames.history: (context) => const History(),
      },
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case RouteNames.login:
            return Routings.login();
          case RouteNames.channelDetails:
            return Routings.channelDetails(settings.arguments);
          case RouteNames.watch:
            final map = settings.arguments as Map<String, dynamic>;
            final playlist = map['playlist'] as PlaylistModel;
            final index = map['initialVideoIndex'] as int;
            return Routings.watch(playlist, index ?? 0);
        }
        throw ArgumentError.value(
          settings.name,
          'settings',
          'Unknown route named',
        );
      },
    );
  }
}
