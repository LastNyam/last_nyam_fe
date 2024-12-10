import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:last_nyam/colors.dart';
import 'package:last_nyam/component/home/category.dart';
import 'package:last_nyam/screen/content_detail.dart';
import 'package:last_nyam/component/common/search.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:last_nyam/model/product.dart'; // Product 클래스 임포트

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Product> products = [];
  String selectedCategory = 'all';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      final baseUrl = dotenv.env['BASE_URL']; // 환경 변수에서 BASE_URL 가져오기
      if (baseUrl == null || baseUrl.isEmpty) {
        throw Exception('BASE_URL이 설정되지 않았습니다.');
      }

      final response = await Dio().get('$baseUrl/food');

      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        setState(() {
          products = data.map((item) => Product.fromJson(item)).toList();
          isLoading = false;
        });
      } else {
        throw Exception('서버에서 실패 응답을 반환했습니다. 상태 코드: ${response.statusCode}');
      }
    } catch (e) {
      print('상품 데이터 가져오기 실패: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    final filteredProducts = products.where((product) =>
    selectedCategory == 'all' || product.foodCategory == selectedCategory);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.semiwhite,
        title: Category(
          onCategorySelected: (String categoryType) {
            setState(() {
              selectedCategory = categoryType;
            });
          },
        ),
        actions: [
          IconButton(
            icon: Image.asset(
              'assets/icon/search.png',
              width: 24,
            ),
            onPressed: () {
              showSearch(
                context: context,
                delegate: ProductSearchDelegate(products),
              );
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : products.isEmpty
          ? const Center(child: Text('상품이 없습니다.'))
          : ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 10),
        itemCount: filteredProducts.length,
        itemBuilder: (context, index) {
          final product = filteredProducts.elementAt(index);
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ContentDetail(
                    product: product,
                    products: products,
                  ),
                ),
              );
            },
            child: ContentCard(product: product),
          );
        },
      ),
    );
  }
}

String getTimeDifference(String inputTimeString) {
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
    result = "$differenceInMinutes 분";
  } else {
    result = "$differenceInHours 시간";
  }

  return result;
}

// lib/screen/home_screen.dart

class ContentCard extends StatelessWidget {
  final Product product;

  const ContentCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 원가와 할인가격 숫자 포맷팅
    final formattedOriginalPrice =
    NumberFormat("#,###").format(product.originPrice); // int.parse 제거
    final formattedDiscountPrice =
    NumberFormat("#,###").format(product.discountPrice); // int.parse 제거

    // Base64 이미지를 디코딩하여 Uint8List로 변환
    Uint8List? decodedImage;
    try {
      decodedImage = base64Decode(product.image);
    } catch (e) {
      print('이미지 디코딩 실패: $e');
    }

    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      constraints: const BoxConstraints(maxWidth: 350),
      margin: const EdgeInsets.symmetric(vertical: 7),
      decoration: ShapeDecoration(
        color: AppColors.whiteColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13),
        ),
        shadows: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 음식 카테고리
                  Text(
                    product.foodCategory,
                    style: const TextStyle(
                      color: AppColors.semigreen,
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(height: 5),
                  // 음식 이름
                  Text(
                    product.foodName,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  // 할인율과 할인가격
                  Row(
                    children: [
                      Text(
                        '${((1 - product.discountPrice / product.originPrice) * 100).toStringAsFixed(0)}%',
                        style: const TextStyle(
                          color: AppColors.greenColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '$formattedDiscountPrice원',
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        '$formattedOriginalPrice원',
                        style: const TextStyle(
                          fontSize: 10,
                          decoration: TextDecoration.lineThrough, // 빗금 처리
                          color: Colors.grey,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 5),
                  // 마감 시간
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 14,
                        color: AppColors.semigreen,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        getTimeDifference(product.endTime),
                        style: const TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // 이미지 표시
            if (decodedImage != null)
              Image.memory(
                decodedImage,
                width: 100,
                height: 72,
                fit: BoxFit.cover,
              )
            else
              const Icon(
                Icons.broken_image,
                size: 100,
                color: Colors.grey,
              ),
          ],
        ),
      ),
    );
  }
}

