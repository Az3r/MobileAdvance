import 'package:flutter/material.dart';
import '../components/course/course_master.dart';

/// First page to open, displays app goals and a list of popular courses
/// seperated by type.
/// Each type provides an option to see all courses.
class Dashboard extends StatefulWidget {
  const Dashboard({Key key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  PageController _controller;
  @override
  void initState() {
    _controller = PageController(
      initialPage: 1,
      keepPage: true,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        centerTitle: true,
      ),
      body:PageView(
        controller: _controller,
        children: [

        ],
      )
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
