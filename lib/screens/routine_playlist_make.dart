import 'package:flutter/material.dart';
import 'package:spotify/model/routine_model.dart';
import 'package:spotify/model/song_model.dart'; // Song 모델 추가
import 'package:flutter/services.dart'; // Asset 불러오기
import 'dart:convert'; // json.decode 임포트

class RoutinePlaylistMakePage extends StatefulWidget {
  final Routine routine;

  RoutinePlaylistMakePage({required this.routine});

  @override
  _RoutinePlaylistMakePageState createState() =>
      _RoutinePlaylistMakePageState();
}

class _RoutinePlaylistMakePageState extends State<RoutinePlaylistMakePage> {
  late List<Song> _songs; // 노래 목록
  late List<Song> _selectedSongs; // 선택된 노래 목록

  @override
  void initState() {
    super.initState();
    _songs = [];
    _selectedSongs = [];
    _loadSongs(); // 노래 목록 로드
  }

  // songs.json 파일에서 노래 불러오기
  Future<void> _loadSongs() async {
    final String response = await rootBundle.loadString('assets/songs.json');
    final List<dynamic> data = json.decode(response);
    setState(() {
      _songs = data.map((json) => Song.fromJson(json)).toList();
      _selectedSongs =
          _getSongsForRoutine(widget.routine.routineTime); // 루틴 시간에 맞게 노래 선택
    });
  }

  // 루틴 시간에 맞는 노래 조합하기
  List<Song> _getSongsForRoutine(int routineTime) {
    List<Song> selectedSongs = [];
    int totalDuration = 0;

    // routineTime을 분에서 밀리초로 변환
    int routineTimeMs = routineTime * 60 * 1000;

    for (Song song in _songs) {
      // 재생 시간(ms)을 비교할 때, 루틴 시간을 밀리초로 변환해서 비교
      if (totalDuration + song.durationMs <= routineTimeMs) {
        selectedSongs.add(song);
        totalDuration += song.durationMs;
      }
      if (totalDuration >= routineTimeMs) break; // 루틴 시간이 초과되면 종료
    }

    return selectedSongs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.routine.title} Playlist'),
      ),
      body: _songs.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _selectedSongs.length,
                    itemBuilder: (context, index) {
                      final song = _selectedSongs[index];
                      return ListTile(
                        title: Text(song.title),
                        subtitle: Text(
                            'BPM: ${song.tempo} | Duration: ${(song.durationMs / 1000).toString()} s'),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // OK 버튼 클릭 시 real_routine_playlist_info.dart로 이동
                      Navigator.pushNamed(
                        context,
                        '/real_routine_playlist_info',
                        arguments: _selectedSongs.map((song) => song.title).toList(),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, // 버튼 색상
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 20.0), // 버튼 패딩
                    ),
                    child: const Text(
                      'OK',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
