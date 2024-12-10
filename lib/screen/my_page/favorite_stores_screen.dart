import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:last_nyam/const/colors.dart';
import 'package:last_nyam/screen/near_by_store/loading.dart';
import 'package:provider/provider.dart';

import '../../component/provider/user_state.dart';

class FavoriteStoresScreen extends StatefulWidget {
  @override
  _FavoriteStoresScreenState createState() => _FavoriteStoresScreenState();
}

class _FavoriteStoresScreenState extends State<FavoriteStoresScreen> {
  final _dio = Dio();
  final _storage = const FlutterSecureStorage();
  List<dynamic> _storeList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getStores();
  }

  void _getStores() async {
    try {
      final baseUrl = dotenv.env['BASE_URL'];
      String? token = await _storage.read(key: 'authToken');
      final response = await _dio.get(
        '$baseUrl/store/like',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          _storeList = response.data['data'];
        });
      }

      setState(() {
        _isLoading = false;
      });
    } on DioError catch (e) {
      print('관심 매장 조회 실패: ${e.response?.data}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final userState = Provider.of<UserState>(context);
    print(_storeList);

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
      body: !userState.isLogin
          ? Container()
          : _isLoading
              ? LoadingScreen()
              : Container(
                  color: Colors.white,
                  child: ListView.separated(
                    itemCount: _storeList.length,
                    separatorBuilder: (context, index) => Divider(),
                    itemBuilder: (context, index) {
                      final store = _storeList[index];
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
                              : Image.memory(Uint8List.fromList(base64Decode(store['image']))),
                        ),
                        title: Text(
                          store['storeName'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          store['temperature'].toString(),
                          style: TextStyle(color: defaultColors['green']),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.favorite,
                                color: defaultColors['green'],
                              ),
                              onPressed: () async {
                                try {
                                  final baseUrl = dotenv.env['BASE_URL'];
                                  String? token =
                                  await _storage.read(key: 'authToken');
                                  final response = await _dio.delete(
                                    '$baseUrl/store/${store['storeId']}/like',
                                    data: {
                                      'storeId': store['storeId'],
                                    },
                                    options: Options(
                                      headers: {'Authorization': 'Bearer $token'},
                                    ),
                                  );

                                  if (response.statusCode == 200) {
                                    _getStores();
                                  }
                                } on DioError catch(e) {
                                  print('관심매장 삭제 실패: ${e.response?.data}');
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
