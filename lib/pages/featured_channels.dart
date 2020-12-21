import 'dart:io';

import 'package:SingularSight/components/animations.dart';
import 'package:SingularSight/components/routings.dart';
import 'package:SingularSight/components/thumbnails.dart';
import 'package:SingularSight/models/channel_model.dart';
import 'package:SingularSight/pages/network_error.dart';
import 'package:SingularSight/services/api_service.dart';
import 'package:SingularSight/services/locator_service.dart';
import 'package:SingularSight/utilities/constants.dart';
import 'package:SingularSight/utilities/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:googleapis/youtube/v3.dart';

class FeaturedChannels extends StatefulWidget {
  const FeaturedChannels();

  @override
  _FeaturedChannelsState createState() => _FeaturedChannelsState();
}

class _FeaturedChannelsState extends State<FeaturedChannels>
    with AutomaticKeepAliveClientMixin {
  final youtube = LocatorService().youtube;

  Future<ApiResult<ChannelModel>> load() async {
    var result = ApiResult<ChannelModel>();
    var retry = true;
    while (retry) {
      try {
        result = await youtube.getFeaturedChannels();
        retry = false;
      } on DetailedApiRequestError {
        Navigator.of(context).push(Routings.exceedQuota());
        retry = false;
      } on SocketException {
        retry = await Navigator.of(context).push(Routings.disconnected());
      } catch (e) {
        rethrow;
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder<ApiResult<ChannelModel>>(
      future: load(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return ErrorWidget(snapshot.error);
        } else if (snapshot.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        }
        return AnimationLimiter(
          child: ListView.builder(
            itemCount: snapshot.data?.items?.length ?? 0,
            itemBuilder: (context, index) {
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 300),
                child: _buildItem(snapshot.data.items[index]),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildItem(ChannelModel value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32.0),
      child: ChannelThumbnail.vertical(
        channel: value,
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
