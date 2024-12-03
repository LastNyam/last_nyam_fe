import 'package:flutter/material.dart';
import 'dart:typed_data';

class UserState with ChangeNotifier {
  String password = 'testest';
  String phoneNumber = '';
  String userName = '';
  Uint8List? profileImage = null;
  int orderCount = 0;
  bool acceptMarketing = false;
  bool isLogin = false;

  void initState() {
    password = 'testest';
    phoneNumber = '';
    userName = '';
    profileImage = null;
    orderCount = 0;
    acceptMarketing = false;
    isLogin = false;
    notifyListeners();
  }

  void updatePassword(String newPassword) {
    password = newPassword;
    notifyListeners();
  }

  void updatePhoneNumber(String newPhoneNumber) {
    phoneNumber = newPhoneNumber;
    notifyListeners();
  }

  void updateUserName(String newName) {
    userName = newName;
    notifyListeners();
  }

  void updateProfileImage(Uint8List? newImage) {
    profileImage = newImage;
    notifyListeners();
  }

  void updateOrderCount(int newCount) {
    orderCount = newCount;
    notifyListeners();
  }

  void updateAcceptMarketing(bool newAcceptMarketing) {
    acceptMarketing = newAcceptMarketing;
    notifyListeners();
  }

  void updateIsLogin(bool newLogin) {
    isLogin = newLogin;
    notifyListeners();
  }
}
