import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:spotify_sdk/spotify_sdk.dart';

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
  String userId = '';
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
          userId = data['id'] ?? 'Unknown ID';
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
 //들은 탑 아티스트가 아닌 팔로우한 아티스트로 바꿈!
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
      final items = data['artists']['items'] as List; // 수정된 부분

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


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFBDC9A3),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserInfoSection(screenWidth, screenHeight),
            _buildDivider(screenWidth),
            _buildLikedSongsSection(screenWidth, screenHeight),
            _buildDivider(screenWidth),
            _buildTopArtistsSection(screenWidth, screenHeight),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfoSection(double screenWidth, double screenHeight) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: screenHeight * 0.05,
        horizontal: screenWidth * 0.1,
      ),
      child: Row(
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
          SizedBox(width: screenWidth * 0.03),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: TextStyle(
                  fontSize: screenWidth * 0.06,
                  fontFamily: 'GowunBatang',
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                overflow: TextOverflow.ellipsis,
                userId,
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  fontFamily: 'GowunBatang',
                  color: Colors.grey[700],
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
      String title, List<Map<String, dynamic>> items, double screenWidth, double screenHeight) {
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
      String name, String imageUrl, double screenWidth, double screenHeight) {
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
          SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'GowunBatang',
              height: 1.5,
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
