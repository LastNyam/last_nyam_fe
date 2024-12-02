import 'package:flutter/material.dart';
import 'package:last_nyam/const/colors.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: defaultColors['green'],
          ),
          SizedBox(height: 20),
          Text(
            "현재 위치를 불러오는 중입니다...",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
