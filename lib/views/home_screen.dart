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
  List<SongModel> filteredSongs = [];
  bool isSearching = false;
  String searchText = '';
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
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

  void _onSeachTextChanged({required String text}) {
    print(text);
    setState(() {
      filteredSongs = songs
          .where((song) =>
              song.title.toLowerCase().contains(text.toLowerCase()) ||
              song.artist!.toLowerCase().contains(text.toLowerCase()))
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: songs == null
            ? Center(
                child: Text('Searching For Songs'),
              )
            : NestedScrollView(
                floatHeaderSlivers: true,
                headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  SliverAppBar(
                    title: isSearching
                        ? Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextField(
                              cursorRadius: Radius.circular(1),
                              cursorWidth: 2,
                              focusNode: _focusNode,
                              controller: _searchController,
                              onChanged: (value) {
                                _onSeachTextChanged(text: value);
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                hintText: 'Search Songs',
                                hintStyle: TextStyle(color: Colors.grey),
                                contentPadding:
                                    EdgeInsets.fromLTRB(16, 20, 16, 8),
                              ),
                            ),
                          )
                        : Text('Music App'),
                    floating: true,
                    snap: true,
                    backgroundColor: Colors.transparent,
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
                      Container(
                        margin: EdgeInsets.only(right: 30),
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              isSearching = !isSearching;
                            });
                          },
                          icon: Icon(isSearching ? Icons.close : Icons.search),
                        ),
                      )
                    ],
                  )
                ],
                body: AnimateGradient(
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
                  child: isSearching
                      ? ListView.builder(
                          itemCount: filteredSongs.length,
                          itemBuilder: (context, index) {
                            return SongTile(
                                song: filteredSongs[index],
                                audioQuery: _audioQuery);
                          },
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
