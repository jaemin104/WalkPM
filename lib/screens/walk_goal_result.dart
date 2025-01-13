import 'package:flutter/material.dart';
import 'package:spotify/screens/routine_playlist_info.dart'; // RoutinePlaylistInfo 페이지 import
import 'package:spotify/services/json_service.dart'; // JsonService 클래스를 import

class WalkGoalResultScreen extends StatefulWidget {
  final double bpm;

  WalkGoalResultScreen({required this.bpm});

  @override
  _WalkGoalResultScreenState createState() => _WalkGoalResultScreenState();
}

class _WalkGoalResultScreenState extends State<WalkGoalResultScreen> {
  late Future<List<String>> songTitles;

  @override
  void initState() {
    super.initState();
    // getSongsByBPMRange()에서 제목만 추출하여 songTitles에 저장
    songTitles = _getSongTitlesByBPM(widget.bpm);
  }

  // BPM 범위에 맞는 제목만 추출하는 메서드
  Future<List<String>> _getSongTitlesByBPM(double bpm) async {
    // songs를 BPM 범위에 맞는 곡들로 가져오기
    final songs = await JsonService().getSongsByBPMRange(bpm);

    // 제목을 List<String>으로 변환
    return songs
        .map<String>((song) => song['title'] ?? 'Unknown Song')
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Walk Goal Result'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'You have selected BPM: ${widget.bpm}',
              style: TextStyle(fontSize: 18),
            ),
            // 버튼을 추가하여 RoutinePlaylistInfo 페이지로 이동
            ElevatedButton(
              onPressed: () async {
                // getSongsByBPMRange 메서드를 통해 songTitles 리스트를 가져옴
                List<String> titles = await songTitles;
                // 버튼 클릭 시 RoutinePlaylistInfo로 이동하고 songTitles 전달
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        RoutinePlaylistInfo(songTitles: titles),
                  ),
                );
              },
              child: Text('Go to Playlist Info'),
            ),
          ],
        ),
      ),
    );
  }
}
