import 'package:flutter/material.dart';

class RoutinePlaylistApp extends StatelessWidget {
  const RoutinePlaylistApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Routine Playlist',
      home: const RoutinePlaylistScreen(),
    );
  }
}

class RoutinePlaylistScreen extends StatelessWidget {
  const RoutinePlaylistScreen({Key? key}) : super(key: key);

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
          // 상단 로고와 제목
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
                  "내 루틴",
                  style: TextStyle(
                    fontSize: screenWidth * 0.06,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEFE5C9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                  ),
                  child: const Text(
                    "출근길",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                const Text(
                  "출발 | 카이스트 본원 아름관\n도착 | 카이스트 본원 IT융합빌딩\n거리 | 859m\n소요 시간 | 14분",
                  style: TextStyle(fontSize: 16, height: 1.5),
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
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.1, vertical: screenHeight * 0.02),
            child: Text(
              "루틴에 맞는 플레이리스트를 추천해 드릴게요!",
              style: TextStyle(
                  fontSize: screenWidth * 0.05, fontWeight: FontWeight.w500),
            ),
          ),
          // 플레이리스트 추천 섹션
          SizedBox(
            height: screenHeight * 0.25,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3, // 임의로 3개의 플레이리스트 설정
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(
                      left: screenWidth * 0.1,
                      right: index == 2 ? screenWidth * 0.1 : 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: screenWidth * 0.35,
                        height: screenHeight * 0.18,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: AssetImage(
                                "assets/baekyerin.jpeg"), // 이미지 파일 경로
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      const Text(
                        "14분 23초\n기분 좋은, 잔잔한",
                        style: TextStyle(fontSize: 14, height: 1.5),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
