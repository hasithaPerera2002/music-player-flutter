// ignore_for_file: avoid_print, prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_null_comparison

import 'dart:io';
import 'dart:ui';

import 'package:animate_gradient/animate_gradient.dart';
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
  final LinearGradient gradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color.fromARGB(77, 0, 17, 30), Color.fromARGB(255, 214, 176, 236)],
  );

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
          backgroundColor: Colors.transparent,
          elevation: 2.0,
          flexibleSpace: AnimateGradient(
            primaryColors: [
              Color.fromARGB(255, 239, 80, 167),
              Color.fromARGB(255, 47, 20, 80),
              Color.fromARGB(255, 116, 14, 119),
            ],
            secondaryColors: [
              Color.fromARGB(255, 80, 228, 239),
              Color.fromARGB(255, 38, 64, 53),
              Color.fromARGB(255, 14, 23, 119),
            ],
          ),
          actions: [
            IconButton(
                onPressed: () {},
                icon: Padding(
                  padding: const EdgeInsets.only(right: 30),
                  child: Icon(Icons.search),
                ))
          ],
        ),
        body: songs == null
            ? Center(
                child: Text('Searching For Songs'),
              )
            : AnimateGradient(
                primaryColors: const [
                  Color.fromARGB(255, 116, 14, 119),
                  Color.fromARGB(255, 43, 27, 62),
                  Color.fromARGB(255, 239, 80, 167),
                ],
                secondaryColors: const [
                  Color.fromARGB(255, 14, 23, 119),
                  Color.fromARGB(255, 38, 64, 53),
                  Color.fromARGB(255, 80, 228, 239),
                ],
                child: ListView.builder(
                  itemCount: songs.length,
                  itemBuilder: (context, index) {
                    return SongTile(
                      song: songs[index],
                      audioQuery: _audioQuery,
                    );
                  },
                ),
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
