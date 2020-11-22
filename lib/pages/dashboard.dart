import 'package:flutter/material.dart';
import '../components/course/course_master.dart';

/// First page to open, displays app goals and a list of popular courses
/// seperated by type.
/// Each type provides an option to see all courses.
class Dashboard extends StatelessWidget {
  const Dashboard({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        centerTitle: true,
      ),
    );
  }
}
