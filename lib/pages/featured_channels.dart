import 'package:SingularSight/components/thumbnails.dart';
import 'package:SingularSight/models/channel_model.dart';
import 'package:SingularSight/services/locator_service.dart';
import 'package:SingularSight/utilities/constants.dart';
import 'package:flutter/material.dart';

class FeaturedChannels extends StatefulWidget {
  const FeaturedChannels();

  @override
  _FeaturedChannelsState createState() => _FeaturedChannelsState();
}

class _FeaturedChannelsState extends State<FeaturedChannels>
    with AutomaticKeepAliveClientMixin {
  final youtube = LocatorService().youtube;
  final users = LocatorService().users;

  final _list = GlobalKey<AnimatedListState>();
  final videos = <ChannelModel>[];

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    youtube.getAllChannels().forEach((value) {
      videos.add(value);
      _list.currentState.insertItem(videos.length - 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AnimatedList(
      key: _list,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index, animation) {
        return ScaleTransition(
          scale: Tween(begin: 0.0, end: 1.0)
              .chain(CurveTween(curve: Curves.easeOut))
              .animate(animation),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: _buildItem(videos[index]),
          ),
        );
      },
    );
  }

  Widget _buildItem(ChannelModel value) {
    return ChannelThumbnail(
      showSubscribeButton: true,
      vertical: true,
      title: value.title,
      subscribers: value.subscriberCount,
      thumbnail: value.thumbnails.medium,
      onThumbnailTap: () => Navigator.of(context).pushNamed(
        RouteNames.channelDetails,
        arguments: value,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
