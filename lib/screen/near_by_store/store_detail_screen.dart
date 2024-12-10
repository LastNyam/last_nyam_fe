import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:last_nyam/const/colors.dart';
import 'package:dio/dio.dart';
import 'package:last_nyam/screen/content_detail.dart';
import 'package:last_nyam/model/product.dart';

class StoreDetailScreen extends StatefulWidget {
  final String storeId;
  final String storeName;

  StoreDetailScreen({required this.storeId, required this.storeName});

  @override
  _StoreDetailScreenState createState() => _StoreDetailScreenState();
}

class _StoreDetailScreenState extends State<StoreDetailScreen> {
  List<Product> products = []; // Product 타입으로 변경
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
      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        setState(() {
          products = data.map((item) => Product.fromJson(item)).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load store data');
      }
    } catch (e) {
      print('Error fetching store data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  String _getTimeDifference(String inputTimeString) {
    DateTime inputTime = DateTime.parse(inputTimeString);
    DateTime currentTime = DateTime.now();
    Duration difference = currentTime.difference(inputTime);

    int differenceInMinutes = difference.inMinutes;
    int differenceInHours = difference.inHours;

    if (differenceInMinutes < 60) {
      return "$differenceInMinutes 분";
    } else {
      return "$differenceInHours 시간";
    }
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
          : products.isEmpty
          ? Center(child: Text('등록된 상품이 없습니다.'))
          : ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ContentDetail(
                    product: product, // Product 객체 전달
                    products: products, // 전체 리스트 전달 (필요시)
                  ),
                ),
              );
            },
            child: Container(
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
                          product.foodCategory,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          product.foodName,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              '${((product.discountPrice / product.originPrice) * 100).toInt()}%',
                              style: TextStyle(
                                fontSize: 16,
                                color: defaultColors['green'],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              '${product.originPrice}원',
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
                              _getTimeDifference(product.endTime),
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
                    child: product.image.isNotEmpty
                        ? Image.memory(
                      Uint8List.fromList(
                          base64Decode(product.image)),
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    )
                        : Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      backgroundColor: Colors.grey[200],
    );
  }
}
