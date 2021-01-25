import 'package:SingularSight/components/image.dart';
import 'package:SingularSight/models/channel_model.dart';
import 'package:SingularSight/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/youtube/v3.dart';
import 'package:SingularSight/utilities/type_extension.dart';
import 'package:SingularSight/components/typography.dart' as typo;

/// a Column consisting of an image and a label
class ShortThumbnail extends StatelessWidget {
  final ChannelModel channel;
  final String heroId;
  final bool _v;
  const ShortThumbnail.v({
    Key key,
    @required this.channel,
    this.heroId,
  })  : _v = true,
        super(key: key);
  const ShortThumbnail.h({
    Key key,
    @required this.channel,
    this.heroId,
  })  : _v = false,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => Navigator.of(context).pushNamed(
              RouteNames.channelDetails,
              arguments: channel,
            ),
        child: _v ? _vBuild(context) : _hBuild(context));
  }

  Widget _vBuild(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: _ImageWidget(
            heroId: heroId ?? channel.id,
            thumbnail: channel.thumbnails.medium,
          ),
        ),
        const SizedBox(height: 8.0),
        typo.Title(
          text: channel.title,
        ),
        const SizedBox(height: 8.0),
        typo.Subtitle(
          text: channel.subscriberCount.toCountingFormat('subscribers'),
        ),
      ],
    );
  }

  Widget _hBuild(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: _ImageWidget(
            heroId: heroId ?? channel.id,
            thumbnail: channel.thumbnails.medium,
          ),
        ),
        const SizedBox(width: 16.0),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            typo.Title(text: channel.title),
            const SizedBox(height: 8.0),
            typo.Subtitle(
              text: channel.subscriberCount.toCountingFormat('subscribers'),
            ),
          ],
        )
      ],
    );
  }
}

class _ImageWidget extends StatelessWidget {
  final Thumbnail thumbnail;
  final String heroId;
  const _ImageWidget({
    Key key,
    this.thumbnail,
    this.heroId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: heroId,
      child: ClipOval(
        child: ThumbnailImage(thumbnail: thumbnail),
      ),
    );
  }
}
