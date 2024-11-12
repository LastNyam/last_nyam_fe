import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:last_nyam/component/provider/user_state.dart';

class NicknameChangeScreen extends StatefulWidget {
  final String currentNickname; // 현재 닉네임을 전달받는 필드

  const NicknameChangeScreen({Key? key, required this.currentNickname})
      : super(key: key);

  @override
  _NicknameChangeScreenState createState() => _NicknameChangeScreenState();
}

class _NicknameChangeScreenState extends State<NicknameChangeScreen> {
  late TextEditingController _nicknameController;

  @override
  void initState() {
    super.initState();
    // 현재 닉네임을 기본값으로 설정
    _nicknameController = TextEditingController(text: widget.currentNickname);
  }

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
          '닉네임 변경',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '새로운 닉네임을 입력해주세요',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _nicknameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
              ),
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // 닉네임 변경 로직
                  String newNickname = _nicknameController.text;
                  print('닉네임 변경: $newNickname');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // 버튼 색상
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: Text(
                  '변경 완료',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
