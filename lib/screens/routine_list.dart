import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify/model/routine_model.dart';
import 'routine_add.dart';

class RoutineListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final routines = Provider.of<RoutineModel>(context).routines;

    return Scaffold(
      backgroundColor: Color(0xFFBDC9A3),
      appBar: AppBar(
        backgroundColor: Color(0xFFBDC9A3),
        title: Text('루틴 목록'),
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
                Navigator.pop(context);
              },
              child: Text('취소'),
            ),
            ElevatedButton(
              onPressed: () {
                final newTitle = titleController.text;
                final newDuration = int.tryParse(durationController.text) ?? 0;

                Provider.of<RoutineModel>(context, listen: false)
                    .updateRoutine(index, newTitle, newDuration);

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