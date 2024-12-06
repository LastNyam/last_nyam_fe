import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:last_nyam/screen/home_screen.dart';
import 'package:last_nyam/screen/near_by_store/map_screen.dart';
import 'package:last_nyam/screen/order_history_screen.dart';
import 'package:last_nyam/screen/my_page/my_page_screen.dart';
import 'package:provider/provider.dart';

import '../component/provider/user_state.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({Key? key}) : super(key: key);

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> with TickerProviderStateMixin{
  // 사용할 TabController 선언
  TabController? controller;
  final _storage = const FlutterSecureStorage();
  final Dio _dio = Dio();

  @override
  void initState() {
    super.initState();

    controller = TabController(length: 4, vsync: this);

    controller!.addListener(tabListener);
    _checkAutoLogin();

  }

  // Check for auto-login
  Future<void> _checkAutoLogin() async {
    String? token = await _storage.read(key: 'authToken');
    if (token != null) {
      _attemptAutoLogin(token);
    } else {
      print('로그인 기록 없음');
    }
  }

  // Attempt auto-login with saved token
  Future<void> _attemptAutoLogin(String token) async {
    final baseUrl = dotenv.env['BASE_URL']!;
    try {
      final response = await _dio.get(
        '$baseUrl/auth/my-info',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        final userState = Provider.of<UserState>(context, listen: false);
        userState.updateUserName(response.data['data']['nickname']);
        userState.updatePhoneNumber(response.data['data']['phoneNumber']);
        userState
            .updateAcceptMarketing(response.data['data']['acceptMarketing']);
        if (response.data['data']['profileImage'] != null) {
          Uint8List? profileImage = Uint8List.fromList(
              base64Decode(response.data['data']['profileImage']));
          userState.updateProfileImage(profileImage);
        }
        userState.updateOrderCount(response.data['data']['orderCount']);
        userState.updateIsLogin(true);
      } else {
        await _storage.delete(key: 'authToken');
      }
    } catch (e) {
      print('Auto-login failed: $e');
    }
  }

  // listener로 사용할 함수
  tabListener() {
    setState(() {});
  }

  // listener에 등록한 함수 등록 취소
  @override
  dispose(){
    controller!.removeListener(tabListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userState = Provider.of<UserState>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      // 탭 화면을 보여줄 위젯
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller,
        children: renderChildren(),
      ),

      // 아래 탭 네비게이션을 구현하는 매개변수
      bottomNavigationBar: renderBottomNavigation(),
    );
  }

  List<Widget> renderChildren(){
    return [
      HomeScreen(),
      MapScreen(),
      OrderHistoryScreen(),
      MyPageScreen(),
    ];
  }

  BottomNavigationBar renderBottomNavigation() {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      currentIndex: controller!.index,
      onTap: (int index) {
        setState(() {
          controller!.animateTo(index);
        });
      },
      selectedItemColor: const Color(0xFF417C4E), // 선택된 탭의 색상
      unselectedItemColor: const Color(0xFFB9C6BC), // 선택되지 않은 탭의 색상
      selectedLabelStyle: const TextStyle(
        height: 1.0,
        fontSize: 9, // 선택된 라벨 크기
      ),
      unselectedLabelStyle: const TextStyle(
        height: 1.0,
        fontSize: 9, // 선택되지 않은 라벨 크기
      ),
      items: [
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/icon/home.png',
            width: 24,
          ),
          activeIcon: Image.asset(
            'assets/icon/home_fill.png',
            width: 24,
          ),
          label: '홈',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/icon/map.png',
            width: 24,
          ),
          activeIcon: Image.asset(
            'assets/icon/map_fill.png',
            width: 24,
          ),
          label: '주변 매장',
        ),
        BottomNavigationBarItem(
          icon: const Icon(
            Icons.list_alt_rounded,
          ),
          label: '주문 내역',
        ),
        BottomNavigationBarItem(
          icon: const Icon(
            Icons.dining_outlined,
          ),
          label: '마이냠',
        ),
      ],
    );
  }
}