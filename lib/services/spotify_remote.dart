import 'package:flutter/services.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Spotify Remote SDK 관련 기능을 처리하는 서비스 클래스
class SpotifyRemoteService {
  final Function(String, {String? message}) setStatus;

  SpotifyRemoteService({required this.setStatus});

  /// Spotify 앱과 연결을 설정하는 메서드
  Future<void> connectToSpotifyRemote() async {
    try {
      final clientId = dotenv.env['CLIENT_ID'];
      final redirectUrl = dotenv.env['REDIRECT_URL'];

      if (clientId == null || redirectUrl == null) {
        setStatus('Failed to load environment variables');
        return;
      }

      var result = await SpotifySdk.connectToSpotifyRemote(
        clientId: clientId,
        redirectUrl: redirectUrl,
      );

      setStatus(result
          ? 'connect to spotify successful'
          : 'connect to spotify failed');
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  /// Spotify 앱과의 연결을 해제하는 메서드
  Future<void> disconnect() async {
    try {
      await SpotifySdk.pause();
      
      var result = await SpotifySdk.disconnect();
      setStatus(result ? 'disconnect successful' : 'disconnect failed');
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  /// 특정 트랙을 재생하는 메서드
  Future<void> play({String? spotifyUri}) async {
    try {
      await SpotifySdk.play(
          spotifyUri: spotifyUri ?? 'spotify:track:58kNJana4w5BIjlZE2wq5m');
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  /// 재생 목록에 트랙을 추가하는 메서드
  Future<void> queue() async {
    try {
      await SpotifySdk.queue(
          spotifyUri: 'spotify:track:58kNJana4w5BIjlZE2wq5m');
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  /// 반복 재생 모드를 전환하는 메서드
  Future<void> toggleRepeat() async {
    try {
      await SpotifySdk.toggleRepeat();
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  /// 셔플 모드를 전환하는 메서드
  Future<void> toggleShuffle() async {
    try {
      await SpotifySdk.toggleShuffle();
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  /// 재생을 일시정지하는 메서드
  Future<void> pause() async {
    try {
      await SpotifySdk.pause();
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  /// 일시정지된 재생을 다시 시작하는 메서드
  Future<void> resume() async {
    try {
      await SpotifySdk.resume();
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  /// 다음 트랙으로 넘어가는 메서드
  Future<void> skipNext() async {
    try {
      await SpotifySdk.skipNext();
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  /// 이전 트랙으로 돌아가는 메서드
  Future<void> skipPrevious() async {
    try {
      await SpotifySdk.skipPrevious();
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }
}
