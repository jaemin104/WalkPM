// walk_goal_result.dart

import 'package:flutter/material.dart';
import 'package:spotify/services/json_service.dart'; // JsonService 경로 수정

class WalkGoalResultScreen extends StatefulWidget {
  final double bpm;

  const WalkGoalResultScreen({Key? key, required this.bpm}) : super(key: key);

  @override
  _WalkGoalResultScreenState createState() => _WalkGoalResultScreenState();
}

class _WalkGoalResultScreenState extends State<WalkGoalResultScreen> {
  late Future<List<Map<String, dynamic>>> _songs;

  @override
  void initState() {
    super.initState();
    // BPM에 맞는 노래를 가져옴
    _songs = JsonService().getSongsByBPM(widget.bpm.toInt());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBDC9A3),
      appBar: AppBar(
        title: const Text("추천 노래 리스트"),
        backgroundColor: const Color(0xFF5C6E4F),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              "추천 BPM: ${widget.bpm.toStringAsFixed(0)} BPM",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // BPM에 맞는 노래 리스트
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _songs,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text("추천된 노래가 없습니다.");
                } else {
                  final songs = snapshot.data!;
                  return Expanded(
                    child: ListView.builder(
                      itemCount: songs.length,
                      itemBuilder: (context, index) {
                        final song = songs[index];
                        return ListTile(
                          title: Text(song['title'] ?? 'Unknown Song'),
                          subtitle:
                              Text('BPM: ${song['Tempo'] ?? 'Unknown BPM'}'),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
