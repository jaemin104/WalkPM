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

// WalkGoalResultScreen 클래스 정의
class WalkGoalResultScreen extends StatefulWidget {
  final double bpm;

  WalkGoalResultScreen({required this.bpm});

  @override
  _WalkGoalResultScreenState createState() => _WalkGoalResultScreenState();
}

class _WalkGoalResultScreenState extends State<WalkGoalResultScreen> {
  late Future<List<String>> songTitles;

  // 초기화 메서드
  @override
  void initState() {
    super.initState();
    songTitles = _getSongTitlesByBPM(widget.bpm);
  }

  // BPM 값에 따라 노래 제목을 가져오는 메서드
  Future<List<String>> _getSongTitlesByBPM(double bpm) async {
    final songs = await JsonService().getSongsByBPMRange(bpm);
    return songs
        .map<String>((song) => song['title'] ?? 'Unknown Song')
        .toList();
  }

  // UI 구성 메서드
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA9B388), // 배경색 설정
      appBar: AppBar(
        title: const Text(
          'Walk Goal Playlist',
          style: TextStyle(
            color: Color(0xFFEFE5C9), // 제목 텍스트 색상
          ),
        ),
        backgroundColor: const Color(0xFFA9B388), // 상단바 배경색 설정
        elevation: 0, // 상단바 그림자 제거
        iconTheme: const IconThemeData(
          color: Color(0xFFEFE5C9), // 뒤로가기 버튼 색상
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 추천 BPM 표시 텍스트
            Center(
              child: Text(
                '추천 BPM _ ${widget.bpm.toStringAsFixed(0)} BPM',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5C6E4F), // 텍스트 색상
                ),
              ),
            ),

            // 간격 추가
            const SizedBox(height: 20),

            // 노래 리스트
            Expanded(
              child: FutureBuilder<List<String>>(
                future: songTitles,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF007A33), // 로딩 색상
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: const TextStyle(
                          color: Color(0xFFEFE5C9),
                        ),
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        "추천된 노래가 없습니다.",
                        style: TextStyle(
                          color: Color(0xFFEFE5C9),
                        ),
                      ),
                    );
                  } else {
                    final titles = snapshot.data!;
                    return ListView.builder(
                      itemCount: titles.length,
                      itemBuilder: (context, index) {
                        final title = titles[index];

                        // 노래 리스트 카드 스타일
                        return Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 8.0,
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 14.0,
                            horizontal: 16.0,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFE5C9), // 카드 배경색
                            borderRadius: BorderRadius.circular(12.0), // 둥근 모서리
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1), // 그림자
                                blurRadius: 6,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Text(
                            title,
                            style: const TextStyle(
                              color: Color(0xFF5C6E4F), // 텍스트 색상
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),

            // 하단 버튼
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  // 노래 제목 가져오기
                  List<String> titles = await songTitles;

                  // RoutinePlaylistInfo 페이지로 이동
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          RoutinePlaylistInfo(songTitles: titles),
                    ),
                  );
                },

                // 버튼 스타일
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5C6E4F), // 버튼 배경색
                  padding: const EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 36.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0), // 둥근 모서리
                  ),
                  elevation: 8, // 그림자 깊이
                  shadowColor: Colors.black.withOpacity(0.25), // 그림자 색상
                ),

                // 버튼 텍스트 및 아이콘
                child: Row(
                  mainAxisSize: MainAxisSize.min, // 텍스트와 아이콘 간격 최소화
                  children: [
                    const Icon(
                      Icons.arrow_forward, // 아이콘
                      color: Color(0xFFEFE5C9), // 아이콘 색상
                      size: 20,
                    ),
                    const SizedBox(width: 8), // 텍스트와 아이콘 간격
                    const Text(
                      'Go to Playlist Info',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold, // 텍스트 두께
                        color: Color(0xFFEFE5C9), // 텍스트 색상
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 간격 추가
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
