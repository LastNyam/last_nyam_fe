import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:last_nyam/const/colors.dart';
import 'package:last_nyam/screen/profile_edit_screen.dart';
import 'package:provider/provider.dart';
import 'package:last_nyam/component/provider/user_state.dart';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({super.key});

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  @override
  Widget build(BuildContext context) {
    final userState = Provider.of<UserState>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: defaultColors['white'],
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none, color: defaultColors['black']),
            onPressed: () {},
          ),
        ],
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
                  backgroundImage:
                      AssetImage('${userState.profileImage}'), // 프로필 이미지 경로
                ),
                SizedBox(width: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '냠냠이, ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileEditScreen(),
                          )
                        );
                      },
                      child: Row(
                        children: [
                          Text(
                            '${userState.userName}',
                            style: TextStyle(
                              fontSize: 18,
                              color: defaultColors['green'],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 5),
                          Icon(Icons.chevron_right, size: 18, color: defaultColors['lightGreen']),
                        ],
                      )
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
                )),
            SizedBox(height: 15),
            Divider(),
            SizedBox(height: 15),
            // 메뉴 리스트
            Row(
              children: [
                SizedBox(width:15),
                Text(
                  '냠냠 목록',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: defaultColors['lightGreen']),
                ),
              ],
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: Icon(Icons.favorite_outline, color: defaultColors['black']),
                    title: Text('관심 매장'),
                    trailing: Icon(Icons.chevron_right, color: defaultColors['lightGreen']),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(Icons.history, color: defaultColors['black']),
                    title: Text('최근 본 상품'),
                    trailing: Icon(Icons.chevron_right, color: defaultColors['lightGreen']),
                    onTap: () {},
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.logout, color: defaultColors['black']),
                    title: Text('로그아웃'),
                    trailing: Icon(Icons.chevron_right, color: defaultColors['lightGreen']),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(Icons.person_remove_outlined, color: defaultColors['black']),
                    title: Text('탈퇴'),
                    trailing: Icon(Icons.chevron_right, color: defaultColors['lightGreen']),
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
