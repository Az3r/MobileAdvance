import 'dart:io';

import 'package:SingularSight/components/channel_playlists.dart';
import 'package:SingularSight/models/channel_model.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:SingularSight/components/channel.dart' as ch;

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
                delegate: SliverChildListDelegate.fixed(
                  [
                    SizedBox(
                      child: ch.ShortThumbnail.h(channel: widget.channel),
                      width: 64,
                      height: 64,
                    ),
                    SizedBox(height: 8),
                    SizedBox(
                        width: 480,
                        child: ElevatedButton(
                          child: Text('SUBSCRIBE'),
                          onPressed: _openYoutubeChannel,
                        )),
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

  void _openYoutubeChannel() async {
    final scheme = Platform.isIOS ? 'youtube' : 'https';
    final url = '$scheme://www.youtube.com/channel/${widget.channel.id}';
    launch(url).catchError((error) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Oopise!'),
            content: Text('Unable to open youtube app'),
            actions: [
              TextButton(
                child: Text("That's sad!"),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );
    });
  }
}
