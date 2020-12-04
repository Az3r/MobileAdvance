import 'package:SingularSight/components/thumbnails.dart';
import 'package:SingularSight/components/channel_playlists.dart';
import 'package:SingularSight/models/channel_model.dart';
import 'package:flutter/material.dart';

class ChannelDetails extends StatefulWidget {
  final ChannelModel channel;

  const ChannelDetails({Key key, this.channel}) : super(key: key);

  @override
  _ChannelDetailsState createState() => _ChannelDetailsState();
}

class _ChannelDetailsState extends State<ChannelDetails> {
  final _playlists = GlobalKey<SliverPlaylistsState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: profileColor,
        title: Text(widget.channel.title),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.notifications),
        onPressed: () {},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      body: NotificationListener<ScrollEndNotification>(
        onNotification: (notification) {
          _playlists.currentState.loadNext();
          return true;
        },
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 16,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    ChannelThumbnail(
                      isSubscribed: false,
                      onSubscribed: null,
                      showSubscribeButton: true,
                      subscribers: widget.channel.subscriberCount,
                      thumbnail: widget.channel.thumbnails.medium,
                      thumbnailRadius: 32,
                      title: widget.channel.title,
                      vertical: false,
                    ),
                    SizedBox(height: 16),
                    Text(widget.channel.description),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Divider(
                thickness: 1,
                color: Colors.white24,
              ),
            ),
            SliverPlaylists(key: _playlists, channel: widget.channel)
          ],
        ),
      ),
    );
  }

  Color get profileColor {
    return widget.channel.profileColor == '#000000'
        ? null
        : Color(int.tryParse(
            widget.channel.profileColor.replaceRange(0, 1, '0xFF')));
  }
}
