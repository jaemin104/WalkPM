import 'package:flutter/material.dart';
import 'walk_goal_result.dart'; // 결과 화면 import

void main() {
  runApp(const WalkGoalApp());
}

class WalkGoalApp extends StatelessWidget {
  const WalkGoalApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Walk Goal App',
      home: const WalkGoalScreen(),
    );
  }
}

class WalkGoalScreen extends StatefulWidget {
  const WalkGoalScreen({Key? key}) : super(key: key);

  @override
  _WalkGoalScreenState createState() => _WalkGoalScreenState();
}

class _WalkGoalScreenState extends State<WalkGoalScreen> {
  final TextEditingController _distanceController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  double _calculateBPM(double distance, double time) {
    // km/h로 속도 계산
    double speed = distance / (time / 60); // 속도 = 거리 / 시간 (분 단위로 변환)

    // 속도에 따라 BPM 범위 조정
    if (speed < 3.0) {
      return 80.0; // 천천히 걷는 경우
    } else if (speed < 5.0) {
      return 110.0; // 보통 속도
    } else {
      return 130.0; // 빠르게 걷는 경우
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFA9B388),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: screenHeight * 0.05),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // 상단 로고 및 제목 영역
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.music_note, size: screenWidth * 0.1),
                    const SizedBox(width: 10),
                    Text(
                      "WalkPM",
                      style: TextStyle(
                        fontSize: screenWidth * 0.08,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFEFAE0), // 텍스트 색 변경
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.02),
                Text(
                  "빠르게 추천해 드릴게요!",
                  style: TextStyle(
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFEFAE0)), // 텍스트 색 변경
                ),
                SizedBox(height: screenHeight * 0.03),
                // 버튼 4개 배치
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center, // 중앙 정렬
                      children: [
                        _buildSpeedButton("생각하며 걷기", 3.0),
                        SizedBox(width: screenWidth * 0.05), // 버튼 간격
                        _buildSpeedButton("천천히 산책하기", 4.0),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.02), // 버튼 간격
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center, // 중앙 정렬
                      children: [
                        _buildSpeedButton("상쾌하게 조깅하기", 5.5),
                        SizedBox(width: screenWidth * 0.05), // 버튼 간격
                        _buildSpeedButton("빠르게 달리기", 7.0),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.03),
                // 가로선 추가
                Divider(
                  color: Colors.black, // 가로선 색상
                  thickness: 1, // 두께
                  indent: screenWidth * 0.1, // 좌측 여백
                  endIndent: screenWidth * 0.1, // 우측 여백
                ),
                SizedBox(height: screenHeight * 0.03),
                // 입력 섹션
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInputSection(
                        "오늘은 얼마나 멀리 가볼까요?",
                        "거리를 입력하세요.(km)",
                        _distanceController,
                        Color(0xFFFEFAE0), // 텍스트 색 변경
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      _buildInputSection(
                        "오늘은 얼마동안 가볼까요?",
                        "시간을 입력하세요.(분)",
                        _timeController,
                        Color(0xFFFEFAE0), // 텍스트 색 변경
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            double distance =
                                double.tryParse(_distanceController.text) ??
                                    0.0;
                            double time =
                                double.tryParse(_timeController.text) ?? 0.0;

                            // 계산된 BPM을 넘겨서 결과 화면으로 이동
                            double bpm = _calculateBPM(distance, time);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    WalkGoalResultScreen(bpm: bpm),
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
                              vertical: screenHeight * 0.015,
                            ),
                          ),
                          child: Text(
                            "완료",
                            style: TextStyle(
                              fontSize: screenWidth * 0.05,
                              color: Color(0xFFFEFAE0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputSection(String label, String placeholder,
      TextEditingController controller, Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w600, color: textColor),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: placeholder,
            filled: true,
            fillColor: const Color(0xFFEFE5C9),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSpeedButton(String label, double speed) {
    return ElevatedButton(
      onPressed: () {
        // 계산된 BPM을 넘겨서 결과 화면으로 이동
        double bpm = _calculateBPM(0.0, speed); // 거리와 시간을 고려하지 않음
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WalkGoalResultScreen(bpm: bpm),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF5F6F52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 16,
          color: Color(0xFFFEFAE0),
        ),
      ),
    );
  }
}
