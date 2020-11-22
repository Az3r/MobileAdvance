import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'login.dart';
import 'splash.dart';

class InitializeApp extends StatelessWidget {
  final Widget loading;
  final Widget completed;

  const InitializeApp({
    Key key,
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
        final widget = snapshot.hasData ? completed : loading;
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
      future:
          Future.delayed(const Duration(seconds: 3), Firebase.initializeApp),
    );
  }
}
