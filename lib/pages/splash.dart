import 'package:SingularSight/utilities/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    final auth = FirebaseAuth.instance;
    if (ModalRoute.of(context).isCurrent) {
      if (auth.currentUser != null) {
        return Navigator.of(context).pushReplacementNamed(RouteNames.dashboard);
      }
      return Navigator.of(context).pushReplacementNamed(RouteNames.login);
    }
  }
}
