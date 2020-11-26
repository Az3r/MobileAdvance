import 'package:SingularSight/components/video/v_video_thumbnail.dart';
import 'package:SingularSight/models/user_model.dart';
import 'package:SingularSight/services/locator_service.dart';
import 'package:SingularSight/services/user_service.dart';
import 'package:SingularSight/services/video_service.dart';
import 'package:flutter/material.dart';
import '../services/locator_service.dart';

class Home extends StatefulWidget {
  const Home();

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final youtube = LocatorService().youtube;
  final users = LocatorService().users;

  final _list = GlobalKey<AnimatedListState>();
  final videos = const <VVideoThumbnail>[];

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    youtube.findVideosByChannel('UC7eAfUjR9gdIjoaoQaS0W-A').forEach((value) {
      videos.add(VVideoThumbnail(video: value));
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
            child: Container(
              height: 480,
              child: Center(
                child: SizedBox(
                  height: 256,
                  width: 256,
                  child: videos[index],
                ),
              ),
            ),
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
