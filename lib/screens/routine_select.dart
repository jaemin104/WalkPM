import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify/model/routine_model.dart';
import 'package:spotify/screens/routine_playlist.dart';
import 'package:spotify/screens/routine_playlist_make.dart';

class RoutineSelectPage extends StatelessWidget {
  const RoutineSelectPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final routines = Provider.of<RoutineModel>(context).routines;

    return Scaffold(
      appBar: AppBar(
        title: Text('루틴 선택'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              // 수정하기 버튼 클릭 시 routine_list.dart로 이동
              Navigator.pushNamed(context, '/routine_list');
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: routines.length,
        itemBuilder: (context, index) {
          final routine = routines[index];
          return Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ElevatedButton(
              onPressed: () {
                // 루틴 제목 버튼 클릭 시 routine_playlist.dart로 이동
                Navigator.pushNamed(context, '/routine_playlist_make',
                    arguments: routine);
              },
              child: Text(routine.title),
            ),
          );
        },
      ),
    );
  }
}
