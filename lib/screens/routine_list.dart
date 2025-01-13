import 'package:flutter/material.dart';
import 'routine_add.dart'; // routine_add.dart를 import

class RoutineListApp extends StatelessWidget {
  const RoutineListApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Routine List',
      home: const RoutineListScreen(),
    );
  }
}

class RoutineListScreen extends StatelessWidget {
  const RoutineListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF9DA58E),
      appBar: AppBar(
        backgroundColor: Color(0xFF9DA58E),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // 이전 페이지로 이동
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 상단 제목 및 버튼
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: screenHeight * 0.05, horizontal: screenWidth * 0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                  "자주 가는 길을 루틴으로 등록해 보세요!",
                  style: TextStyle(
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // 새 루틴 추가 버튼 클릭 시 routine_add.dart로 이동
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RoutineAddScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5C6E4F),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.1,
                        vertical: screenHeight * 0.02,
                      ),
                    ),
                    child: Text(
                      "새 루틴 추가하기",
                      style: TextStyle(
                        fontSize: screenWidth * 0.05,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: Colors.black54,
            thickness: 1,
            indent: screenWidth * 0.1,
            endIndent: screenWidth * 0.1,
          ),
          // 루틴 리스트
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.1, vertical: screenHeight * 0.02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "내 루틴",
                  style: TextStyle(
                    fontSize: screenWidth * 0.06,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                _buildRoutineItem(context, "출근길"),
                _buildRoutineItem(context, "본가 가는 길"),
                _buildRoutineItem(context, "퇴근길"),
                _buildRoutineItem(context, "우리 아들 학교 가는 길"),
              ],
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  // 루틴 항목 생성 함수
  Widget _buildRoutineItem(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ElevatedButton(
            onPressed: () {
              // 루틴 버튼 클릭 이벤트
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const RoutineAddScreen()),
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
          ),
          const SizedBox(width: 10),
          TextButton(
            onPressed: () {
              // 수정 버튼 클릭 이벤트
            },
            child: const Text(
              "수정",
              style: TextStyle(color: Colors.black),
            ),
          ),
          const SizedBox(width: 10),
          TextButton(
            onPressed: () {
              // 삭제 버튼 클릭 이벤트
            },
            child: const Text(
              "삭제",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
