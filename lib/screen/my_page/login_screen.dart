import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:last_nyam/component/provider/user_state.dart';
import 'package:last_nyam/const/colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneNumberController = TextEditingController();
  final _passwordController = TextEditingController();
  final _storage = const FlutterSecureStorage(); // Secure Storage instance
  final Dio _dio = Dio();

  bool _isPhoneNumberValid = false;
  bool _isPasswordValid = false;
  bool _isValid = false;
  String? _phoneNumberError;
  String? _passwordError;

  @override
  void initState() {
    super.initState();
    _checkAutoLogin();
  }

  // Check for auto-login
  Future<void> _checkAutoLogin() async {
    String? token = await _storage.read(key: 'authToken');
    if (token != null) {
      _attemptAutoLogin(token);
    }
  }

  // Attempt auto-login with saved token
  Future<void> _attemptAutoLogin(String token) async {
    final baseUrl = dotenv.env['BASE_URL']!;
    try {
      final response = await _dio.get(
        '$baseUrl/auto-login',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        // Update user state
        final userState = Provider.of<UserState>(context, listen: false);
        userState.updatePhoneNumber(response.data['phoneNumber']);
        userState.updateAccessToken(token);

        // Navigate to main screen
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        await _storage.delete(key: 'authToken');
      }
    } catch (e) {
      print('Auto-login failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final userState = Provider.of<UserState>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "로그인",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 16, color: Colors.black),
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
                controller: _phoneNumberController,
                label: "휴대폰 번호를 입력해주세요",
                type: 'phoneNumber',
                hintText: "휴대폰 번호를 입력하세요.",
                errorText: _phoneNumberError,
              ),
              const SizedBox(height: 20),
              _buildPasswordField(
                controller: _passwordController,
                label: "비밀번호를 입력해주세요",
                hintText: "비밀번호를 입력하세요.",
                type: 'password',
                errorText: _passwordError,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isValid ? () => _login(userState) : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isValid
                        ? defaultColors['green']
                        : defaultColors['lightGreen'],
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  child: const Text(
                    '로그인',
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
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: type == 'password' ? true : false,
          decoration: InputDecoration(
            filled: true,
            fillColor: defaultColors['white'],
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.grey),
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
          ),
          onChanged: (value) {
            if (type == 'phoneNumber') {
              _validatePhoneNumber();
            } else if (type == 'password') {
              _validatePassword();
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

  Future<void> _login(UserState userState) async {
    final baseUrl = dotenv.env['BASE_URL']!;
    try {
      final response = await _dio.post(
        '$baseUrl/auth/login',
        data: {
          'phoneNumber': _phoneNumberController.text.trim(),
          'password': _passwordController.text.trim(),
        },
      );

      if (response.statusCode == 200 && response.data['token'] != null) {
        String token = response.data['token'];

        // Save token in secure storage
        await _storage.write(key: 'authToken', value: token);

        // Update user state
        userState.updatePhoneNumber(_phoneNumberController.text.trim());
        userState.updateAccessToken(token);

        // Navigate to main screen
        Navigator.pop(context);
      } else {
        throw Exception('로그인 실패');
      }
    } catch (e) {
      print('로그인 실패: ${e}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('로그인 실패. 다시 시도해주세요.')),
      );
    }
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

  bool validatePhoneNumber(String phoneNumber) {
    RegExp phonenumberRegex = RegExp(
      r'^01[0-9]{1}-[0-9]{3,4}-[0-9]{4}$',
    );
    return phonenumberRegex.hasMatch(phoneNumber);
  }

  void _validatePassword() {
    setState(() {
      String password = _passwordController.text;

      if (password.length >= 6) {
        _isPasswordValid = true;
        _passwordError = null;
      } else {
        _isPasswordValid = false;
        _passwordError = '비밀번호는 최소 6자리여야 합니다.';
      }
    });

    _validateForm();
  }

  void _validateForm() {
    setState(() {
      _isValid = _isPhoneNumberValid && _isPasswordValid;
    });
  }
}
