import 'package:SingularSight/components/video/h_video_thumbnail.dart';
import 'package:SingularSight/services/locator_service.dart';
import 'package:flutter/material.dart';

class SliverChannelCourses extends StatefulWidget {
  final String channelId;

  const SliverChannelCourses({Key key, this.channelId}) : super(key: key);

  @override
  _SliverChannelCoursesState createState() => _SliverChannelCoursesState();
}

class _SliverChannelCoursesState extends State<SliverChannelCourses> {
  final youtube = LocatorService().youtube;
  final _list = GlobalKey<SliverAnimatedListState>();

  final videos = <HVideoThumbnail>[];

  @override
  void initState() {
    super.initState();
    youtube.findVideosByChannel(widget.channelId).forEach((element) {
      videos.add(HVideoThumbnail(video: element));
      _list.currentState.insertItem(videos.length - 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SliverAnimatedList(
      key: _list,
      itemBuilder: (context, index, animation) {
        return ScaleTransition(
          scale: Tween(begin: 0.0, end: 1.0)
              .chain(CurveTween(curve: Curves.easeOut))
              .animate(animation),
          child: videos[index],
        );
      },
    );
  }
}
