import 'package:SingularSight/utilities/constants.dart';
import 'package:SingularSight/utilities/globals.dart';
import 'package:flutter/material.dart';

import '../components/loading.dart';

class Splash extends StatelessWidget {
  const Splash();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: load(context),
      builder: (context, snapshot) {
        return Loading();
      },
    );
  }

  Future<void> load(BuildContext context) async {
    await Future.delayed(Duration(seconds: 3));
    if (ModalRoute.of(context).isCurrent)
      return Navigator.of(context).pushReplacementNamed(RouteNames.login);
  }
}
