import 'dart:convert';
import 'package:flutter/services.dart';

class JsonService {
  Future<List<Map<String, dynamic>>> loadSongs() async {
    // JSON 파일 읽기
    final String jsonString = await rootBundle.loadString('assets/songs.json');
    final List<dynamic> jsonData = json.decode(jsonString);

    // Map 형식으로 변환
    return jsonData.map((e) => e as Map<String, dynamic>).toList();
  }

  Future<List<Map<String, dynamic>>> getSongsByBPM(int bpm) async {
    final songs = await loadSongs();
    return songs.where((song) => song["Tempo"] == bpm).toList();
  }
}
