import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:last_nyam/const/colors.dart';

class FavoriteStoresScreen extends StatefulWidget {
  @override
  _FavoriteStoresScreenState createState() => _FavoriteStoresScreenState();
}

class _FavoriteStoresScreenState extends State<FavoriteStoresScreen> {
  final _dio = Dio();
  final _storage = const FlutterSecureStorage();
  late List<Map<String, dynamic>> _storeList;

  // 더미 데이터
  List<Map<String, dynamic>> dummyStores = [
    {
      'name': '삼첩분식 옥계점',
      'temperature': '48.5°C',
      'image': null, // 이미지 데이터 없음
      'isFavorite': true,
    },
    {
      'name': '콩자반분식 금오공대점',
      'temperature': '24.5°C',
      'image': null, // 이미지 데이터 없음
      'isFavorite': false,
    },
    {
      'name': '집더하기 옥계점',
      'temperature': '36.5°C',
      'image': null, // 이미지 데이터 없음
      'isFavorite': true,
    },
    {
      'name': '빅마트 옥계점',
      'temperature': '90.5°C',
      'image': null, // 이미지 데이터 없음
      'isFavorite': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _getStores();
  }

  void _getStores() async {
    // final baseUrl = dotenv.env['BASE_URL'];
    // String? token = await _storage.read(key: 'authToken');
    // final response = await _dio.get(
    //   '$baseUrl/store/like',
    //   options: Options(
    //     headers: {'Authorization': 'Bearer $token'},
    //   ),
    // );
    //
    // if (response.statusCode == 200) {
    //   _storeList = response.data;
    // }
  }

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
          itemCount: dummyStores.length,
          separatorBuilder: (context, index) => Divider(),
          itemBuilder: (context, index) {
            final store = dummyStores[index];
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
                      store['isFavorite']
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: defaultColors['green'],
                    ),
                    onPressed: () async {
                      final baseUrl = dotenv.env['BASE_URL'];
                      String? token =
                          await _storage.read(key: 'authToken');
                      final response = await _dio.post(
                        '$baseUrl/store/like',
                        data: {
                          'storeId': store['storeId'],
                        },
                        options: Options(
                          headers: {
                            'Authorization': 'Bearer $token'
                          },
                        ),
                      );

                      if (response.statusCode == 200) {
                        setState(() {
                          store['isFavorite'] = !store['isFavorite'];
                        });
                      }
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
