import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class NewWalkGoalScreen extends StatefulWidget {
  @override
  _NewWalkGoalScreenState createState() => _NewWalkGoalScreenState();
}

class _NewWalkGoalScreenState extends State<NewWalkGoalScreen> {
  final TextEditingController _distanceController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];

  void _searchSongsBySpeed() async {
    // 거리와 시간 입력값 가져오기
    final double distance =
        double.tryParse(_distanceController.text) ?? 0.0; // km
    final double time = double.tryParse(_timeController.text) ?? 0.0; // 분

    // 시간 값이 0이면 검색하지 않음
    if (time == 0) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: const Text("시간은 0이 될 수 없습니다."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("확인"),
            ),
          ],
        ),
      );
      return;
    }

    // 속도 계산
    final double speed = distance / (time / 60); // km/h
    int minBPM = 0, maxBPM = 0;

    // 속도에 따른 BPM 범위 설정
    if (speed >= 3 && speed < 5) {
      minBPM = 60;
      maxBPM = 90;
    } else if (speed >= 5 && speed < 6) {
      minBPM = 90;
      maxBPM = 120;
    } else if (speed >= 6 && speed < 9) {
      minBPM = 120;
      maxBPM = 160;
    } else if (speed >= 9) {
      minBPM = 160;
      maxBPM = 200;
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: const Text("입력한 거리와 시간으로 계산된 속도가 너무 낮습니다."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("확인"),
            ),
          ],
        ),
      );
      return;
    }

    // JsonService로 노래 검색
    final results = await JsonService().getSongsByBPMRange(minBPM, maxBPM);

    // 검색 결과 업데이트
    setState(() {
      _searchResults = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('새로운 걷기 목표 설정'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _distanceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: '거리 (km)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _timeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: '시간 (분)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _searchSongsBySpeed,
              child: const Text('검색'),
            ),
            const SizedBox(height: 16),
            if (_searchResults.isNotEmpty) ...[
              const Text(
                '추천 곡들:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final song = _searchResults[index];
                    return ListTile(
                      title: Text(song['title']),
                      subtitle: Text('BPM: ${song['Tempo']}'),
                    );
                  },
                ),
              ),
            ] else if (_searchResults.isEmpty) ...[
              const Text('추천 곡을 찾을 수 없습니다.'),
            ],
          ],
        ),
      ),
    );
  }
}

class JsonService {
  Future<List<Map<String, dynamic>>> loadSongs() async {
    final String jsonString = await rootBundle.loadString('assets/songs.json');
    final List<dynamic> jsonData = json.decode(jsonString);
    return jsonData.map((e) => e as Map<String, dynamic>).toList();
  }

  Future<List<Map<String, dynamic>>> getSongsByBPMRange(
      int minBPM, int maxBPM) async {
    final songs = await loadSongs();
    return songs.where((song) {
      final bpm = song['Tempo'] as double?;
      return bpm != null && bpm >= minBPM && bpm <= maxBPM;
    }).toList();
  }
}