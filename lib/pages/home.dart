import 'package:SingularSight/components/video/video_thumbnail.dart';
import 'package:SingularSight/models/user_model.dart';
import 'package:SingularSight/models/video_model.dart';
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
  final _list = GlobalKey<AnimatedListState>();
  UserModel _user;
  final videos = <VideoThumbnail>[];
  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    _youtube = await LocatorService().youtube;
    _user = (await LocatorService().users).loggedUser;
    _youtube.find('UC7eAfUjR9gdIjoaoQaS0W-A').forEach((value) {
      videos.add(VideoThumbnail(video: value));
      _list.currentState.insertItem(videos.length - 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AnimatedList(
        key: _list,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index, animation) {
          return ScaleTransition(
              scale: Tween(begin: 0.0, end: 1.0)
                  .chain(CurveTween(curve: Curves.easeOut))
                  .animate(animation),
              child: videos[index]);
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
