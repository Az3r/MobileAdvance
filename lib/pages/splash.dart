import 'package:flutter/material.dart';

import '../components/widgets/loading.dart';

class Splash extends StatelessWidget {
  const Splash();
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: const Loading(),
      ),
    );
  }
}
