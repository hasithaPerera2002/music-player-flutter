// ignore_for_file: avoid_print, prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_null_comparison

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:music_app/components/song_tile.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:on_audio_query/on_audio_query.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  List<SongModel> songs = [];

  @override
  void initState() {
    super.initState();
    permission();
    LogConfig logConfig = LogConfig(logType: LogType.DEBUG);
    _audioQuery.setLogConfig(logConfig);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Music App'),
        ),
        body: songs == null
            ? Center(
                child: Text('Searching For Songs'),
              )
            : ListView.builder(
                itemCount: songs.length,
                itemBuilder: (context, index) {
                  return SongTile(
                    song: songs[index],
                    audioQuery: _audioQuery,
                  );
                },
              ),
      ),
    );
  }

  Future<void> getFiles() async {
    if (Platform.isAndroid) {
      songs = await _audioQuery.querySongs();

      setState(() {});
    }
  }

  Future<void> permission() async {
    final PermissionStatus status = await Permission.audio.status;
    if (status.isDenied || status.isRestricted) {
      final PermissionStatus newStatus = await Permission.audio.request();
      if (newStatus.isDenied) {
      } else if (newStatus.isGranted) {
        getFiles();
      }
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    } else {
      getFiles();
    }
  }
}
