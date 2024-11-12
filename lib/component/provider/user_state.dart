import 'package:flutter/material.dart';

class UserState with ChangeNotifier {
  String userName = '컴공피주먹';
  int orderCount = 0;
  String profileImage = 'assets/image/profile_image.png';

  void updateUserName(String newName) {
    userName = newName;
    notifyListeners();
  }

  void updateOrderCount(int newCount) {
    orderCount = newCount;
    notifyListeners();
  }

  void updateProfileImage(String newImage) {
    profileImage = newImage;
    notifyListeners();
  }
}
