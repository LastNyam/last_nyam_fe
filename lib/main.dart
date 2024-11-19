import 'package:last_nyam/screen/root_screen.dart';
import 'package:flutter/material.dart';
import 'package:last_nyam/const/colors.dart';
import 'package:provider/provider.dart';
import 'package:last_nyam/component/provider/user_state.dart';

void main() async {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserState()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'nanumBarunGothic',
        scaffoldBackgroundColor: defaultColors['white'],
      ),
      home: RootScreen(),
    );
  }
}
