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

  Future<List<Map<String, dynamic>>> getSongsByBPMRange(double bpm) async {
    // bpm을 double로 수정
    final songs = await loadSongs();
    // BPM 범위 ±5 적용 (bpm은 double 타입으로 처리)
    return songs.where((song) {
      double songBPM = song["Tempo"].toDouble(); // Tempo 값도 double로 변환
      return songBPM >= bpm - 5 && songBPM <= bpm + 5;
    }).toList();
  }
}
