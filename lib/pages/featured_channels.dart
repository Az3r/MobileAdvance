import 'package:SingularSight/components/channel/channel_thumbnail.dart';
import 'package:SingularSight/services/locator_service.dart';
import 'package:flutter/material.dart';

class FeaturedChannels extends StatefulWidget {
  const FeaturedChannels();

  @override
  _FeaturedChannelsState createState() => _FeaturedChannelsState();
}

class _FeaturedChannelsState extends State<FeaturedChannels> with AutomaticKeepAliveClientMixin {
  final youtube = LocatorService().youtube;
  final users = LocatorService().users;

  final _list = GlobalKey<AnimatedListState>();
  final videos = <ChannelThumbnail>[];

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    youtube.getAllChannels().forEach((value) {
      videos.add(ChannelThumbnail(channel: value));
      _list.currentState.insertItem(videos.length - 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SizedBox(
      child: AnimatedList(
        key: _list,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index, animation) {
          return ScaleTransition(
            scale: Tween(begin: 0.0, end: 1.0)
                .chain(CurveTween(curve: Curves.easeOut))
                .animate(animation),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 48),
              child: Container(
                child: videos[index],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
