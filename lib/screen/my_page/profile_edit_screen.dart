import 'package:flutter/material.dart';
import 'package:last_nyam/const/colors.dart';
import 'package:last_nyam/screen/my_page/password_change_screen.dart';
import 'package:provider/provider.dart';
import 'package:last_nyam/component/provider/user_state.dart';
import 'package:last_nyam/screen/my_page/nickname_change_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}


class _ProfileEditScreenState extends State<ProfileEditScreen> {
  File? _profileImage; // 선택된 프로필 이미지

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
              GestureDetector(
                onTap: () => _showPhotoOptions(context), // 옵션 창 표시
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: defaultColors['white'],
                      backgroundImage: userState.profileImage != null
                          ? FileImage(userState.profileImage!) // 선택된 이미지
                          : AssetImage('assets/image/profile_image.png') as ImageProvider, // 기본 이미지 프로필 이미지 경로
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
                              builder: (context) => NicknameChangeScreen(
                                  currentNickname: userState.userName),
                            ));
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
                  '비밀번호 변경',
                  style: TextStyle(fontSize: 16),
                ),
                trailing: Icon(Icons.chevron_right, color: grey[350]),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PasswordChangeScreen(),
                      ));
                },
              ),
              // 휴대폰 번호 변경 섹션
              ListTile(
                title: Text(
                  '휴대폰 번호 변경',
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

  // 이미지 선택 동작
  Future<void> _pickImageFromGallery() async {
    final userState = Provider.of<UserState>(context, listen: false);
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);

    print('프사경로');
    print(pickedImage!.path);
    if (pickedImage != null) {
      userState.updateProfileImage(File(pickedImage.path));
    }
  }

  // 기본 이미지 적용
  void _applyDefaultImage() {
    final userState = Provider.of<UserState>(context, listen: false);
    userState.updateProfileImage(null);
  }

  // 프로필 사진 옵션 선택
  void _showPhotoOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '프로필 사진 설정',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              ListTile(
                leading: Icon(Icons.photo_library, color: defaultColors['green']),
                title: Text('앨범에서 사진 선택'),
                onTap: () {
                  Navigator.pop(context); // 옵션 창 닫기
                  _pickImageFromGallery(); // 갤러리에서 사진 선택
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.image, color: defaultColors['green']),
                title: Text('기본 이미지 적용'),
                onTap: () {
                  Navigator.pop(context); // 옵션 창 닫기
                  _applyDefaultImage(); // 기본 이미지 적용
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
