import 'package:flutter/material.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RoutinePlaylistInfo extends StatefulWidget {
  final List<String> songTitles;

  const RoutinePlaylistInfo({Key? key, required this.songTitles})
      : super(key: key);

  @override
  _RoutinePlaylistInfoState createState() => _RoutinePlaylistInfoState();
}

class _RoutinePlaylistInfoState extends State<RoutinePlaylistInfo> {
  List<Map<String, dynamic>> songDetails = []; // 검색된 노래 정보 저장

  @override
  void initState() {
    super.initState();
    fetchSongDetails(); // 검색 결과 가져오기
  }

  Future<void> fetchSongDetails() async {
    final accessToken = await SpotifySdk.getAccessToken(
      clientId: 'd65753df516d432290560b53ddcbdcb5',
      redirectUrl: 'spotify-sdk://auth',
      scope: 'user-read-private,user-library-read',
    );
    if (accessToken == null) {
      print('Failed to get access token');
      return;
    }

    for (String title in widget.songTitles) {
      final result = await searchTrack(title, accessToken);
      if (result != null) {
        setState(() {
          songDetails.add(result);
        });
      }
    }
  }

  Future<Map<String, dynamic>?> searchTrack(
      String trackName, String accessToken) async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://api.spotify.com/v1/search?q=$trackName&type=track&limit=1'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final tracks = data['tracks']['items'] as List;
        if (tracks.isNotEmpty) {
          final track = tracks[0];
          return {
            'title': track['name'],
            'artist': track['artists'][0]['name'],
            'imageUrl': track['album']['images'][0]['url'],
            'uri': track['uri'],
          };
        }
      } else {
        print('Failed to search "$trackName": ${response.statusCode}');
      }
    } catch (e) {
      print('Error searching "$trackName": $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF9DA58E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF9DA58E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Routine Playlist'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: songDetails.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: songDetails.length,
                itemBuilder: (context, index) {
                  final song = songDetails[index];
                  return ListTile(
                    leading: Image.network(
                      song['imageUrl'],
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(
                      song['title'],
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      song['artist'],
                      style: const TextStyle(color: Colors.white70),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.play_arrow, color: Colors.green),
                      onPressed: () {
                        playSong(song['uri']); // 재생
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }

  Future<void> playSong(String uri) async {
    try {
      await SpotifySdk.play(spotifyUri: uri);
    } catch (e) {
      print('Error playing song: $e');
    }
  }
}
