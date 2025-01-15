import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:flutter/services.dart';


void main() => runApp(const MyPageApp());

class MyPageApp extends StatelessWidget {
  const MyPageApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Page',
      home: const MyPageScreen(),
    );
  }
}

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({Key? key}) : super(key: key);

  @override
  _MyPageScreenState createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  List<Map<String, dynamic>> likedSongs = [];
  List<Map<String, dynamic>> topArtists = [];
  String userName = '';
  String profileImageUrl = '';
  String? accessToken;

  @override
  void initState() {
    super.initState();
    fetchUserDataAndContent();
  }

  Future<void> fetchAccessToken() async {
    if (accessToken == null) {
      try {
        accessToken = await SpotifySdk.getAccessToken(
          clientId: 'd65753df516d432290560b53ddcbdcb5',
          redirectUrl: 'spotify-sdk://auth',
          scope: 'user-read-private,user-read-email,user-library-read,user-top-read,user-follow-read',
        );
      } catch (e) {
        print('Error fetching access token: $e');
      }
    }
  }

  Future<void> fetchUserDataAndContent() async {
    await fetchAccessToken();
    if (accessToken != null) {
      await fetchUserData();
      await fetchLikedSongs();
      await fetchTopArtists();
    }
  }

  Future<void> fetchUserData() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.spotify.com/v1/me'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          userName = data['display_name'] ?? 'Unknown User';
          profileImageUrl = data['images'] != null && data['images'].isNotEmpty
              ? data['images'][0]['url']
              : '';
        });
      } else {
        print('Failed to fetch user data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> fetchLikedSongs() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.spotify.com/v1/me/tracks'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final items = data['items'] as List;

        setState(() {
          likedSongs = items.map((item) {
            final track = item['track'];
            return {
              'name': track['name'],
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

  Future<void> fetchTopArtists() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.spotify.com/v1/me/following?type=artist&limit=10'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final items = data['artists']['items'] as List;

        setState(() {
          topArtists = items.map((item) {
            return {
              'name': item['name'],
              'imageUrl': item['images'][0]['url'],
            };
          }).toList();
        });
      } else {
        print('Failed to fetch top artists: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching top artists: $e');
    }
  }

  Future<void> disconnect() async {
  try {
    await SpotifySdk.pause();
    var result = await SpotifySdk.disconnect();
    setStatus(result ? 'Disconnect successful' : 'Disconnect failed');
  } on PlatformException catch (e) {
    setStatus('PlatformException occurred', code: e.code);
  } on MissingPluginException {
    setStatus('Not implemented');
  }
}


  void setStatus(String message, {String? code}) {
  print('Status: $message${code != null ? ', Code: $code' : ''}');
}


@override
Widget build(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;

  return Scaffold(
    backgroundColor: const Color(0xFFBDC9A3),
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Spacer(), 
        _buildUserInfoSection(screenWidth, screenHeight),
        _buildDivider(screenWidth), // 프로필과 좋아하는 플레이리스트 사이 선 추가
        _buildLikedSongsSection(screenWidth, screenHeight),
        _buildDivider(screenWidth), // 좋아하는 플레이리스트와 좋아하는 가수 사이 선 추가
        _buildTopArtistsSection(screenWidth, screenHeight),
        const SizedBox(height: 20), // 하단 여백 추가
      ],
    ),
  );
}

Widget _buildUserInfoSection(double screenWidth, double screenHeight) {
  return Padding(
    padding: EdgeInsets.only(
      top: screenHeight * 0.03,
      bottom: screenHeight * 0.02,
      left: screenWidth * 0.1,
      right: screenWidth * 0.1,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: screenWidth * 0.1,
              backgroundImage: profileImageUrl.isNotEmpty
                  ? NetworkImage(profileImageUrl)
                  : null,
              backgroundColor: const Color(0xFFEFE5C9),
              child: profileImageUrl.isEmpty
                  ? Icon(
                      Icons.person,
                      size: screenWidth * 0.1,
                      color: Colors.black,
                    )
                  : null,
            ),
            SizedBox(width: screenWidth * 0.08), // 사진과 이름 사이 간격
            Text(
              userName,
              style: TextStyle(
                fontSize: screenWidth * 0.06,
                fontFamily: 'GowunBatang',
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _buildLikedSongsSection(double screenWidth, double screenHeight) {
  return _buildContentSection(
    "좋아하는 플레이리스트",
    likedSongs,
    screenWidth,
    screenHeight,
  );
}

Widget _buildTopArtistsSection(double screenWidth, double screenHeight) {
  return _buildContentSection(
    "좋아하는 가수",
    topArtists,
    screenWidth,
    screenHeight,
  );
}

Widget _buildContentSection(
  String title,
  List<Map<String, dynamic>> items,
  double screenWidth,
  double screenHeight,
) {
  return Padding(
    padding: EdgeInsets.symmetric(
      horizontal: screenWidth * 0.1,
      vertical: screenHeight * 0.02,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontFamily: 'GowunBatang',
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: screenHeight * 0.02),
        SizedBox(
          height: screenHeight * 0.25,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return _buildContentItem(
                item['name'],
                item['imageUrl'],
                screenWidth,
                screenHeight,
              );
            },
          ),
        ),
      ],
    ),
  );
}

Widget _buildContentItem(
  String name,
  String imageUrl,
  double screenWidth,
  double screenHeight,
) {
  return Padding(
    padding: EdgeInsets.only(right: screenWidth * 0.05),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: screenWidth * 0.35,
          height: screenHeight * 0.18,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: NetworkImage(imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: screenWidth * 0.35, // 사진 크기와 동일한 너비로 제한
          child: Text(
            name,
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'GowunBatang',
              height: 1.5,
            ),
            maxLines: 2, // 최대 두 줄로 제한
            overflow: TextOverflow.ellipsis, // 내용이 넘칠 경우 "..." 처리
            softWrap: true, // 자동 줄바꿈 허용
          ),
        ),
      ],
    ),
  );
}

Widget _buildDivider(double screenWidth) {
  return Divider(
    color: Colors.black54,
    thickness: 1,
    indent: screenWidth * 0.1,
    endIndent: screenWidth * 0.1,
  );
}
}