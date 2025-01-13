import 'package:flutter/material.dart';
import 'walk_playlist.dart'; // walk_playlist.dart 파일 가져오기

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
  String _selectedGenre = "선택하기";

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFBDC9A3),
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
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.02),
                Text(
                  "빠르게 추천해 드릴게요!",
                  style: TextStyle(fontSize: screenWidth * 0.05),
                ),
                SizedBox(height: screenHeight * 0.03),
                // 추천 버튼들
                Wrap(
                  spacing: screenWidth * 0.05,
                  runSpacing: screenHeight * 0.02,
                  alignment: WrapAlignment.center,
                  children: [
                    _buildButton("천천히 산책하기"),
                    _buildButton("명상하며 걷기"),
                    _buildButton("신나게 달리기"),
                    _buildButton("1시간 조깅하기"),
                  ],
                ),
                Divider(
                  color: Colors.black54,
                  thickness: 1,
                  indent: screenWidth * 0.1,
                  endIndent: screenWidth * 0.1,
                ),
                // 입력 섹션
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInputSection(
                        "오늘은 얼마나 멀리 가볼까요?",
                        "2 km",
                        _distanceController,
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      _buildInputSection(
                        "오늘은 얼마동안 가볼까요?",
                        "30분",
                        _timeController,
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      _buildGenreSelector(),
                      SizedBox(height: screenHeight * 0.03),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const WalkPlaylistScreen(),
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
                              color: Colors.white,
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

  Widget _buildButton(String text) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const WalkPlaylistScreen(),
          ),
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

  Widget _buildInputSection(
      String label, String placeholder, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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

  Widget _buildGenreSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "오늘은 어떤 장르를 들어볼까요?",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        DropdownButton<String>(
          value: _selectedGenre,
          items: <String>["선택하기", "팝", "재즈", "클래식", "힙합"]
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedGenre = newValue!;
            });
          },
        ),
      ],
    );
  }
}
