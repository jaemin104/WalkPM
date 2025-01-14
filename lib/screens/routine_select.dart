import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify/model/routine_model.dart';

class RoutineSelectPage extends StatelessWidget {
  const RoutineSelectPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final routines = Provider.of<RoutineModel>(context).routines;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF9CAF88), // 상단바 색상
        elevation: 0, // 그림자 제거
        title: Row(
          children: [
            Icon(
              Icons.music_note,
              size: 30,
              color: Colors.black,
            ),
            SizedBox(width: 8),
            Text(
              'WalkPM',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.black),
            onPressed: () {
              // 수정하기 버튼 클릭 시 routine_list.dart로 이동
              Navigator.pushNamed(context, '/routine_list');
            },
          ),
        ],
      ),
      body: Container(
        color: Color(0xFF9CAF88), // 배경색 설정
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '내 루틴',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
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
                        color: Colors.black,
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
