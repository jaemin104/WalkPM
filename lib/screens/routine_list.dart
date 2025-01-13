import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify/model/routine_model.dart';
import 'routine_add.dart';

class RoutineListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final routines = Provider.of<RoutineModel>(context).routines;

    return Scaffold(
      appBar: AppBar(
        title: Text('루틴 목록'),
      ),
      body: ListView.builder(
        itemCount: routines.length,
        itemBuilder: (context, index) {
          final routine = routines[index];
          return ListTile(
            title: Text(routine.title),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    // 수정 버튼 클릭 시 다이얼로그로 루틴 수정
                    _showEditDialog(context, routine, index);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    // 삭제 버튼 클릭 시 해당 루틴 삭제
                    Provider.of<RoutineModel>(context, listen: false)
                        .removeRoutine(index);
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 새 루틴 추가하기 버튼 클릭 시 routine_add.dart로 이동
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RoutineAddPage()),
          );
        },
        child: Icon(Icons.add),
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
          title: Text('루틴 수정'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: '루틴 제목'),
              ),
              TextField(
                controller: durationController,
                decoration: InputDecoration(labelText: '루틴 시간(분)'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // 다이얼로그 닫기
                Navigator.pop(context);
              },
              child: Text('취소'),
            ),
            ElevatedButton(
              onPressed: () {
                final newTitle = titleController.text;
                final newDuration = int.tryParse(durationController.text) ?? 0;

                // 루틴 수정
                Provider.of<RoutineModel>(context, listen: false)
                    .updateRoutine(index, newTitle, newDuration);

                // 다이얼로그 닫기
                Navigator.pop(context);
              },
              child: Text('저장'),
            ),
          ],
        );
      },
    );
  }
}
