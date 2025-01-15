import 'package:flutter/material.dart';
import 'package:spotify/model/routine_model.dart';
import 'package:spotify/model/song_model.dart'; // Song 모델 추가
import 'package:flutter/services.dart'; // Asset 불러오기
import 'dart:convert'; // json.decode 임포트
import 'dart:math'; // Random 클래스 사용을 위해 추가


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
    // 노래 목록을 가져오고 랜덤으로 섞음
    _songs = data.map((json) => Song.fromJson(json)).toList();
    _songs.shuffle(Random()); // Random 객체를 사용해 목록 섞기

    // 루틴 시간에 맞는 노래 조합
    _selectedSongs = _getSongsForRoutine(widget.routine.routineTime);
  });
}

  // 루틴 시간에 맞는 노래 조합하기
  List<Song> _getSongsForRoutine(int routineTime) {
    List<Song> selectedSongs = [];
    int totalDuration = 0;

    int routineTimeMs = routineTime * 60 * 1000;

    for (Song song in _songs) {
      if (totalDuration + song.durationMs <= routineTimeMs) {
        selectedSongs.add(song);
        totalDuration += song.durationMs;
      }
      if (totalDuration >= routineTimeMs) break;
    }

    return selectedSongs;
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF9DA58E), // 배경 색상
      appBar: AppBar(
        title: Text(
          '${widget.routine.title} Playlist',
          style: const TextStyle(color: Color(0xFFEFE5C9)), // 글씨 색상
        ),
        backgroundColor: const Color(0xFF9DA58E), // 배경 색상
        elevation: 0,
      ),
      body: _songs.isEmpty
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF007A33), // 로딩 색상
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _selectedSongs.length,
                    itemBuilder: (context, index) {
                      final song = _selectedSongs[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 8.0), // 여백 설정
                        padding: const EdgeInsets.symmetric(
                            vertical: 14.0, horizontal: 16.0), // 세로 크기 증가
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFE5C9), // 카드 배경색
                          borderRadius: BorderRadius.circular(12.0), // 둥근 모서리
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15), // 그림자 색상
                              blurRadius: 8, // 그림자 퍼짐
                              offset: const Offset(0, 4), // 그림자 위치
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              song.title,
                              style: const TextStyle(
                                color: Color(0xFF007A33),
                                fontWeight: FontWeight.bold,
                                fontSize: 16, // 조금 큰 글씨 크기
                              ),
                            ),
                            const SizedBox(height: 6), // 간격 증가
                            Text(
                              'BPM: ${song.tempo} | Duration: ${(song.durationMs / 1000).toStringAsFixed(1)} s',
                              style: const TextStyle(
                                color: Color(0xFF007A33),
                                fontSize: 14, // 작은 글씨 크기
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16.0, 
                    right: 16.0, 
                    top: 16.0, 
                    bottom: 24.0, // 아래에서 띄우기
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/real_routine_playlist_info',
                        arguments:
                            _selectedSongs.map((song) => song.title).toList(),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5F6F52), // 버튼 색상
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                    ),
                    child: const Text(
                      'OK',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFFEFE5C9), // 버튼 텍스트 색상
                      ),
                    ),
                  ),
                ),
              ],
              
            ),
    );
  }
}