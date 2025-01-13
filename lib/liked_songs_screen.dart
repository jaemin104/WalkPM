import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:spotify_sdk/spotify_sdk.dart';

class LikedSongsScreen extends StatefulWidget {
  @override
  _LikedSongsScreenState createState() => _LikedSongsScreenState();
}

class _LikedSongsScreenState extends State<LikedSongsScreen> {
  List<Map<String, dynamic>> _likedSongs = [];
  String? _accessToken;

  @override
  void initState() {
    super.initState();
    _fetchLikedSongs();
  }

  Future<void> _fetchLikedSongs() async {
    try {
      _accessToken = await SpotifySdk.getAccessToken(
        clientId: 'd65753df516d432290560b53ddcbdcb5',
        redirectUrl: 'spotify-sdk://auth',
        scope: 'user-library-read',
      );

      final response = await http.get(
        Uri.parse('https://api.spotify.com/v1/me/tracks'),
        headers: {
          'Authorization': 'Bearer $_accessToken',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final items = data['items'] as List;
        setState(() {
          _likedSongs = items.map((item) {
            final track = item['track'];
            return {
              'name': track['name'],
              'artist': track['artists'][0]['name'],
              'imageUrl': track['album']['images'][0]['url'],
            };
          }).toList();
        });
      } else {
        print('Failed to fetch liked songs: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching liked songs: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Liked Songs')),
      body: _likedSongs.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _likedSongs.length,
              itemBuilder: (context, index) {
                final song = _likedSongs[index];
                return ListTile(
                  leading: Image.network(song['imageUrl']),
                  title: Text(song['name']),
                  subtitle: Text(song['artist']),
                );
              },
            ),
    );
  }
}
