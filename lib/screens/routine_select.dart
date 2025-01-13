import 'package:flutter/material.dart';
import 'routine_playlist.dart'; // 해당 페이지로 이동
import 'routine_list.dart'; // 해당 페이지로 이동

class RoutineSelectApp extends StatelessWidget {
  const RoutineSelectApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Routine Select',
      home: const RoutineSelectScreen(),
    );
  }
}

class RoutineSelectScreen extends StatelessWidget {
  const RoutineSelectScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFBDC9A3), // 배경 색상
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // 상단 로고와 제목
          Padding(
            padding: EdgeInsets.symmetric(vertical: screenHeight * 0.05),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.music_note, size: screenWidth * 0.1),
                    SizedBox(width: 10),
                    Text(
                      "WalkPM",
                      style: TextStyle(
                        fontSize: screenWidth * 0.08,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.03),
                Text(
                  "내 루틴",
                  style: TextStyle(
                    fontSize: screenWidth * 0.06,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: screenHeight * 0.03),
          // 루틴 버튼
          Wrap(
            spacing: screenWidth * 0.03,
            runSpacing: screenHeight * 0.02,
            alignment: WrapAlignment.center,
            children: [
              _buildRoutineButton(context, "출근길"),
              _buildRoutineButton(context, "본가 가는 길"),
              _buildRoutineButton(context, "퇴근길"),
              _buildRoutineButton(context, "우리 아들 학교 가는 길"),
              _buildEditButton(context),
            ],
          ),
          const Spacer(), // 여백을 추가해 하단 네비게이션과 분리
        ],
      ),
    );
  }

  // 루틴 버튼 위젯 생성 함수
  Widget _buildRoutineButton(BuildContext context, String text) {
    return ElevatedButton(
      onPressed: () {
        // 각 버튼 클릭 시 routine_playlist.dart로 이동
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const RoutinePlaylistScreen()),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFEFE5C9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.black),
      ),
    );
  }

  // 수정하기 버튼 위젯
  Widget _buildEditButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        // 수정 버튼 클릭 시 routine_list.dart로 이동
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RoutineListScreen()),
        );
      },
      icon: const Icon(Icons.edit, color: Colors.black),
      label: const Text(
        "수정하기",
        style: TextStyle(color: Colors.black),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFEFE5C9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
    );
  }
}
