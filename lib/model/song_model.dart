import 'package:flutter/material.dart';

class Song {
  String title;
  double tempo; // Tempo (BPM을 double로 처리)
  int durationMs; // 재생 시간 (밀리초 단위)

  Song({required this.title, required this.tempo, required this.durationMs});

  // JSON에서 Song 객체로 변환하는 팩토리 메서드
  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      title: json['title'],
      tempo: json['Tempo'], // Tempo는 실수형으로 변환
      durationMs: json['duration_ms'], // duration_ms는 밀리초 단위
    );
  }

  // Song 객체를 JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'Tempo': tempo,
      'duration_ms': durationMs,
    };
  }
}