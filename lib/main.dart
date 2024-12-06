import 'package:flutter/services.dart';
import 'package:last_nyam/colors.dart';
import 'package:last_nyam/screen/root_screen.dart';
import 'package:flutter/material.dart';
import 'package:last_nyam/const/colors.dart';
import 'package:provider/provider.dart';
import 'package:last_nyam/component/provider/user_state.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load the .env file
  await dotenv.load(fileName: "assets/env/.env");

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // 세로 방향 고정
  ]).then((_) {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => UserState()),
        ],
        child: MyApp(),
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'NanumBarunGothic',
        scaffoldBackgroundColor: AppColors.semiwhite,

        textTheme: ThemeData.light().textTheme.apply(
          fontFamily: 'NanumBarunGothic',
          bodyColor: AppColors.blackColor, // 텍스트 색상
          displayColor: AppColors.blackColor, // 헤더 텍스트 색상
        ),

        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.whiteColor, // AppBar 배경색
          titleTextStyle: TextStyle(
            fontFamily: 'nanumBarunGothic',
            color: AppColors.blackColor,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),

        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.blackColor
          )
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: AppColors.blackColor, // 텍스트 색상
            backgroundColor: AppColors.whiteColor, // 버튼 배경색
            elevation: 0, // 그림자 제거
            textStyle: TextStyle(
              fontFamily: 'nanumBarunGothic',
              fontSize: 16,
            ),
          ),
        ),
        dialogBackgroundColor: AppColors.whiteColor
      ),
      home: RootScreen(),
    );
  }
}
