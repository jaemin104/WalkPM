import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RoutinePlaylistInfo(),
    );
  }
}

class RoutinePlaylistInfo extends StatelessWidget {
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RoutinePlaylist()),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '70~79BPM의 노래 4곡으로 14분 30초짜리\n출근길용 플레이리스트를 만들었어요.',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: Image.asset(
                      'assets/baekyerin.jpeg', // 이미지 경로 설정
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF76876B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      '재생',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildSongTile(
                    context,
                    '산책',
                    '백예린',
                    '71BPM',
                    '3분 34초',
                    'assets/baekyerin.jpeg',
                  ),
                  _buildSongTile(
                    context,
                    'Madeleine Love',
                    'CHEEZE(치즈)',
                    '79BPM',
                    '3분 34초',
                    'assets/baekyerin.jpeg',
                  ),
                  _buildSongTile(
                    context,
                    'Home',
                    '박효신',
                    '75BPM',
                    '3분 34초',
                    'assets/baekyerin.jpeg',
                  ),
                  _buildSongTile(
                    context,
                    'Antifreeze',
                    '백예린',
                    '76BPM',
                    '3분 34초',
                    'assets/baekyerin.jpeg',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSongTile(BuildContext context, String title, String artist,
      String bpm, String duration, String imagePath) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.asset(
          imagePath,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          color: Colors.white,
        ),
      ),
      subtitle: Text(
        artist,
        style: TextStyle(
          fontSize: 14,
          color: Colors.white70,
        ),
      ),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            bpm,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
          Text(
            duration,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}

class RoutinePlaylist extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Routine Playlist Page'),
      ),
    );
  }
}
