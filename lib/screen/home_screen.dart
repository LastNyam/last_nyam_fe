import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:last_nyam/component/home/category.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime firstDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Expanded(
        child: Category(),
      )
    );
  }
}
