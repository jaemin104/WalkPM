import 'package:flutter/material.dart';

class RoutineAddApp extends StatelessWidget {
  const RoutineAddApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Add Routine',
      home: const RoutineAddScreen(),
    );
  }
}

class RoutineAddScreen extends StatelessWidget {
  const RoutineAddScreen({Key? key}) : super(key: key);

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
              ],
            ),
          ),
          // 입력 필드 섹션
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "출발",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: screenHeight * 0.01),
                _buildInputField("카이스트 본원 아름관"),
                SizedBox(height: screenHeight * 0.02),
                const Text(
                  "도착",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: screenHeight * 0.01),
                _buildInputField("카이스트 본원 IT융합빌딩"),
                SizedBox(height: screenHeight * 0.03),
                const Text(
                  "거리는 850m, 소요시간은 14분이네요.\n내 걸음 속도에 맞춰 소요시간을 수정할까요?",
                  style: TextStyle(fontSize: 16, height: 1.5),
                ),
                SizedBox(height: screenHeight * 0.02),
                const Text(
                  "소요시간",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: screenHeight * 0.01),
                Row(
                  children: [
                    _buildInputField("14", widthFactor: 0.2),
                    SizedBox(width: screenWidth * 0.02),
                    const Text(
                      "분",
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.05),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // 완료 버튼 클릭 이벤트
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
                      "완료",
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
          const Spacer(),
        ],
      ),
    );
  }

  // 입력 필드 위젯 생성 함수
  Widget _buildInputField(String hintText, {double widthFactor = 1.0}) {
    return Container(
      width: widthFactor == 1.0 ? double.infinity : 100 * widthFactor,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFEFE5C9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
        ),
      ),
    );
  }
}
