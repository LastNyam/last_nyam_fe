import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:last_nyam/const/colors.dart';
import 'package:dio/dio.dart';

class StoreDetailScreen extends StatefulWidget {
  final String storeId;
  final String storeName;

  StoreDetailScreen({required this.storeId, required this.storeName});

  @override
  _StoreDetailScreenState createState() => _StoreDetailScreenState();
}

class _StoreDetailScreenState extends State<StoreDetailScreen> {
  List<dynamic> storeData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchStoreData();
  }

  Future<void> _fetchStoreData() async {
    try {
      final baseUrl = dotenv.env['BASE_URL'];
      final response = await Dio().get('$baseUrl/food/store/${widget.storeId}');
      print(response.data['data']);
      if (response.statusCode == 200) {
        setState(() {
          storeData = response.data['data'];
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load store data');
      }
    } catch (e) {
      print('Error fetching store data: $e');
    }
  }

  String _getTimeDifference(String inputTimeString) {
    DateTime inputTime = DateTime.parse(inputTimeString);

    // 현재 시간
    DateTime currentTime = DateTime.now();

    // 시간 차이 계산
    Duration difference = currentTime.difference(inputTime);

    // 분 단위와 시간 단위로 변환
    int differenceInMinutes = difference.inMinutes;
    int differenceInHours = difference.inHours;

    // 출력 메시지
    String result;
    if (differenceInMinutes < 60) {
      result = "$differenceInMinutes 분 전";
    } else {
      result = "$differenceInHours 시간 전";
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 16, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          widget.storeName,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: storeData.length,
              itemBuilder: (context, index) {
                final item = storeData[index];
                return Container(
                  margin: EdgeInsets.only(bottom: 16),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 텍스트 정보
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item["foodCategory"],
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              item["foodName"],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  '${(((item["discountPrice"]) / (item['originPrice'])) * 100).toInt()}%',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: defaultColors['green'],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  item["originPrice"].toString(),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.access_time,
                                    size: 16, color: Colors.grey),
                                SizedBox(width: 4),
                                Text(
                                  _getTimeDifference(item['endTime']),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 16),
                      // 이미지
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: item['image'] != null
                            ? Image.memory(
                                Uint8List.fromList(
                                    base64Decode(item["image"])), // 이
                                width: 80,
                                height: 80, // 미지 경로
                              )
                            : Container(
                                width: 80,
                                height: 80,
                                color: Colors.grey,
                              ),
                      ),
                    ],
                  ),
                );
              },
            ),
      backgroundColor: Colors.grey[200],
    );
  }
}
