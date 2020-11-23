import 'package:SingularSight/services/locator_service.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/youtube/v3.dart';
import '../services/locator_service.dart';

class Home extends StatefulWidget {
  const Home();

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  YoutubeApi _youtube;
  @override
  void initState() {
    super.initState();
    LocatorService().youtube.then((value) {
      _youtube = value;
      test();
    });
  }

  void test() async {
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
