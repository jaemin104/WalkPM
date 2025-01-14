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
        print(tracks);
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
  //genre로 아티스트 검색하기
 Future<List<Map<String, dynamic>>> searchArtistsByGenre(String genre) async {
  if (_accessToken == null) {
    _accessToken = await getAccessToken();
    if (_accessToken == null) {
      throw Exception('Failed to get access token');
    }
  }

  try {
    final response = await http.get(
      Uri.parse('https://api.spotify.com/v1/search?q=$genre&type=artist&limit=20'),
      headers: {
        'Authorization': 'Bearer $_accessToken',
      },
    );

    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final artists = data['artists']['items'] as List;
      
      print("Artists fetched: ${artists.length}");
      return artists.map((artist) => {
        'id': artist['id'],
        'name': artist['name'],
        'genres': artist['genres'],
        'imageUrl': artist['images']?.isNotEmpty == true
            ? artist['images'][0]['url']
            : null,
      }).toList();
    } else {
      print("Failed to fetch artists. Status code: ${response.statusCode}");
      print("Error: ${response.body}");
      throw Exception('Failed to load artists for genre: $genre');
    }
  } catch (e) {
    print("Error occurred: $e");
    throw Exception('Failed to load artists for genre: $genre');
  }
}
//특정 가수의 노래 가져오기!
Future<List<Map<String, dynamic>>> getTopTracks(String artistId) async {
  if (_accessToken == null) {
    _accessToken = await getAccessToken();
    if (_accessToken == null) {
      throw Exception('Failed to get access token');
    }
  }
  //가수 노래 ID로 가져오기
  final response = await http.get(
    Uri.parse('https://api.spotify.com/v1/artists/$artistId/top-tracks?market=KR'),
    headers: {
      'Authorization': 'Bearer $_accessToken',
    },
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final tracks = data['tracks'] as List;
    return tracks.map((track) => {
      'id': track['id'],          // 트랙 ID
      'name': track['name'],      // 트랙 이름
      'previewUrl': track['preview_url'], // 미리듣기 URL (옵션)
      'uri': track['uri'],        // Spotify URI
    }).toList();
  } else {
    print("Failed to fetch top tracks: ${response.statusCode}");
    throw Exception('Failed to fetch top tracks for artist: $artistId');
  }
}
///노래 제목으로 노래 가져오기
Future<List<Map<String, dynamic>>> fetchTracksByTitle(String trackTitle) async {
  final response = await http.get(
    Uri.parse('https://api.spotify.com/v1/search?q=$trackTitle&type=track&limit=1'),
    headers: {
      'Authorization': 'Bearer $_accessToken',
    },
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final tracks = data['tracks']['items'] as List;

    return tracks.map((track) => {
      'id': track['id'],            // 트랙 ID
      'name': track['name'],        // 트랙 이름
      'artist': track['artists'][0]['name'], // 첫 번째 가수 이름
      'previewUrl': track['preview_url'],   // 미리듣기 URL (옵션)
      'uri': track['uri'],          // Spotify URI
      'imageUrl': track['album']['images'][0]['url'], // 앨범 이미지
    }).toList();
  } else {
    print("Failed to fetch tracks by title: ${response.statusCode}");
    throw Exception('Failed to fetch tracks for title: $trackTitle');
  }
}

///좋아요 한 목록 가져오기
Future<List<Map<String, dynamic>>> getLikedTracks() async {
  if (_accessToken == null) {
    _accessToken = await getAccessToken();
    if (_accessToken == null) {
      throw Exception('Failed to get access token');
    }
  }

  try {
    final response = await http.get(
      Uri.parse('https://api.spotify.com/v1/me/tracks?limit=50'),
      headers: {
        'Authorization': 'Bearer $_accessToken',
      },
    );
    print('liked is working');
    // 상태 코드 및 응답 출력
    print('API Response Status Code: ${response.statusCode}');
    print('API Response Body: ${response.body}');
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
        final tracks = data['tracks']['items'] as List;
        print(tracks);
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
      print('Error: API returned status code ${response.statusCode}');
      return [];
    }
  } catch (e) {
    print('Error in getLikedTracks: $e');
    return [];
  }
}

}