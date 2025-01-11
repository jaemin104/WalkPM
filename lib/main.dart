import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'package:spotify_sdk/models/connection_status.dart';
import 'package:spotify_sdk/models/image_uri.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

import 'widgets/sized_icon_button.dart';
import 'services/spotify_remote.dart';
import 'services/spotify_web_api.dart';

/// 앱의 시작점. 환경 변수를 로드하고 앱을 실행합니다.
var logger = Logger();

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 이 줄 추가
  
  try {
    await dotenv.load(fileName: ".env");
    
    // Spotify SDK 초기화
    await SpotifySdk.connectToSpotifyRemote(
      clientId: dotenv.env['CLIENT_ID']!,
      redirectUrl: dotenv.env['REDIRECT_URL']!,
    );
    
    logger.d('Spotify SDK 초기화 성공');
  } catch (e) {
    logger.e('초기화 중 오류 발생: $e');
  }
  
  runApp(MyApp());
}
/// 앱의 기본 MaterialApp을 설정하는 위젯
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Material 디자인 3를 적용하고 홈 화면을 설정
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const Home(),
    );
  }
}

/// A [StatefulWidget] which uses:
/// * [spotify_sdk](https://pub.dev/packages/spotify_sdk)
/// to connect to Spotify and use controls.
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  bool _connected = false;
  final Logger _logger = Logger(
    //filter: CustomLogFilter(), // custom logfilter can be used to have logs in release mode
    printer: PrettyPrinter(
      methodCount: 2, // number of method calls to be displayed
      errorMethodCount: 8, // number of method calls if stacktrace is provided
      lineLength: 120, // width of the output
      colors: true, // Colorful log messages
      printEmojis: true, // Print an emoji for each log message
    ),
  );

  late ImageUri? currentTrackImageUri;
  late SpotifyRemoteService _remoteService;
  late SpotifyWebApiService _webApiService;

  @override
  void initState() {
    super.initState();
    _remoteService = SpotifyRemoteService(setStatus: setStatus);
    _webApiService = SpotifyWebApiService(setStatus: setStatus);
  }

  /// Spotify 연결 상태를 관리하고 UI를 구성하는 메인 build 메서드
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ConnectionStatus>(
      stream: SpotifySdk.subscribeConnectionStatus(),
      builder: (context, snapshot) {
        _connected = false;
        var data = snapshot.data;
        if (data != null) {
          _connected = data.connected;
        }
        return Scaffold(
          appBar: AppBar(
            title: const Text('Spotify API Conn'),
            actions: [
              _connected
                  ? IconButton(
                      onPressed: _remoteService.disconnect,
                      icon: const Icon(Icons.exit_to_app),
                    )
                  : Container()
            ],
          ),
          body: _sampleFlowWidget(context),
          bottomNavigationBar: _connected ? _buildBottomBar(context) : null,
        );
      },
    );
  }

  /// 하단 제어 바를 구성하는 메서드
  /// 반복, 셔플, 좋아요 버튼을 포함
  Widget _buildBottomBar(BuildContext context) {
    return BottomAppBar(
      height: 100,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('반복'),
                SizedIconButton(
                  width: 40,
                  icon: Icons.repeat,
                  onPressed: _remoteService.toggleRepeat,
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('셔플'),
                SizedIconButton(
                  width: 40,
                  icon: Icons.shuffle,
                  onPressed: _remoteService.toggleShuffle,
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('좋아요'),
                SizedIconButton(
                  width: 40,
                  onPressed: _webApiService.addToLibrary,
                  icon: Icons.favorite,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 메인 화면의 콘텐츠를 구성하는 메서드
  /// 연결 버튼, 플레이어 상태, 검색 기능을 포함
  Widget _sampleFlowWidget(BuildContext context2) {
    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextButton(
                  onPressed: _remoteService.connectToSpotifyRemote,
                  child: const Row(
                    children: [
                      Icon(Icons.settings_remote),
                      SizedBox(width: 8),
                      Text('앱 연결'),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: _webApiService.getAccessToken,
                  child: const Row(
                    children: [
                      Icon(Icons.api),
                      SizedBox(width: 8),
                      Text('Web API 연결'),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(),
            Text(
              'Player State',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            _connected
                ? _buildPlayerStateWidget()
                : const Center(
                    child: Text('Not connected'),
                  ),
            const Divider(),
            TextField(
              decoration: const InputDecoration(
                labelText: '노래 검색',
                hintText: '검색어를 입력하세요',
                prefixIcon: Icon(Icons.search),
              ),
              onSubmitted: (query) async {
                final tracks = await _webApiService.searchTracks(query);
                if (tracks.isNotEmpty && mounted) {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => ListView.builder(
                      itemCount: tracks.length,
                      itemBuilder: (context, index) {
                        final track = tracks[index];
                        return ListTile(
                          leading: Image.network(track['imageUrl']),
                          title: Text(track['name']),
                          subtitle:
                              Text('${track['artist']} - ${track['album']}'),
                          onTap: () {
                            _remoteService.play(spotifyUri: track['uri']);
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  /// 현재 재생 중인 트랙의 상태를 표시하는 위젯
  /// 재생/일시정지, 이전/다음 곡 버튼과 트랙 정보를 표시
  Widget _buildPlayerStateWidget() {
    return StreamBuilder<PlayerState>(
      stream: SpotifySdk.subscribePlayerState(),
      builder: (BuildContext context, AsyncSnapshot<PlayerState> snapshot) {
        var track = snapshot.data?.track;
        currentTrackImageUri = track?.imageUri;
        var playerState = snapshot.data;

        if (playerState == null || track == null) {
          return Center(
            child: Container(),
          );
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SizedIconButton(
                  width: 50,
                  icon: Icons.skip_previous,
                  onPressed: _remoteService.skipPrevious,
                ),
                playerState.isPaused
                    ? SizedIconButton(
                        width: 50,
                        icon: Icons.play_arrow,
                        onPressed: _remoteService.resume,
                      )
                    : SizedIconButton(
                        width: 50,
                        icon: Icons.pause,
                        onPressed: _remoteService.pause,
                      ),
                SizedIconButton(
                  width: 50,
                  icon: Icons.skip_next,
                  onPressed: _remoteService.skipNext,
                ),
              ],
            ),
            Text(
              'Track',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Text(
              '${track.name} by ${track.artist.name} from the album ${track.album.name}',
              maxLines: 2,
            ),
            _connected
                ? Padding(
                    padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                    child: spotifyImageWidget(track.imageUri),
                  )
                : const Text('Connect to see an image...'),
          ],
        );
      },
    );
  }

  /// 앨범 아트 이미지를 표시하는 위젯
  /// 로딩 상태와 에러 처리를 포함
  Widget spotifyImageWidget(ImageUri image) {
    return FutureBuilder(
        future: SpotifySdk.getImage(
          imageUri: image,
          dimension: ImageDimension.large,
        ),
        builder: (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
          if (snapshot.hasData) {
            return Image.memory(snapshot.data!);
          } else if (snapshot.hasError) {
            setStatus(snapshot.error.toString());
            return SizedBox(
              width: ImageDimension.large.value.toDouble(),
              height: ImageDimension.large.value.toDouble(),
              child: const Center(child: Text('Error getting image')),
            );
          } else {
            return SizedBox(
              width: ImageDimension.large.value.toDouble(),
              height: ImageDimension.large.value.toDouble(),
              child: const Center(child: Text('Getting image...')),
            );
          }
        });
  }

  /// 디버깅을 위한 로그 출력 함수
  void setStatus(String code, {String? message}) {
    var text = message ?? '';
    _logger.i('$code$text');
  }
}
