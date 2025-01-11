import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Spotify Web API 관련 기능을 처리하는 서비스 클래스
class SpotifyWebApiService {
  final Function(String, {String? message}) setStatus;
  String? _accessToken;

  SpotifyWebApiService({required this.setStatus});

  /// 인증 토큰을 얻는 메서드
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

  /// 트랙을 검색하는 메서드
  /// [query] 검색할 키워드
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
        return tracks
            .map((track) => {
                  'id': track['id'],
                  'uri': track['uri'],
                  'name': track['name'],
                  'artist': track['artists'][0]['name'],
                  'album': track['album']['name'],
                  'imageUrl': track['album']['images'][0]['url'],
                })
            .toList();
      } else {
        setStatus('Failed to search tracks: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      setStatus('Error searching tracks: $e');
      return [];
    }
  }

  /// 현재 재생 중인 트랙을 라이브러리에 추가하는 메서드
  Future<void> addToLibrary() async {
    try {
      final playerState = await SpotifySdk.getPlayerState();
      if (playerState?.track == null) {
        setStatus('No track is currently playing');
        return;
      }

      await SpotifySdk.addToLibrary(
        spotifyUri: playerState!.track!.uri,
      );
      setStatus('Added ${playerState.track!.name} to library');
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    }
  }
}
