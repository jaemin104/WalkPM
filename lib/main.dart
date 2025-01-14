// import 'package:flutter/material.dart';
// import 'screens/walk_goal.dart';
// import 'screens/routine_select.dart';
// import 'screens/mypage.dart';
// import 'package:provider/provider.dart';
// import 'model/routine_model.dart';
// import 'screens/routine_list.dart';
// import 'screens/routine_add.dart';
// import 'screens/routine_playlist_make.dart';
//
// void main() {
//   runApp(
//     ChangeNotifierProvider(
//       create: (context) => RoutineModel(),
//       child: MyApp(),
//     ),
//   );
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       // debugShowCheckedModeBanner: false,
//       // //home: MainScreen(),
//       // home: WalkGoalScreen(),
//       // theme: ThemeData(
//       //   fontFamily: 'GowunBatang', // 여기서 폰트 적용
//       // ),
//       initialRoute: '/routine_select',
//       routes: {
//         '/routine_select': (context) => RoutineSelectPage(),
//         '/routine_list': (context) => RoutineListPage(),
//         '/routine_add': (context) => RoutineAddPage(),
//         '/routine_playlist_make': (context) => RoutinePlaylistMakePage(
//               routine: ModalRoute.of(context)!.settings.arguments as Routine,
//             ), // arguments 받기
//       },
//     );
//   }
// }
//
// class MainScreen extends StatefulWidget {
//   const MainScreen({Key? key}) : super(key: key);
//
//   @override
//   _MainScreenState createState() => _MainScreenState();
// }
//
// class _MainScreenState extends State<MainScreen> {
//   int _currentIndex = 0; // 현재 선택된 페이지의 인덱스
//
//   // 각 페이지를 리스트로 관리
//   final List<Widget> _pages = [
//     WalkGoalScreen(key: ValueKey('WalkGoalScreen')),
//     RoutineSelectPage(key: ValueKey('RoutineSelectScreen')),
//     MyPageScreen(key: ValueKey('MyPageScreen')),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _pages[_currentIndex], // 현재 선택된 페이지 보여줌
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _currentIndex, // 현재 선택된 인덱스
//         onTap: (index) {
//           setState(() {
//             _currentIndex = index; // 선택된 페이지로 이동
//           });
//         },
//         items: [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.directions_walk),
//             label: 'Walk',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.repeat),
//             label: 'Routine',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: 'MyPage',
//           ),
//         ],
//         backgroundColor: Color(0xFFB99470), // 바텀 네비게이션 바 배경색
//         selectedItemColor: Colors.white, // 선택된 아이콘과 텍스트 색
//         unselectedItemColor: Colors.black, // 선택되지 않은 아이콘과 텍스트 색
//       ),
//     );
//   }
// }
//============================================================
// import 'package:flutter/material.dart';
// import 'screens/walk_goal.dart';
// import 'screens/routine_select.dart';
// import 'screens/mypage.dart';
//
// void main() {
//   runApp(MyApp());
// }

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:spotify/model/routine_model.dart';
// import 'package:spotify/screens/walk_goal.dart';
// import 'package:spotify/screens/routine_select.dart';
// import 'package:spotify/screens/mypage.dart';
// import 'package:spotify/screens/routine_add.dart';
// import 'package:spotify/screens/routine_list.dart';
// import 'package:spotify/screens/routine_playlist_make.dart';
//
// void main() {
//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (context) => RoutineModel()),
//       ],
//       child: MyApp(),
//     ),
//   );
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false, // 디버그 배너 제거
//       theme: ThemeData(
//         fontFamily: 'GowunBatang', // 지정된 폰트 적용
//       ),
//       initialRoute: '/walk_goal',
//       routes: {
//         '/routine_select': (context) => RoutineSelectPage(),
//         '/routine_list': (context) => RoutineListPage(),
//         '/routine_add': (context) => RoutineAddPage(),
//         '/routine_playlist_make': (context) => RoutinePlaylistMakePage(
//               routine: ModalRoute.of(context)!.settings.arguments as Routine,
//             ), // arguments 받기
//       },
//     );
//   }
// }
//
// class MainScreen extends StatefulWidget {
//   const MainScreen({Key? key}) : super(key: key);
//
//   @override
//   _MainScreenState createState() => _MainScreenState();
// }
//
// class _MainScreenState extends State<MainScreen> {
//   int _currentIndex = 0; // 현재 선택된 페이지의 인덱스
//
//   // 각 페이지를 리스트로 관리
//   final List<Widget> _pages = [
//     WalkGoalScreen(), // 첫 페이지
//     RoutineSelectPage(),
//     MyPageScreen(),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: IndexedStack(
//         index: _currentIndex, // 현재 선택된 페이지만 보여줌
//         children: _pages, // 각 페이지 리스트
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _currentIndex, // 현재 선택된 인덱스
//         onTap: (index) {
//           setState(() {
//             _currentIndex = index; // 선택된 페이지로 이동
//           });
//         },
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.directions_walk),
//             label: 'Walk', // 워킹 목표 화면
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.repeat),
//             label: 'Routine', // 루틴 선택 화면
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: 'MyPage', // 마이페이지 화면
//           ),
//         ],
//         backgroundColor: Color(0xFFB99470), // 바텀 네비게이션 바 배경색
//         selectedItemColor: Colors.white, // 선택된 아이콘 및 텍스트 색상
//         unselectedItemColor: Colors.black, // 선택되지 않은 아이콘 및 텍스트 색상
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'screens/walk_goal.dart';
import 'screens/routine_select.dart';
import 'screens/mypage.dart';
import 'package:provider/provider.dart';
import 'model/routine_model.dart';
import 'screens/routine_list.dart';
import 'screens/routine_add.dart';
import 'screens/routine_playlist_make.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => RoutineModel(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // //home: MainScreen(),
      home: MainScreen(),
      theme: ThemeData(
        fontFamily: 'GowunBatang', // 여기서 폰트 적용
      ),
      // initialRoute: '/routine_select',
      routes: {
        '/routine_select': (context) => RoutineSelectPage(),
        '/routine_list': (context) => RoutineListPage(),
        '/routine_add': (context) => RoutineAddPage(),
        '/routine_playlist_make': (context) => RoutinePlaylistMakePage(
              routine: ModalRoute.of(context)!.settings.arguments as Routine,
            ), // arguments 받기
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0; // 현재 선택된 페이지의 인덱스

  // 각 페이지를 리스트로 관리
  final List<Widget> _pages = [
    WalkGoalScreen(key: ValueKey('WalkGoalScreen')),
    RoutineSelectPage(key: ValueKey('RoutineSelectScreen')),
    MyPageScreen(key: ValueKey('MyPageScreen')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex], // 현재 선택된 페이지 보여줌
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex, // 현재 선택된 인덱스
        onTap: (index) {
          setState(() {
            _currentIndex = index; // 선택된 페이지로 이동
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_walk),
            label: 'Walk',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.repeat),
            label: 'Routine',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'MyPage',
          ),
        ],
        backgroundColor: Color(0xFFB99470), // 바텀 네비게이션 바 배경색
        selectedItemColor: Colors.white, // 선택된 아이콘과 텍스트 색
        unselectedItemColor: Colors.black, // 선택되지 않은 아이콘과 텍스트 색
      ),
      floatingActionButton: null,
    );
  }
}
