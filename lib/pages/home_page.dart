import 'package:flutter/material.dart';
import '../components/courses.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Center(child: CourseMaster()),
      ],
    );
  }
}
