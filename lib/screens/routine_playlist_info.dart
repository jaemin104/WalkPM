import 'package:flutter/material.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';

class RoutinePlaylistInfo extends StatefulWidget {
  final List<String> songTitles;

  const RoutinePlaylistInfo({Key? key, required this.songTitles})
      : super(key: key);

  @override
  _RoutinePlaylistInfoState createState() => _RoutinePlaylistInfoState();
}

class _RoutinePlaylistInfoState extends State<RoutinePlaylistInfo> {
  List<Map<String, dynamic>> songDetails = [];
  Map<String, dynamic>? currentTrack; // 현재 재생 중인 곡 정보
  bool isPlaying = false; // 현재 재생 상태를 나타내는 변수
  bool isLiked = false;
  
  @override
  void initState() {
    super.initState();
    connectToSpotifyRemote();
    fetchSongDetails();
  }

  Future<void> connectToSpotifyRemote() async {
    try {
      final clientId = 'd65753df516d432290560b53ddcbdcb5';
      final redirectUrl = 'spotify-sdk://auth';

      final result = await SpotifySdk.connectToSpotifyRemote(
        clientId: clientId,
        redirectUrl: redirectUrl,
      );

      print(result
          ? 'Connected to Spotify successfully'
          : 'Failed to connect to Spotify');
    } on PlatformException catch (e) {
      print('Error connecting to Spotify: ${e.message}');
    } on MissingPluginException {
      print('Spotify SDK is not implemented on this platform.');
    }
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
            'uri': track['uri'], // Spotify URI
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

  Future<void> playSong(String uri) async {
    try {
      print('Attempting to play song with URI: $uri');
      await SpotifySdk.play(spotifyUri: uri);
      print('Playback started successfully');
    } catch (e) {
      print('Error playing song: $e');
    }
  }

  Future<void> pause() async {
    try {
      await SpotifySdk.pause();
      print('Playback paused successfully');
    } catch (e) {
      print('Error pausing playback: $e');
    }
  }

  Future<void> resume() async {
    try {
      await SpotifySdk.resume();
      print('Playback resumed successfully');
    } catch (e) {
      print('Error resuming playback: $e');
    }
  }

  Future<void> queueSong(String uri) async {
    try {
      print('Queuing song with URI: $uri');
      await SpotifySdk.queue(spotifyUri: uri);
      print('Song queued successfully');
    } catch (e) {
      print('Error queuing song: $e');
    }
  }

  Future<void> addSongsToQueue() async {
  for (var song in songDetails) {
    print('Queuing song: ${song['uri']}');
    await queueSong(song['uri']);
  }
  print('All songs added to the queue.');
}

    Future<void> skipNext() async {
    try {
      await SpotifySdk.skipNext();
      print('Skipped to next track successfully');
    } catch (e) {
      print('Error skipping to next track: $e');
    }
  }

  Future<void> skipPrevious() async {
    try {
      await SpotifySdk.skipPrevious();
      print('Skipped to previous track successfully');
    } catch (e) {
      print('Error skipping to previous track: $e');
    }
  }
  Future<void> addToLibrary() async {
    try {
      final playerState = await SpotifySdk.getPlayerState();
      if (playerState?.track == null) {
        return;
      }

      await SpotifySdk.addToLibrary(
        spotifyUri: playerState!.track!.uri,
      );
    } catch (e) {
      print('Error adding to library: $e');
    }
  }

  Future<void> toggleLike() async {
    if (isLiked) {
      print('Unlike functionality is not supported by Spotify SDK.');
    } else {
      await addToLibrary();
    }
    setState(() {
      isLiked = !isLiked;
    });
  }
  
  Future<bool> checkIfLiked(String trackUri) async {
  try {
    final accessToken = await SpotifySdk.getAccessToken(
      clientId: 'd65753df516d432290560b53ddcbdcb5',
      redirectUrl: 'spotify-sdk://auth',
      scope: 'user-library-read',
    );

    final response = await http.get(
      Uri.parse('https://api.spotify.com/v1/me/tracks/contains?ids=${Uri.encodeComponent(trackUri)}'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      return data.isNotEmpty && data[0] == true;
    } else {
      print('Failed to check liked status: ${response.statusCode}');
      return false;
    }
  } catch (e) {
    print('Error checking liked status: $e');
    return false;
  }
}
   @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF9DA58E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF9DA58E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFFEFAE0)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Routine Playlist',
          style: TextStyle(color: Color(0xFFFEFAE0)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (currentTrack != null)
              Column(
                children: [
                  Text(
                    '현재 재생 중인 곡',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Color(0xFFFEFAE0),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Stack(
                    children: [
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: NetworkImage(currentTrack!['imageUrl']),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: IconButton(
                          icon: Icon(
                            isLiked ? Icons.favorite : Icons.favorite_border,
                            color: isLiked ? Colors.red : Colors.white,
                          ),
                          onPressed: toggleLike,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    currentTrack!['title'],
                    style: const TextStyle(
                      fontSize: 20,
                      color: Color(0xFFFEFAE0),
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    currentTrack!['artist'],
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFFFEFAE0),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.skip_previous, color: Color(0xFFFEFAE0)),
                        onPressed: skipPrevious,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (isPlaying) {
                            pause();
                          } else {
                            resume();
                          }
                          setState(() {
                            isPlaying = !isPlaying;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5F6F52),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          isPlaying ? 'Stop' : 'Play',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Color(0xFFFEFAE0),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.skip_next, color: Color(0xFFFEFAE0)),
                        onPressed: skipNext,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            Expanded(
              child: ListView.builder(
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
                      style: const TextStyle(color: Color(0xFFFEFAE0)),
                    ),
                    subtitle: Text(
                      song['artist'],
                      style: const TextStyle(color: Color(0xFFFEFAE0)),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.play_arrow, color: Color(0xFF5F6F52)),
                      onPressed: () async {
                        playSong(song['uri']);
                        setState(() {
                          currentTrack = song;
                          isPlaying = true;
                        });
                        // 좋아요 상태 확인 및 업데이트
                          final likedStatus = await checkIfLiked(song['uri']);
                          setState(() {
                            isLiked = likedStatus;
                          });
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}