import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:last_nyam/component/provider/user_state.dart';
import 'package:last_nyam/const/colors.dart';

class PasswordChangeScreen extends StatefulWidget {
  @override
  _PasswordChangeScreenState createState() => _PasswordChangeScreenState();
}

class _PasswordChangeScreenState extends State<PasswordChangeScreen> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isCurrentPasswordValid = false;
  bool _isNewPasswordValid = false;
  bool _isConfirmPasswordValid = false;
  bool _isValid = false;
  String? _currentPasswordError;
  String? _newPasswordError;
  String? _confirmPasswordError;

  @override
  Widget build(BuildContext context) {
    final userState = Provider.of<UserState>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "비밀번호 변경",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 16, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPasswordField(
                controller: _currentPasswordController,
                label: "현재 비밀번호를 입력해주세요",
                type: 'current',
                hintText: "비밀번호를 입력하세요.",
                errorText: _currentPasswordError,
              ),
              SizedBox(height: 80),
              _buildPasswordField(
                controller: _newPasswordController,
                label: "새 비밀번호를 입력해주세요",
                hintText: "비밀번호를 입력하세요.",
                type: 'new',
                errorText: _newPasswordError,
              ),
              SizedBox(height: 20),
              _buildPasswordField(
                controller: _confirmPasswordController,
                label: "확인을 위해 다시 비밀번호를 입력해주세요",
                hintText: "비밀번호를 입력하세요.",
                type: 'confirm',
                errorText: _confirmPasswordError,
              ),
              Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _validateCurrentPassword();
                    if (!_isCurrentPasswordValid) {
                      return;
                    }

                    String newPassword = _newPasswordController.text.trim();
                    if (newPassword.isNotEmpty && _isValid) {
                      userState.updatePassword(newPassword);
                      print('비밀번호 변경 완료: $newPassword');
                      Navigator.pop(context); // 변경 후 이전 화면으로 이동
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isValid
                        ? defaultColors['green']
                        : defaultColors['lightGreen'], // 버튼 색상
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(5.0), // Border radius 설정
                    ),
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
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required String type,
    String? hintText,
    String? errorText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: defaultColors['white'],
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(
                color:
                    errorText == null ? Colors.transparent : Color(0xff417c4e),
                width: 2.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(
                color:
                    errorText == null ? Colors.transparent : Color(0xff417c4e),
                width: 2.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(
                color:
                    errorText == null ? Colors.transparent : Color(0xff417c4e),
                width: 2.0,
              ),
            ),
            errorText: null, // 아래 커스텀 메시지로 대체
          ),
          onChanged: (value) {
            print(type);
            if ('$type' == 'new') {
              _validateNewPassword();
            } else if ('$type' == 'confirm') {
              _validateConfirmPassword();
            }
          },
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              errorText,
              style: TextStyle(color: defaultColors['green'], fontSize: 14),
            ),
          ),
      ],
    );
  }

  void _validateCurrentPassword() {
    setState(() {
      String currentPassword = _currentPasswordController.text;
      final userState = Provider.of<UserState>(context, listen: false);

      if (currentPassword == userState.password) {
        _isCurrentPasswordValid = true;
        _currentPasswordError = null;
      } else {
        _isCurrentPasswordValid = false;
        _currentPasswordError = '비밀번호가 일치하지 않습니다. 다시 입력해주세요.';
      }
    });

    _validateForm();
  }

  void _validateNewPassword() {
    setState(() {
      String newPassword = _newPasswordController.text;

      if (validateNewPassword(newPassword)) {
        _isNewPasswordValid = true;
        _newPasswordError = null;
      } else {
        _isNewPasswordValid = false;
        _newPasswordError = '10자 이상 영어 대문자, 소문자, 숫자, 특수문자 중 2종류를 조합해야 합니다.';
      }
    });

    _validateForm();
  }

  bool validateNewPassword(String newPassword) {
    RegExp newPasswordRegex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z]|.*[0-9]|.*[!@#\$%^&*(),.?":{}|<>])[a-zA-Z0-9!@#\$%^&*(),.?":{}|<>]{10,}$',
    );
    return newPasswordRegex.hasMatch(newPassword);
  }

  void _validateConfirmPassword() {
    setState(() {
      String confirmPassword = _confirmPasswordController.text;

      if (confirmPassword == _newPasswordController.text) {
        _isConfirmPasswordValid = true;
        _confirmPasswordError = null;
      } else {
        _isConfirmPasswordValid = false;
        _confirmPasswordError = '비밀번호가 일치하지 않습니다. 다시 입력해주세요.';
      }
    });

    _validateForm();
  }

  void _validateForm() {
    setState(() {
      if (_isNewPasswordValid && _isConfirmPasswordValid) {
        _isValid = true;
      }
    });
  }
}
