import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:last_nyam/component/provider/user_state.dart';
import 'package:last_nyam/const/colors.dart';

class PhoneNumberChangeScreen extends StatefulWidget {
  @override
  _PhoneNumberChangeScreenState createState() =>
      _PhoneNumberChangeScreenState();
}

class _PhoneNumberChangeScreenState extends State<PhoneNumberChangeScreen> {
  final _phoneNumberController = TextEditingController();
  final _verifyController = TextEditingController();
  final _dio = Dio();
  final _storage = const FlutterSecureStorage();

  bool _isPhoneNumberValid = false;
  bool _isVerifyValid = false;
  bool _isValid = false;
  bool _availableVerify = false;
  String? _phoneNumberError;
  String? _verifyError;

  @override
  Widget build(BuildContext context) {
    final userState = Provider.of<UserState>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "휴대폰 번호 변경",
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
      resizeToAvoidBottomInset: true,
      // 키패드로 인해 화면 크기 조정 허용
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight, // 화면 크기 유지
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPasswordField(
                        controller: _phoneNumberController,
                        label: "휴대폰 번호를 입력해주세요.",
                        type: 'phoneNumber',
                        hintText: "010-1234-5678",
                        errorText: _phoneNumberError,
                      ),
                      SizedBox(height: _phoneNumberError == null ? 15.0 : 5.0),
                      GestureDetector(
                        child: Text(
                          '인증번호 전송',
                          style: TextStyle(
                              fontSize: 14.0, color: Colors.grey[400]),
                        ),
                        onTap: () async {
                          _validatePhoneNumber();
                          if (!_isPhoneNumberValid) {
                            return;
                          }

                          try {
                            String phoneNumber = _phoneNumberController.text;
                            final baseUrl = dotenv.env['BASE_URL'];
                            final response = await _dio
                                .post('$baseUrl/auth/send-code/phone', data: {
                              'phoneNumber': phoneNumber,
                            });

                            if (response.statusCode == 200) {
                              setState(() {
                                _availableVerify = true;
                              });
                            }
                          } catch (e) {
                            print('인증번호 전송 실패: $e');
                            setState(() {
                              _availableVerify = false;
                            });
                          }
                        },
                      ),
                      if (_availableVerify) SizedBox(height: 20.0),
                      if (_availableVerify)
                        _buildPasswordField(
                          controller: _verifyController,
                          label: "인증번호를 입력해주세요.",
                          type: 'verify',
                          errorText: _verifyError,
                        ),
                      if (_availableVerify) SizedBox(height: 15.0),
                      if (_availableVerify)
                        !_isVerifyValid
                            ? GestureDetector(
                                child: Text(
                                  '인증번호 확인',
                                  style: TextStyle(
                                      fontSize: 14.0, color: Colors.grey[400]),
                                ),
                                onTap: () async {
                                  _validatePhoneNumber();
                                  if (!_isPhoneNumberValid) {
                                    return;
                                  }

                                  try {
                                    String phoneNumber =
                                        _phoneNumberController.text;
                                    String verification =
                                        _verifyController.text;
                                    final baseUrl = dotenv.env['BASE_URL'];
                                    final response = await _dio.post(
                                        '$baseUrl/auth/check/phone',
                                        data: {
                                          'phoneNumber': phoneNumber,
                                          'verification': verification,
                                        });

                                    if (response.statusCode == 200) {
                                      setState(() {
                                        _isVerifyValid = true;
                                      });
                                      _validateForm();
                                    }
                                  } catch (e) {
                                    print('인증번호 확인 실패: $e');
                                    _verifyError = '인증번호가 일치하지 않습니다.';
                                  }
                                },
                              )
                            : Text(
                                '인증 완료되었습니다.',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.lightBlue),
                              ),
                      Spacer(), // 빈 공간 확보
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {
              if (!_isValid) {
                return;
              }

              String phoneNumber = _phoneNumberController.text;

              try {
                final baseUrl = dotenv.env['BASE_URL'];
                final token = await _storage.read(key: 'authToken');
                final response = await _dio.patch('$baseUrl/auth/phone',
                    data: {
                      'phoneNumber': phoneNumber,
                    },
                    options:
                        Options(headers: {'Authorization': 'Bearer $token'}));

                if (response.statusCode == 200) {
                  print('휴대폰 번호 변경 완료');
                  Navigator.pop(context);
                }
              } catch (e) {
                print('휴대폰 번호 변경 실패: $e');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _isValid
                  ? defaultColors['green']
                  : defaultColors['lightGreen'], // 버튼 색상
              padding: EdgeInsets.symmetric(vertical: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0), // Border radius 설정
              ),
            ),
            child: Text(
              '변경 완료',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
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
          obscureText: type == 'phoneNumber' || type == 'verify' ? false : true,
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
            if (type == 'phoneNumber') {
              _validatePhoneNumber();
            }
          },
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              errorText,
              style: TextStyle(color: defaultColors['green'], fontSize: 12),
            ),
          ),
      ],
    );
  }

  bool validatePhoneNumber(String phoneNumber) {
    RegExp phoneNumberRegex = RegExp(
      r'^01[0-9]{1}-[0-9]{3,4}-[0-9]{4}$',
    );
    return phoneNumberRegex.hasMatch(phoneNumber);
  }

  void _validatePhoneNumber() {
    setState(() {
      String phoneNumber = _phoneNumberController.text;

      if (validatePhoneNumber(phoneNumber)) {
        _isPhoneNumberValid = true;
        _phoneNumberError = null;
      } else {
        _isPhoneNumberValid = false;
        _phoneNumberError = '유효한 휴대폰 번호가 아닙니다.';
      }
    });

    _validateForm();
  }

  void _validateForm() {
    setState(() {
      _isValid = _isPhoneNumberValid && _isVerifyValid;
    });
  }
}
