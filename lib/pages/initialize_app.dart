import 'dart:io';

import 'package:SingularSight/services/locator_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'login.dart';
import 'splash.dart';

class InitializeApp extends StatelessWidget {
  final Widget loading;
  final Widget completed;
  final bool emulator;

  const InitializeApp({
    Key key,
    this.emulator = false,
    this.loading = const Splash(),
    this.completed = const Login(),
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.hasError)
            return ErrorWidget.withDetails(
              error: snapshot.error,
              message: 'Unable to initialize Firebase app',
            );
          final widget = snapshot.connectionState == ConnectionState.done
              ? completed
              : loading;
          return AnimatedSwitcher(
            switchInCurve: Curves.easeOut,
            switchOutCurve: Threshold(0),
            duration: const Duration(milliseconds: 600),
            child: widget,
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: Tween(begin: 0.0, end: 1.0).animate(animation),
                child: SlideTransition(
                  position: Tween(begin: Offset(0, 0.5), end: Offset.zero)
                      .animate(animation),
                  child: child,
                ),
              );
            },
          );
        },
        future: _initialize());
  }

  Future<void> _initialize() async {
    // initialize firebase app.
    await Firebase.initializeApp();
    if (emulator) {
      FirebaseFirestore.instance.settings = Settings(
        host: localhost(8080),
        sslEnabled: false,
        persistenceEnabled: true,
      );
      FirebaseFunctions.instance.useFunctionsEmulator(origin: localhost(5001));
    }

    // initialize singleton services
    await LocatorService.instance.register();
  }

  String localhost(int port) =>
      Platform.isAndroid ? '10.0.2.2:$port' : 'localhost:$port';
}
