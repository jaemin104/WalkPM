import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Routine {
  String title;
  int routineTime; // 루틴 시간

  Routine({required this.title, required this.routineTime});

  // JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'routineTime': routineTime,
    };
  }

  // JSON에서 객체로 변환하는 메서드
  factory Routine.fromJson(Map<String, dynamic> json) {
    return Routine(
      title: json['title'],
      routineTime: json['routineTime'],
    );
  }
}

class RoutineModel with ChangeNotifier {
  List<Routine> _routines = [];

  List<Routine> get routines => _routines;

  RoutineModel() {
    _loadRoutines(); // 모델 초기화 시 데이터 로드
  }

  // 루틴 추가
  void addRoutine(String title, int routineTime) async {
    _routines.add(Routine(title: title, routineTime: routineTime));
    await _saveRoutines(); // 루틴 추가 후 저장
    notifyListeners();
  }

  // 루틴 업데이트
  void updateRoutine(int index, String title, int routineTime) async {
    _routines[index] = Routine(title: title, routineTime: routineTime);
    await _saveRoutines(); // 루틴 업데이트 후 저장
    notifyListeners();
  }

  // 루틴 삭제
  void removeRoutine(int index) async {
    _routines.removeAt(index);
    await _saveRoutines(); // 루틴 삭제 후 저장
    notifyListeners();
  }

  // SharedPreferences에 저장된 루틴 데이터 로드
  Future<void> _loadRoutines() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? routinesJson = prefs.getStringList('routines');
    if (routinesJson != null) {
      _routines = routinesJson
          .map((routineJson) => Routine.fromJson(json.decode(routineJson)))
          .toList();
    }
    notifyListeners();
  }

  // SharedPreferences에 루틴 데이터 저장
  Future<void> _saveRoutines() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> routinesJson = _routines.map((routine) {
      return json.encode(routine.toJson());
    }).toList();
    await prefs.setStringList('routines', routinesJson);
  }
}