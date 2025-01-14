import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify/model/routine_model.dart';

class RoutineSelectPage extends StatelessWidget {
  const RoutineSelectPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final routines = Provider.of<RoutineModel>(context).routines;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFA9B388), // 상단바 색상
        elevation: 0, // 그림자 제거
        actions: [], // 앱바의 actions는 비워둠
      ),
      body: Container(
        color: Color(0xFFA9B388), // 배경색 설정
        child: Column(
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
                    color: Color(0xFFFEFAE0), // 텍스트 색 변경
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween, // 왼쪽과 오른쪽에 배치
                children: [
                  Text(
                    '내 루틴',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFEFAE0),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit, color: Color(0xFFFEFAE0)),
                    onPressed: () {
                      // 수정하기 버튼 클릭 시 routine_list.dart로 이동
                      Navigator.pushNamed(context, '/routine_list');
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16.0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 한 행에 두 개의 버튼
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 2.5, // 버튼의 가로 세로 비율
                ),
                itemCount: routines.length,
                itemBuilder: (context, index) {
                  final routine = routines[index];
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFEEEBD6), // 버튼 배경색
                      elevation: 5, // 버튼 그림자
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15), // 버튼 모서리 둥글게
                      ),
                    ),
                    onPressed: () {
                      // 루틴 제목 버튼 클릭 시 routine_playlist_make.dart로 이동
                      Navigator.pushNamed(context, '/routine_playlist_make',
                          arguments: routine);
                    },
                    child: Text(
                      routine.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF5F6F52),
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
