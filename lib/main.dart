import 'package:last_nyam/screen/root_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'nanumBarunGothic',
      ),
      home: RootScreen(),
    ),
  );
}
