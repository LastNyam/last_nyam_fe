import 'package:flutter/material.dart';
import 'package:last_nyam/const/colors.dart';
import 'package:provider/provider.dart';
import 'package:last_nyam/component/provider/user_state.dart';
import 'package:last_nyam/screen/nickname_change_screen.dart';

class ProfileEditScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userState = Provider.of<UserState>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 16, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          '프로필 수정',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              // 프로필 이미지와 편집 아이콘
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: defaultColors['white'],
                    backgroundImage:
                        AssetImage('${userState.profileImage}'), // 프로필 이미지 경로
                  ),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2.0,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor: defaultColors['lightGreen'],
                      child: Icon(
                        Icons.camera_alt,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              // 닉네임 섹션
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '닉네임',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NicknameChangeScreen(currentNickname: userState.userName),
                            )
                        );
                      },
                      child: Row(
                        children: [
                          Text(
                            '${userState.userName}',
                            style: TextStyle(
                              fontSize: 16,
                              color: grey[350],
                            ),
                          ),
                          Icon(Icons.chevron_right, color: grey[350]),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(height: 30, thickness: 1, color: Colors.grey[200]),
              // 비밀번호 변경 섹션
              ListTile(
                title: Text(
                  "비밀번호 변경",
                  style: TextStyle(fontSize: 16),
                ),
                trailing: Icon(Icons.chevron_right, color: grey[350]),
                onTap: () {
                  // 비밀번호 변경 화면으로 이동
                },
              ),
              // 휴대폰 번호 변경 섹션
              ListTile(
                title: Text(
                  "휴대폰 번호 변경",
                  style: TextStyle(fontSize: 16),
                ),
                trailing: Icon(Icons.chevron_right, color: grey[350]),
                onTap: () {
                  // 휴대폰 번호 변경 화면으로 이동
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
