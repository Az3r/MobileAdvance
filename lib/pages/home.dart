import 'package:SingularSight/models/user.dart';
import 'package:SingularSight/models/video.dart';
import 'package:SingularSight/services/locator_service.dart';
import 'package:SingularSight/services/video_service.dart';
import 'package:flutter/material.dart';
import '../services/locator_service.dart';

class Home extends StatefulWidget {
  const Home();

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  VideoService _youtube;
  UserModel _user;
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
    return Container(
      child: StreamBuilder<VideoModel>(
        stream: _youtube.find('UC7eAfUjR9gdIjoaoQaS0W-A'),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final widget = Container(child: Text(snapshot.data.title));
            return AnimatedList(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index, animation) {
                return FadeTransition(
                  opacity: Tween(begin: 0.0, end: 1)
                      .chain(CurveTween(curve: Curves.easeOut))
                      .animate(animation),
                  child: ScaleTransition(
                      scale: Tween(begin: 0.0, end: 1)
                          .chain(CurveTween(curve: Curves.easeOut))
                          .animate(animation),
                      child: widget),
                );
              },
            );
          }
          return SizedBox(
            child: CircularProgressIndicator(),
            width: 64,
            height: 64,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
