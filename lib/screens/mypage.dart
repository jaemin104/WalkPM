import 'package:flutter/material.dart';

class MyPageApp extends StatelessWidget {
  const MyPageApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Page',
      home: const MyPageScreen(),
    );
  }
}

class MyPageScreen extends StatelessWidget {
  const MyPageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFBDC9A3),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 상단 섹션: 사용자 정보
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.05, horizontal: screenWidth * 0.1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: screenWidth * 0.1,
                        backgroundColor: const Color(0xFFEFE5C9),
                        child: Icon(Icons.person,
                            size: screenWidth * 0.1, color: Colors.black),
                      ),
                      SizedBox(width: screenWidth * 0.03),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                          Text(
                            "김재민",
                            style: TextStyle(
                                fontSize: screenWidth * 0.06,
                                fontFamily: 'GowunBatang',
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "kjm041107",
                            style: TextStyle(
                                fontSize: screenWidth * 0.04,
                                fontFamily: 'GowunBatang',
                                color: Colors.grey[700]),
                          ),
                        ],
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // 로그아웃 버튼 클릭 이벤트
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5C6E4F),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text("로그아웃",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'GowunBatang',
                        )),
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
            // 좋아하는 플레이리스트
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.1, vertical: screenHeight * 0.02),
              child: const Text(
                "좋아하는 플레이리스트",
                style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'GowunBatang',
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: screenHeight * 0.25,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 3, // 예시로 3개 설정
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(
                        left: screenWidth * 0.1,
                        right: index == 2 ? screenWidth * 0.1 : 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: screenWidth * 0.35,
                              height: screenHeight * 0.18,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: AssetImage(
                                      "assets/baekyerin.jpeg"), // 이미지 경로 설정
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 5,
                              right: 5,
                              child: Icon(Icons.favorite,
                                  color: Colors.red, size: screenWidth * 0.07),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        const Text(
                          "14분 23초\n기분 좋은, 잔잔한",
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'GowunBatang',
                              height: 1.5),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Divider(
              color: Colors.black54,
              thickness: 1,
              indent: screenWidth * 0.1,
              endIndent: screenWidth * 0.1,
            ),
            // 좋아하는 가수
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.1, vertical: screenHeight * 0.02),
              child: const Text(
                "좋아하는 가수",
                style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'GowunBatang',
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: screenHeight * 0.25,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 3, // 예시로 3개 설정
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(
                        left: screenWidth * 0.1,
                        right: index == 2 ? screenWidth * 0.1 : 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: screenWidth * 0.35,
                              height: screenHeight * 0.18,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: AssetImage(
                                      "assets/baekyerin.jpeg"), // 이미지 경로 설정
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 5,
                              right: 5,
                              child: Icon(Icons.favorite,
                                  color: Colors.red, size: screenWidth * 0.07),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        const Text(
                          "백예린",
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'GowunBatang',
                              height: 1.5),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Divider(
              color: Colors.black54,
              thickness: 1,
              indent: screenWidth * 0.1,
              endIndent: screenWidth * 0.1,
            ),
            // 좋아하는 장르
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.1, vertical: screenHeight * 0.02),
              child: const Text(
                "좋아하는 장르",
                style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'GowunBatang',
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
              child: Wrap(
                spacing: 10,
                children: [
                  _buildGenreButton("발라드"),
                  _buildGenreButton("K-POP"),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // 좋아하는 장르 버튼 생성 함수
  Widget _buildGenreButton(String genre) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFEFE5C9),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
      child: Text(
        genre,
        style: const TextStyle(color: Colors.black),
      ),
    );
  }
}
