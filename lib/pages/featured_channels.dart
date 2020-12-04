import 'package:SingularSight/components/animations.dart';
import 'package:SingularSight/components/thumbnails.dart';
import 'package:SingularSight/models/channel_model.dart';
import 'package:SingularSight/pages/error.dart';
import 'package:SingularSight/services/api_service.dart';
import 'package:SingularSight/services/locator_service.dart';
import 'package:SingularSight/utilities/constants.dart';
import 'package:SingularSight/utilities/globals.dart';
import 'package:flutter/material.dart';

class FeaturedChannels extends StatefulWidget {
  const FeaturedChannels();

  @override
  _FeaturedChannelsState createState() => _FeaturedChannelsState();
}

class _FeaturedChannelsState extends State<FeaturedChannels>
    with AutomaticKeepAliveClientMixin {
  final youtube = LocatorService().youtube;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder<ApiResult<ChannelModel>>(
      future: youtube.getFeaturedChannels(),
      builder: (context, snapshot) {
        Widget child;
        if (snapshot.hasError) {
          log.e('Failed to load featured channels', snapshot.error);
          child = ErrorWidget(snapshot.error);
        } else if (snapshot.hasData) {
          child = ListView.builder(
            itemCount: snapshot.data?.items?.length ?? 0,
            itemBuilder: (context, index) {
              return _buildItem(snapshot.data.items[index]);
            },
          );
        } else
          child = Center(child: CircularProgressIndicator());
        return AnimatedSwitcher(
          child: child,
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          duration: const Duration(milliseconds: 600),
        );
      },
    );
  }

  Widget _buildItem(ChannelModel value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32.0),
      child: ChannelThumbnail(
        showSubscribeButton: true,
        vertical: true,
        title: value.title,
        subscribers: value.subscriberCount,
        thumbnail: value.thumbnails.medium,
        onThumbnailTap: () => Navigator.of(context).pushNamed(
          RouteNames.channelDetails,
          arguments: value,
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
