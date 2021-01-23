import 'package:SingularSight/models/channel_model.dart';
import 'package:SingularSight/styles/texts.dart';
import 'package:SingularSight/utilities/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/youtube/v3.dart';
import 'package:SingularSight/utilities/type_extension.dart';

/// a Column consisting of an image and a label
class ShortThumbnail extends StatelessWidget {
  final ChannelModel channel;
  final String heroId;
  final bool _v;
  const ShortThumbnail.v({
    Key key,
    this.channel,
    this.heroId,
  })  : _v = true,
        super(key: key);
  const ShortThumbnail.h({
    Key key,
    this.channel,
    this.heroId,
  })  : _v = false,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return _v ? _vBuild(context) : _hBuild(context);
  }

  Widget _vBuild(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).pushNamed(
        RouteNames.channelDetails,
        arguments: channel,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: _ImageWidget(
              heroId: heroId ?? channel.id,
              thumbnail: channel.thumbnails.medium,
            ),
          ),
          SizedBox(
            height: 8.0,
          ),
          _Title(
            text: channel.title,
          ),
          SizedBox(
            height: 8.0,
          ),
          _Subtitle(
            text: channel.subscriberCount.toSubscirberFormat(context),
          ),
        ],
      ),
    );
  }

  Widget _hBuild(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).pushNamed(
        RouteNames.channelDetails,
        arguments: channel,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          _ImageWidget(
            heroId: heroId ?? channel.id,
            thumbnail: channel.thumbnails.medium,
          ),
          SizedBox(
            width: 16.0,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Title(
                text: channel.title,
              ),
              SizedBox(
                height: 8.0,
              ),
              _Subtitle(
                text: channel.subscriberCount.toSubscirberFormat(context),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {
  final String text;
  const _Title({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.subtitle1);
  }
}

class _Subtitle extends StatelessWidget {
  final String text;
  const _Subtitle({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.subtitle2,
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
        child: Material(
          child: CachedNetworkImage(
            imageUrl: thumbnail.url,
            placeholder: (context, url) => Icon(Icons.image),
            errorWidget: (context, url, error) => Container(
              decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.all(Radius.circular(16))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.warning),
                  Text('Unable to load image'),
                ],
              ),
            ),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
