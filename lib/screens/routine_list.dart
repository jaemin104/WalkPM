import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify/model/routine_model.dart';
import 'routine_add.dart';

class RoutineListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final routines = Provider.of<RoutineModel>(context).routines;

    return Scaffold(
      backgroundColor: Color(0xFFA9B388),
      appBar: AppBar(
        backgroundColor: Color(0xFFA9B388),
        title: Text(
          '루틴 목록',
          style: TextStyle(color:Color(0xFFFEFAE0),fontWeight: FontWeight.bold,)),
      ),
      body: ListView.builder(
        itemCount: routines.length,
        itemBuilder: (context, index) {
          final routine = routines[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Color(0xfffefae0),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 루틴 제목
                  Expanded(
                    child: Text(
                      routine.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF5C6E4F)
                      ),
                    ),
                  ),
                  // 수정 및 삭제 버튼
                  Row(
                    children: [
                      // 수정 버튼
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _showEditDialog(context, routine, index);
                        },
                      ),
                      // 삭제 버튼
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          Provider.of<RoutineModel>(context, listen: false)
                              .removeRoutine(index);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RoutineAddPage()),
          );
        },
        backgroundColor: const Color(0xfffefae0), // 배경색을 아이보리 색으로 설정
        child: const Icon(
          Icons.add,
          color: Color(0xFF5C6E4F), // 아이콘 색상을 검정으로 설정 (필요에 따라 수정 가능)
        ),
      ),
    );
  }

  // 다이얼로그를 띄워 루틴 수정하는 메서드
  void _showEditDialog(BuildContext context, Routine routine, int index) {
  final TextEditingController titleController =
      TextEditingController(text: routine.title);
  final TextEditingController durationController =
      TextEditingController(text: routine.routineTime.toString());

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: const Color(0xFFA9B388), // 다이얼로그 배경색
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0), // 모서리를 둥글게
        ),
        title: Text(
          '루틴 수정',
          style: const TextStyle(
            color: Color(0xFFEFE5C9), // 텍스트 색상
            fontWeight: FontWeight.bold, // 굵게
            fontSize: 20,
          ),
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: '루틴 제목을 입력하세요', // 힌트 텍스트로 변경
                hintStyle: const TextStyle(
                  color: Color(0xFF5C6E4F), // 힌트 텍스트 색상
                ),
                filled: true,
                fillColor: const Color(0xFFFEFAE0), // 입력 필드 배경색
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(color: Color(0xFF5C6E4F)),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: durationController,
              decoration: InputDecoration(
                hintText: '루틴 시간(분)을 입력하세요', // 힌트 텍스트로 변경
                hintStyle: const TextStyle(
                  color: Color(0xFF5C6E4F), // 힌트 텍스트 색상
                ),
                filled: true,
                fillColor: const Color(0xFFFEFAE0), // 입력 필드 배경색
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
              ),
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Color(0xFF5C6E4F)),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFEFE5C9), // 텍스트 색상
            ),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              final newTitle = titleController.text;
              final newDuration = int.tryParse(durationController.text) ?? 0;

              Provider.of<RoutineModel>(context, listen: false)
                  .updateRoutine(index, newTitle, newDuration);

              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5F6F52), // 버튼 색상
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 12.0,
                horizontal: 16.0,
              ),
            ),
            child: const Text(
              '저장',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFFEFE5C9), // 텍스트 색상
              ),
            ),
          ),
        ],
      );
    },
  );
}
}