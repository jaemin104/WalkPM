// // walk_goal_result.dart
//
// import 'package:flutter/material.dart';
// import 'package:spotify/screens/routine_playlist_info.dart'; // RoutinePlaylistInfo import 추가
// import 'package:spotify/services/json_service.dart'; // JsonService 경로 수정
//
// class WalkGoalResultScreen extends StatefulWidget {
//   final double bpm;
//
//   const WalkGoalResultScreen({Key? key, required this.bpm}) : super(key: key);
//
//   @override
//   _WalkGoalResultScreenState createState() => _WalkGoalResultScreenState();
// }
//
// class _WalkGoalResultScreenState extends State<WalkGoalResultScreen> {
//   late Future<List<Map<String, dynamic>>> _songs;
//   late List<String> songTitles = []; // 제목을 저장할 리스트 추가
//
//   @override
//   void initState() {
//     super.initState();
//     // BPM 범위에 맞는 노래를 가져오는 메서드 사용
//     _songs = JsonService()
//         .getSongsByBPMRange(widget.bpm); // 수정: getSongsByBPMRange 메서드로 수정
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFBDC9A3),
//       appBar: AppBar(
//         title: const Text("추천 노래 리스트"),
//         backgroundColor: const Color(0xFF5C6E4F),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           children: [
//             Text(
//               "추천 BPM: ${widget.bpm.toStringAsFixed(0)} BPM",
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 20),
//             // BPM에 맞는 노래 리스트
//             FutureBuilder<List<Map<String, dynamic>>>(
//               future: _songs,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const CircularProgressIndicator();
//                 } else if (snapshot.hasError) {
//                   return Text('Error: ${snapshot.error}');
//                 } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                   return const Text("추천된 노래가 없습니다.");
//                 } else {
//                   final songs = snapshot.data!;
//                   // 노래 제목을 List<String>으로 변환
//                   songTitles = List<String>.from(
//                       songs.map((song) => song['title'] ?? 'Unknown Song'));
//                   return Expanded(
//                     child: ListView.builder(
//                       itemCount: songs.length,
//                       itemBuilder: (context, index) {
//                         final song = songs[index];
//                         return ListTile(
//                           title: Text(song['title'] ?? 'Unknown Song'),
//                           subtitle:
//                               Text('BPM: ${song['Tempo'] ?? 'Unknown BPM'}'),
//                           onTap: () {
//                             // 노래 제목 리스트를 RoutinePlaylistInfo로 전달
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => RoutinePlaylistInfo(
//                                   songTitles: songTitles,
//                                 ),
//                               ),
//                             );
//                           },
//                         );
//                       },
//                     ),
//                   );
//                 }
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'routine_playlist_info.dart'; // RoutinePlaylistInfo 페이지 import
import 'package:spotify/services/json_service.dart'; // JsonService 클래스를 import (경로를 맞게 수정)

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
