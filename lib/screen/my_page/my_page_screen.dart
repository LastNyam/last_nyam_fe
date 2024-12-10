import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:last_nyam/const/colors.dart';
import 'package:last_nyam/screen/my_page/favorite_stores_screen.dart';
import 'package:last_nyam/screen/my_page/profile_edit_screen.dart';
import 'package:last_nyam/screen/my_page/login_screen.dart';
import 'package:last_nyam/screen/my_page/recent_viewed_products_screen.dart';
import 'package:provider/provider.dart';
import 'package:last_nyam/component/provider/user_state.dart';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({super.key});

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  final _storage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    final userState = Provider.of<UserState>(context);
    print(userState.profileImage);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: defaultColors['white'],
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 15),
            // 프로필 이미지와 사용자 정보
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: defaultColors['white'],
                  backgroundImage: userState.profileImage != null
                      ? MemoryImage(userState.profileImage!)
                      : AssetImage('assets/image/profile_image.png')
                          as ImageProvider, // 기본 이미지 프로필 이미지 경로
                ),
                SizedBox(width: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      !userState.isLogin ? '' : '냠냠이, ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (!userState.isLogin) {
                          // AccessToken이 없는 경우 로그인 페이지로 이동
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                              // builder: (context) => ProfileEditScreen(),
                            ),
                          );
                        } else {
                          // AccessToken이 있는 경우 프로필 편집 화면으로 이동
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfileEditScreen(),
                            ),
                          );
                        }
                      },
                      child: Row(
                        children: [
                          Text(
                            !userState.isLogin
                                ? '로그인하고 냠냠 시작하기' // 로그인 메시지
                                : '${userState.userName}', // 사용자 이름 표시
                            style: TextStyle(
                              fontSize: 16,
                              color: defaultColors['green'],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 5),
                          Icon(
                            Icons.chevron_right,
                            size: 18,
                            color: defaultColors['lightGreen'],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            // 알림 텍스트
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: defaultColors['pureWhite'],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '지금까지 ',
                    style: TextStyle(fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "${userState.orderCount}",
                    style: TextStyle(
                      fontSize: 18,
                      color: defaultColors['green'],
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    '건의 음식 폐기를 막았어요.',
                    style: TextStyle(fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            Divider(),
            SizedBox(height: 15),
            // 메뉴 리스트
            Row(
              children: [
                SizedBox(width: 15),
                Text(
                  '냠냠 목록',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: defaultColors['lightGreen'],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: Icon(Icons.favorite_outline,
                        color: defaultColors['black']),
                    title: Text('관심 매장'),
                    trailing: Icon(Icons.chevron_right,
                        color: defaultColors['lightGreen']),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FavoriteStoresScreen(),
                        ),
                      );
                    },
                  ),
                  Divider(),
                  if (userState.isLogin)
                    ListTile(
                      leading:
                          Icon(Icons.logout, color: defaultColors['black']),
                      title: Text('로그아웃'),
                      trailing: Icon(Icons.chevron_right,
                          color: defaultColors['lightGreen']),
                      onTap: () => _showLogoutDialog(context),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final userState = Provider.of<UserState>(context, listen: false);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.keyboard_arrow_down_sharp,
                    size: 36.0, color: defaultColors['lightGreen']),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              Text(
                '로그아웃하면 \'라스트 냠\'의 기능을 이용하지 못합니다.\n정말 로그아웃하시겠습니까?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await _storage.delete(key: 'authToken');
                  userState.initState();
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: defaultColors['green'],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text(
                  '로그아웃',
                  style: TextStyle(
                    fontSize: 16,
                    color: defaultColors['white'],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
