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
import 'package:SingularSight/components/channel.dart' as ch;
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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder<ApiResult<ChannelModel>>(
      future: _loadChannels(),
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
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    child:
                        ch.ShortThumbnail(channel: snapshot.data.items[index]),
                    height: 112,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<ApiResult<ChannelModel>> _loadChannels() async {
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
  bool get wantKeepAlive => true;
}
