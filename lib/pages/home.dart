import 'package:SingularSight/components/video/video_thumbnail.dart';
import 'package:SingularSight/models/user.dart';
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
  User _user;
  @override
  void initState() {
    super.initState();
    LocatorService().users.then((value) => _user = value.loggedUser);
    LocatorService().youtube.then((value) {
      _youtube = value;
      test();
    });
  }


  void test() async {}

  @override
  Widget build(BuildContext context) {
    return Container(child: VideoThumbnail());
  }

  @override
  void dispose() {
    super.dispose();
  }
}
