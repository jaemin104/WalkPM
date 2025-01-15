import 'package:flutter/material.dart';
import 'package:spotify/model/routine_model.dart';
import 'package:provider/provider.dart';

class RoutineAddPage extends StatefulWidget {
  final Routine? routine; // 기존 루틴 수정 시 사용할 routine
  final int? routineIndex; // 기존 루틴의 인덱스 (수정 시에 필요)

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
      _titleController = TextEditingController(text: widget.routine?.title);
      _timeController =
          TextEditingController(text: widget.routine?.routineTime.toString());
    } else {
      _titleController = TextEditingController();
      _timeController = TextEditingController();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA9B388), // 배경색 변경
      appBar: AppBar(
        title: Text(
          widget.routine != null ? '루틴 수정' : '새 루틴 추가',
          style: const TextStyle(color: Color(0xfffefae0),fontWeight: FontWeight.bold,), // 텍스트 색상
        ),
        backgroundColor: const Color(0xFFA9B388), // 상단바 배경색
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xfffefae0)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '루틴 정보 입력',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xfffefae0), // 제목 텍스트 색상
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: '루틴 제목',
                labelStyle: const TextStyle(color: Color(0xFF5C6E4F)),
                filled: true,
                fillColor: const Color(0xFFEFE5C9),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(color: Color(0xFF5C6E4F)),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _timeController,
              decoration: InputDecoration(
                labelText: '루틴 시간(분)',
                labelStyle: const TextStyle(color: Color(0xFF5C6E4F)),
                filled: true,
                fillColor: const Color(0xFFEFE5C9),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(color: Color(0xFF5C6E4F)),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  final title = _titleController.text;
                  final time = int.tryParse(_timeController.text) ?? 0;

                  if (widget.routine != null) {
                    Provider.of<RoutineModel>(context, listen: false)
                        .updateRoutine(widget.routineIndex!, title, time);
                  } else {
                    Provider.of<RoutineModel>(context, listen: false)
                        .addRoutine(title, time);
                  }

                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5C6E4F), // 버튼 색상
                  padding: const EdgeInsets.symmetric(
                    vertical: 14.0,
                    horizontal: 36.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0), // 둥근 모서리
                  ),
                  elevation: 5, // 그림자 깊이
                ),
                child: Text(
                  widget.routine != null ? '수정하기' : '추가하기',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Color(0xfffefae0),
                    fontWeight: FontWeight.bold // 텍스트 색상
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
