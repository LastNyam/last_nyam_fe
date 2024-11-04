import 'package:flutter/material.dart';
import 'package:last_nyam/const/categories.dart';
import 'package:last_nyam/const/colors.dart';

class Category extends StatefulWidget {
  const Category({super.key});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  String selectedType = 'all';

  @override
  Widget build(BuildContext context) {
    // 화면 높이의 10% 계산
    double widgetHeight = MediaQuery.of(context).size.height * 0.1;

    return Container(
      height: widgetHeight, // Category 위젯 전체 높이를 화면의 10%로 설정
      alignment: Alignment.center, // 버튼들을 중앙에 정렬
      child: Wrap(
        alignment: WrapAlignment.center, // 가로 정렬을 중앙으로 설정
        spacing: 10.0, // 버튼 사이의 가로 간격
        runSpacing: 10.0, // 줄 간의 세로 간격
        children: categories.map((category) {
          bool isSelected = category.type == selectedType;

          return ElevatedButton(
            onPressed: () {
              setState(() {
                selectedType = category.type;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isSelected ? defaultColors['green'] : defaultColors['white'],
            ),
            child: Text(
              category.text,
              style: TextStyle(
                color: isSelected ? defaultColors['white'] : defaultColors['lightGreen'],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
