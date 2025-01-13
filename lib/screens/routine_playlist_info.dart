// // routine_playlist_info.dart
//
// import 'package:flutter/material.dart';
//
// class RoutinePlaylistInfo extends StatelessWidget {
//   final List<String> songTitles; // 전달받을 변수 선언
//
//   const RoutinePlaylistInfo({Key? key, required this.songTitles})
//       : super(key: key); // 생성자 수정
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFF9DA58E), // 배경 색상 설정
//       appBar: AppBar(
//         backgroundColor: Color(0xFF9DA58E),
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () {
//             Navigator.pop(context); // 뒤로 가기
//           },
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               '70~79BPM의 노래 4곡으로 14분 30초짜리\n출근길용 플레이리스트를 만들었어요.',
//               style: TextStyle(
//                 fontSize: 18,
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 20),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: songTitles.length,
//                 itemBuilder: (context, index) {
//                   return _buildSongTile(songTitles[index]);
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSongTile(String title) {
//     return ListTile(
//       title: Text(
//         title,
//         style: TextStyle(
//           fontSize: 16,
//           color: Colors.white,
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RoutinePlaylistInfo(songTitles: []), // 초기 빈 리스트
    );
  }
}

class RoutinePlaylistInfo extends StatelessWidget {
  final List<String> songTitles; // 전달된 노래 제목 리스트

  // 생성자에서 songTitles를 받음
  RoutinePlaylistInfo({required this.songTitles});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF9DA58E), // 배경 색상 설정
      appBar: AppBar(
        backgroundColor: Color(0xFF9DA58E),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // 뒤로가기 버튼
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '추천된 노래 제목들:',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            // songTitles 리스트를 출력
            Expanded(
              child: ListView.builder(
                itemCount: songTitles.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      songTitles[index],
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
