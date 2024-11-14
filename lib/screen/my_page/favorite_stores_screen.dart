import 'package:flutter/material.dart';
import 'package:last_nyam/const/colors.dart';

class FavoriteStoresScreen extends StatelessWidget {
  // 더미 데이터
  final List<Map<String, dynamic>> stores = [
    {
      'name': '삼첩분식 옥계점',
      'temperature': '48.5°C',
      'image': null, // 이미지 데이터 없음
      'isFavorite': true,
      'isAlertOn': false,
    },
    {
      'name': '콩자반분식 금오공대점',
      'temperature': '24.5°C',
      'image': null, // 이미지 데이터 없음
      'isFavorite': false,
      'isAlertOn': true,
    },
    {
      'name': '집더하기 옥계점',
      'temperature': '36.5°C',
      'image': null, // 이미지 데이터 없음
      'isFavorite': true,
      'isAlertOn': false,
    },
    {
      'name': '빅마트 옥계점',
      'temperature': '90.5°C',
      'image': null, // 이미지 데이터 없음
      'isFavorite': false,
      'isAlertOn': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 16, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          '관심 매장',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        child: ListView.separated(
          itemCount: stores.length,
          separatorBuilder: (context, index) => Divider(),
          itemBuilder: (context, index) {
            final store = stores[index];
            return ListTile(
              leading: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: store['image'] == null
                    ? Icon(Icons.store, color: Colors.grey)
                    : Image.asset(store['image'], fit: BoxFit.cover),
              ),
              title: Text(
                store['name'],
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                store['temperature'],
                style: TextStyle(color: defaultColors['green']),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      store['isAlertOn']
                          ? Icons.notifications
                          : Icons.notifications_none,
                      color: defaultColors['green'],
                    ),
                    onPressed: () {
                      // 알림 아이콘 클릭 이벤트 처리
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      store['isFavorite']
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: defaultColors['green'],
                    ),
                    onPressed: () {
                      // 즐겨찾기 아이콘 클릭 이벤트 처리
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
