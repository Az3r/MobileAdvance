import 'package:SingularSight/components/errors.dart';
import 'package:SingularSight/components/image.dart' as img;
import 'package:SingularSight/models/playlist_model.dart';
import 'package:SingularSight/models/skill_model.dart';
import 'package:SingularSight/services/api_service.dart';
import 'package:SingularSight/services/firebase_service.dart';
import 'package:SingularSight/services/locator_service.dart';
import 'package:SingularSight/utilities/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:googleapis/youtube/v3.dart';
import 'package:SingularSight/components/typography.dart' as typo;

class Home extends StatelessWidget {
  const Home({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<SkillModel>>(
      stream: FirebaseService().skills(),
      builder: (context, snapshot) {
        if (snapshot.hasData)
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) => Container(
              height: 320,
              padding: const EdgeInsets.all(16.0),
              child: _SkillWidget(
                skill: snapshot.data[index],
              ),
            ),
          );
        if (snapshot.hasError) return ErrorWidget(snapshot.error);
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}

class _SkillWidget extends StatefulWidget {
  final SkillModel skill;
  const _SkillWidget({Key key, @required this.skill})
      : assert(skill != null),
        super(key: key);

  @override
  _SkillWidgetState createState() => _SkillWidgetState();
}

class _SkillWidgetState extends State<_SkillWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ActionChip(
          onPressed: () {},
          tooltip: 'Press me see more of this',
          label: Text(widget.skill.name),
          avatar: widget.skill.data != null
              ? Image.memory(widget.skill.data)
              : null,
        ),
        SizedBox(height: 8),
        Expanded(
          child: FutureBuilder<ApiToken<PlaylistModel>>(
              future: LocatorService()
                  .youtube
                  .searchPlaylists(widget.skill.keyword),
              builder: (context, snapshot) {
                if (snapshot.hasData)
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data.items.length,
                    itemBuilder: (context, index) => Container(
                      margin: const EdgeInsets.only(right: 16.0),
                      width: 256,
                      child: _PlaylistWidget(
                        playlist: snapshot.data.items[index],
                      ),
                    ),
                  );
                if (snapshot.hasError) return ErrorWidget(snapshot.error);
                return Center(
                  child: CircularProgressIndicator(),
                );
              }),
        )
      ],
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class _PlaylistWidget extends StatelessWidget {
  final PlaylistModel playlist;
  const _PlaylistWidget({
    Key key,
    this.playlist,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: img.ThumbnailImage(thumbnail: playlist.thumbnails.medium),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                SizedBox(
                  width: 32,
                  child: _ChannelIcon(
                    thumbnail: playlist.channel.thumbnails.medium,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      typo.Title(text: playlist.title),
                      SizedBox(height: 8),
                      typo.Subtitle(text: playlist.channel.title),
                      typo.Subtitle(text: '${playlist.videoCount} videos'),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    iconSize: 24,
                    padding: EdgeInsets.zero,
                    icon: Icon(Icons.more_vert),
                    onPressed: () => Navigator.of(context).pushNamed(
                      RouteNames.channelDetails,
                      arguments: playlist.channel,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _ChannelIcon extends StatelessWidget {
  final Thumbnail thumbnail;
  const _ChannelIcon({
    Key key,
    this.thumbnail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: CachedNetworkImage(
        imageUrl: thumbnail.url,
        placeholder: (context, url) => Icon(Icons.account_box),
        errorWidget: (context, url, error) => Container(
          child: NetworkImageError(error: error),
        ),
        fit: BoxFit.cover,
      ),
    );
  }
}
