import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SpotifyWebApiService {
  final Function(String, {String? message}) setStatus;
  String? _accessToken;

  SpotifyWebApiService({required this.setStatus});

  // 인증 토큰을 얻는 메서드
  Future<String?> getAccessToken() async {
    try {
      var authenticationToken = await SpotifySdk.getAccessToken(
          clientId: dotenv.env['CLIENT_ID'].toString(),
          redirectUrl: dotenv.env['REDIRECT_URL'].toString(),
          scope: 'app-remote-control, '
              'user-modify-playback-state, '
              'playlist-read-private, '
              'playlist-modify-public,user-read-currently-playing, '
              'user-library-modify, '
              'user-library-read');
      setStatus('Got a token: $authenticationToken');
      _accessToken = authenticationToken;
      return authenticationToken;
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
      return null;
    } on MissingPluginException {
      setStatus('not implemented');
      return null;
    }
  }

  // 트랙을 검색하는 메서드
  Future<List<Map<String, dynamic>>> searchTracks(String query) async {
    if (_accessToken == null) {
      _accessToken = await getAccessToken();
      if (_accessToken == null) {
        setStatus('Failed to get access token');
        return [];
      }
    }

    try {
      final response = await http.get(
        Uri.parse(
            'https://api.spotify.com/v1/search?q=$query&type=track&limit=5'),
        headers: {
          'Authorization': 'Bearer $_accessToken',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final tracks = data['tracks']['items'] as List;

        // 각 트랙의 'duration_ms' 추가
        return await Future.wait(tracks.map((track) async {
          final trackId = track['id'];
          final trackDetails = await getTrackDetails(trackId);

          return {
            'id': track['id'],
            'uri': track['uri'],
            'name': track['name'],
            'artist': track['artists'][0]['name'],
            'album': track['album']['name'],
            'imageUrl': track['album']['images'][0]['url'],
            'duration': trackDetails['duration_ms'] != null
                ? trackDetails['duration_ms'] / 1000 // 밀리초를 초로 변환
                : 0,
          };
        }).toList());
      } else {
        setStatus('Failed to search tracks: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      setStatus('Error searching tracks: $e');
      return [];
    }
  }

  // 트랙의 세부 정보를 가져오는 메서드 (duration_ms 포함)
  Future<Map<String, dynamic>> getTrackDetails(String trackId) async {
    try {
      final response = await http.get(
        Uri.parse('https://api.spotify.com/v1/tracks/$trackId'),
        headers: {
          'Authorization': 'Bearer $_accessToken',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'duration_ms': data['duration_ms'], // 재생 시간 (밀리초)
        };
      } else {
        setStatus('Failed to get track details: ${response.statusCode}');
        return {};
      }
    } catch (e) {
      setStatus('Error getting track details: $e');
      return {};
    }
  }
}
