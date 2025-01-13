import 'package:flutter/material.dart';
import 'package:spotify/model/routine_model.dart';
import 'package:provider/provider.dart';

class RoutineAddPage extends StatefulWidget {
  final Routine? routine; // 기존 루틴 수정 시 사용할 routine
  final int? routineIndex; // 기존 루틴의 인덱스 (수정 시에 필요)

  // 새 루틴 추가 시에는 이 두 값은 null로 전달
  RoutineAddPage({Key? key, this.routine, this.routineIndex}) : super(key: key);

  @override
  _RoutineAddPageState createState() => _RoutineAddPageState();
}

class _RoutineAddPageState extends State<RoutineAddPage> {
  late TextEditingController _titleController;
  late TextEditingController _timeController;

  @override
  void initState() {
    super.initState();
    if (widget.routine != null) {
      // 기존 루틴 수정 시, 제목과 시간을 기존 값으로 초기화
      _titleController = TextEditingController(text: widget.routine?.title);
      _timeController =
          TextEditingController(text: widget.routine?.routineTime.toString());
    } else {
      // 새 루틴 추가 시, 텍스트 필드를 비워두기
      _titleController = TextEditingController();
      _timeController = TextEditingController();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.routine != null ? '루틴 수정' : '새 루틴 추가'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: '루틴 제목'),
            ),
            TextField(
              controller: _timeController,
              decoration: InputDecoration(labelText: '루틴 시간(분)'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final title = _titleController.text;
                final time = int.tryParse(_timeController.text) ?? 0;

                if (widget.routine != null) {
                  // 수정된 루틴이 있을 경우
                  Provider.of<RoutineModel>(context, listen: false)
                      .updateRoutine(widget.routineIndex!, title, time);
                } else {
                  // 새 루틴 추가
                  Provider.of<RoutineModel>(context, listen: false)
                      .addRoutine(title, time);
                }

                Navigator.pop(context);
              },
              child: Text(widget.routine != null ? '수정하기' : '추가하기'),
            ),
          ],
        ),
      ),
    );
  }
}
