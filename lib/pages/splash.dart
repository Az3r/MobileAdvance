import 'package:SingularSight/utilities/constants.dart' show RouteNames;
import 'package:flutter/material.dart';

import '../components/widgets/loading.dart';
import '../components/widgets/logo.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 5)).whenComplete(() {
      Navigator.pushNamedAndRemoveUntil(
        context,
        RouteNames.login,
        (route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Loading(),
      ),
    );
  }
}
