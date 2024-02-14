// ignore_for_file: use_key_in_widget_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongTile extends StatefulWidget {
  final SongModel song;
  final OnAudioQuery audioQuery;
  const SongTile({Key? key, required this.song, required this.audioQuery});

  @override
  State<SongTile> createState() => _SongTileState();
}

class _SongTileState extends State<SongTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: SizedBox(
        height: 25,
        child: Text(
          widget.song.title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      subtitle: Text(
        widget.song.artist ?? 'Unknown Artist',
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w300,
        ),
      ),
      isThreeLine: false,
      leading: QueryArtworkWidget(
        id: widget.song.id,
        type: ArtworkType.AUDIO,
        artworkFit: BoxFit.cover,
        controller: widget.audioQuery,
        artworkBorder: BorderRadius.circular(10),
        artworkHeight: 80,
        artworkWidth: 50,
      ),
      trailing: IconButton(
        icon: const Icon(Icons.more_vert_sharp),
        onPressed: () {
          //  widget.audioQuery.play(musicId: widget.song.id);
        },
      ),
      onLongPress: () {},
      onTap: () {},
    );
  }
}
