// lib/screen/content_detail.dart

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:last_nyam/colors.dart';
import 'package:last_nyam/component/common/search.dart';
import 'package:intl/intl.dart'; // 숫자 포맷을 위한 패키지 추가
import 'package:last_nyam/model/product.dart'; // Product 클래스 임포트
import 'package:last_nyam/screen/retrieve_from_ai.dart'; // RetrieveFromAI 클래스 임포트

class ContentDetail extends StatefulWidget {
  final Product product;
  final List<Product> products; // 전체 상품 리스트 전달

  const ContentDetail({
    super.key,
    required this.product,
    required this.products,
  });

  @override
  State<ContentDetail> createState() => _ContentDetailState();
}

class _ContentDetailState extends State<ContentDetail> {
  bool isLiked = false; // 하트 상태를 저장하는 변수
  int quantity = 1; // 수량을 저장하는 변수
  bool isRecipeDetailVisible = false; // 레시피 상세 설명을 보일지 여부
  String selectedRecipeDetail = ''; // 선택된 아이콘의 상세 설명
  String selectedRecipe = ''; // 선택된 레시피 아이콘 상태 저장
  String aiRecipeResult = ''; // Python 실행 결과 저장 변수

  final NumberFormat currencyFormat = NumberFormat("#,###"); // 숫자 포맷터

  ProductDetail? productDetail; // 상세 정보 저장 변수
  bool isLoading = true; // 로딩 상태 관리
  String errorMessage = ''; // 오류 메시지 저장 변수

  @override
  void initState() {
    super.initState();
    fetchProductDetail();
  }

  // 상세 정보 가져오기
  Future<void> fetchProductDetail() async {
    try {
      final baseUrl = dotenv.env['BASE_URL']; // 환경 변수에서 BASE_URL 가져오기
      if (baseUrl == null || baseUrl.isEmpty) {
        throw Exception('BASE_URL이 설정되지 않았습니다.');
      }

      final response = await Dio().get('$baseUrl/food/${widget.product.foodId}');

      if (response.statusCode == 200) {
        final data = response.data['data'];
        print('ProductDetail JSON Data: $data'); // JSON 데이터 출력
        setState(() {
          productDetail = ProductDetail.fromJson(data);
          isLoading = false;
        });
        fetchAIRecipe(); // 상세 정보가 로드된 후 AI 레시피 결과 가져오기
      } else {
        throw Exception('서버에서 실패 응답을 반환했습니다. 상태 코드: ${response.statusCode}');
      }
    } catch (e) {
      print('상품 상세 데이터 가져오기 실패: $e');
      setState(() {
        isLoading = false;
        errorMessage = '상품 상세 정보를 불러오는 데 실패했습니다.';
      });
    }
  }

  // 예약하기 서버 요청 보내기
  Future<void> makeReservation(int foodId, int quantity) async {
    try {
      final baseUrl = dotenv.env['BASE_URL']; // 환경 변수에서 BASE_URL 가져오기
      if (baseUrl == null || baseUrl.isEmpty) {
        throw Exception('BASE_URL이 설정되지 않았습니다.');
      }

      // 토큰 읽기
      final _storage = const FlutterSecureStorage();
      final token = await _storage.read(key: 'authToken');
      if (token == null) {
        throw Exception('인증 토큰이 없습니다. 로그인이 필요합니다.');
      }

      // 요청 데이터
      final requestData = {
        'foodId': foodId,
        'amount': quantity,
      };

      // Dio 설정
      final dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer $token'; // Authorization 헤더 추가

      // POST 요청 보내기
      final response = await dio.post(
        '$baseUrl/reservation',
        data: requestData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('예약 성공: ${response.data}');
      } else {
        throw Exception('서버에서 실패 응답을 반환했습니다. 상태 코드: ${response.statusCode}');
      }
    } catch (e) {
      print('예약 요청 실패: $e');
      // 에러 처리
      throw Exception('예약 요청 중 문제가 발생했습니다.');
    }
  }


  // AI 레시피 결과 가져오기
  Future<void> fetchAIRecipe() async {
    try {
      if (productDetail != null) {
        final result = await RetrieveFromAI.fetchAIResult(productDetail!, widget.product);
        setState(() {
          aiRecipeResult = result;
        });
      }
    } catch (e) {
      print("Error in fetchAIRecipe: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // 로딩 중일 때 로딩 스피너 표시
    if (isLoading) {
      return Scaffold(
        backgroundColor: AppColors.whiteColor,
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.navigate_before),
            onPressed: () => Navigator.pop(context),
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
                  delegate: ProductSearchDelegate(widget.products),
                );
              },
            ),
          ],
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    // 오류 발생 시 오류 메시지 표시
    if (errorMessage.isNotEmpty) {
      return Scaffold(
        backgroundColor: AppColors.whiteColor,
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.navigate_before),
            onPressed: () => Navigator.pop(context),
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
                  delegate: ProductSearchDelegate(widget.products),
                );
              },
            ),
          ],
        ),
        body: Center(
          child: Text(
            errorMessage,
            style: const TextStyle(color: Colors.red, fontSize: 16),
          ),
        ),
      );
    }

    // 상세 정보가 로드된 경우 UI 표시
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.navigate_before),
          onPressed: () => Navigator.pop(context),
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
                delegate: ProductSearchDelegate(widget.products),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 상단 이미지
            Container(
              width: MediaQuery.of(context).size.width, // 화면 너비에 맞추기
              height: 280,
              child: Stack(
                children: [
                  productDetail!.image.isNotEmpty
                      ? Image.memory(
                    base64Decode(productDetail!.image),
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width,
                    height: 280,
                  )
                      : const Center(child: Text('이미지를 불러올 수 없습니다.')),
                  // 남은 수량
                  Positioned(
                    right: 10,
                    bottom: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xE5417C4E),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Center(
                        child: Text(
                          '${productDetail!.count}개 남았습니다',
                          style: const TextStyle(
                            color: Color(0xffFAFAFA),
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 상품 정보 및 예약 버튼
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 가게 이름 및 하트 아이콘
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 가게 이름
                      Text(
                        productDetail!.storeName,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isLiked = !isLiked; // 하트 상태 변경
                          });
                        },
                        child: Icon(
                          isLiked
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: isLiked
                              ? AppColors.greenColor
                              : AppColors.semigreen,
                        ),
                      ),
                    ],
                  ),
                  const Divider(thickness: 0.5),
                  const SizedBox(height: 10),

                  // 상품 유형
                  Text(
                    widget.product.foodCategory == 'ingredients'
                        ? '식자재'
                        : '완제품',
                    style: const TextStyle(
                      color: AppColors.semigreen,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // 상품 이름
                  Text(
                    productDetail!.foodName,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  // 할인 정보
                  Row(
                    children: [
                      // 할인율 계산 (예: 원가 대비 할인된 가격의 비율)
                      Text(
                        '할인율: ${calculateDiscountRate(productDetail!.originPrice, productDetail!.discountPrice)}%',
                        style: const TextStyle(
                          color: AppColors.greenColor,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 10),
                      // 할인된 가격
                      Text(
                        '${currencyFormat.format(productDetail!.discountPrice)}원',
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // 상품 설명
                  Text(
                    productDetail!.content.isNotEmpty
                        ? productDetail!.content
                        : '상품 설명이 없습니다.',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const Divider(thickness: 0.5),
                  const SizedBox(height: 20),

                  // 추천 레시피 섹션
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 추천 레시피 제목
                      const Text(
                        '추천 레시피',
                        style: TextStyle(
                          color: AppColors.semigreen,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // 추천 레시피 아이콘들
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // AI 레시피 아이콘
                          GestureDetector(
                            onTap: () async {
                              setState(() {
                                selectedRecipe = 'ai';
                                isRecipeDetailVisible = true;
                              });
                              await fetchAIRecipe(); // 매개변수 제거
                            },
                            child: Stack(
                              children: [
                                // 반투명 배경
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: selectedRecipe == 'ai'
                                        ? AppColors.greenColor
                                        : null,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                // 이미지
                                Image.asset(
                                  'assets/icon/recipe_Ai.png',
                                  color: selectedRecipe == 'ai'
                                      ? AppColors.whiteColor
                                      : null,
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 6),

                          // Chef 레시피 아이콘
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedRecipe = 'chef';
                                selectedRecipeDetail =
                                '셰프가 추천하는 레시피입니다. 정성스러운 요리법을 따라해 보세요!';
                                isRecipeDetailVisible = true;
                              });
                            },
                            child: Stack(
                              children: [
                                // 반투명 배경
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: selectedRecipe == 'chef'
                                        ? AppColors.greenColor
                                        : null,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                // 이미지
                                Image.asset(
                                  'assets/icon/recipe_chef.png',
                                  color: selectedRecipe == 'chef'
                                      ? AppColors.whiteColor
                                      : null,
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 6),

                          // User 레시피 아이콘
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedRecipe = 'user';
                                selectedRecipeDetail =
                                '사용자가 공유한 레시피입니다. 다양한 아이디어를 참고해 보세요!';
                                isRecipeDetailVisible = true;
                              });
                            },
                            child: Stack(
                              children: [
                                // 반투명 배경
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: selectedRecipe == 'user'
                                        ? AppColors.greenColor
                                        : null,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                // 이미지
                                Image.asset(
                                  'assets/icon/recipe_user.png',
                                  color: selectedRecipe == 'user'
                                      ? AppColors.whiteColor
                                      : null,
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // 선택된 레시피 상세 설명 표시
                      if (isRecipeDetailVisible && selectedRecipe != 'ai')
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 12),
                            color: AppColors.semiwhite,
                            constraints: const BoxConstraints(
                              minWidth: double.infinity,
                            ),
                            child: Text(
                              selectedRecipeDetail,
                              style: const TextStyle(
                                fontSize: 11,
                                height: 1.2,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                        ),

                      // AI 레시피 결과 표시
                      if (aiRecipeResult.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 12),
                            color: AppColors.semiwhite,
                            constraints: const BoxConstraints(
                              minWidth: double.infinity,
                            ),
                            child: Text(
                              aiRecipeResult,
                              style: const TextStyle(
                                fontSize: 11,
                                height: 1.2,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            // 예약하기 버튼
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(
                      color: AppColors.greenColor, width: 0.1), // 윗 테두리 설정
                ),
              ),
              child: Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: productDetail!.count > 0
                        ? () {
                      _showPurchaseModal(context);
                    }
                        : () {
                      _showErrorDialog(context); // 예약하기 클릭 시 모달 실행
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: productDetail!.count > 0
                          ? AppColors.greenColor
                          : AppColors.semigreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    child: Text(
                      productDetail!.count > 0 ? '예약하기' : 'SOLD OUT',
                      style: TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // 할인율 계산 함수 (예: 원가 대비 할인된 가격의 비율)
  double calculateDiscountRate(int originPrice, int discountPrice) {
    try {
      if (originPrice == 0) return 0.0;
      double rate = ((originPrice - discountPrice) / originPrice) * 100;
      return rate.isNegative ? 0.0 : rate;
    } catch (e) {
      print('할인율 계산 오류: $e');
      return 0.0;
    }
  }

  // 남은 수량이 0개일 때
  void _showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: const Text(
            '예약 불가',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            '현재 해당 상품이 품절되어 판매 중단 상태입니다.\n관심 매장을 등록하시면 새 상품이 등록될 때 알림을 받을 수 있어요!',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // 다이얼로그 닫기
              },
              child: const Text(
                '확인',
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showPurchaseModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.whiteColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 위쪽 드래그 핸들
                  Container(
                    width: 40,
                    height: 3,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: AppColors.grayColor.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2.5),
                    ),
                  ),

                  // 품목 정보
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment:
                    CrossAxisAlignment.end, // 전체 하단 정렬
                    children: [
                      // 상품 정보
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            productDetail!.foodName, // 수정된 필드
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${currencyFormat.format(productDetail!.discountPrice)}원', // 수정된 필드
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      // 버튼 및 수량
                      Row(
                        crossAxisAlignment:
                        CrossAxisAlignment.end, // 내부 정렬 수정
                        children: [
                          // - 버튼
                          Container(
                            alignment: Alignment.bottomCenter, // 하단 정렬
                            height: 20, // 통일된 높이
                            child: IconButton(
                              onPressed: quantity > 1
                                  ? () {
                                setState(() {
                                  quantity--;
                                });
                              }
                                  : null,
                              icon: Image.asset(
                                'assets/icon/num_minus.png',
                                width: 19, // 아이콘 너비
                                height: 19, // 아이콘 높이
                                color: quantity > 1
                                    ? AppColors.greenColor
                                    : AppColors.semigreen,
                              ),
                              padding: EdgeInsets.zero, // 여백 제거
                            ),
                          ),
                          // 수량 표시
                          Container(
                            alignment: Alignment.bottomCenter,
                            height: 40, // 높이 통일
                            child: Text(
                              '$quantity',
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w300),
                            ),
                          ),
                          // + 버튼
                          Container(
                            alignment: Alignment.bottomCenter, // 하단 정렬
                            height: 20, // 통일된 높이
                            child: IconButton(
                              onPressed: quantity < productDetail!.count
                                  ? () {
                                setState(() {
                                  quantity++;
                                });
                              }
                                  : null,
                              icon: Image.asset(
                                'assets/icon/num_plus.png',
                                width: 19, // 아이콘 너비
                                height: 19, // 아이콘 높이
                                color: quantity < productDetail!.count
                                    ? AppColors.greenColor
                                    : AppColors.semigreen,
                              ),
                              padding: EdgeInsets.zero, // 여백 제거
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // 예약하기 버튼
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // 모달 닫기
                        _showConfirmationDialog(context); // 예약 확인 다이얼로그 표시
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.greenColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      child: const Text(
                        '예약하기',
                        style: TextStyle(
                          color: AppColors.whiteColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding:
            const EdgeInsets.symmetric(vertical: 22, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '10분 내로 가게를 방문할 수 있나요?',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  ' 10분 내로 구매하지 않으면 상품 예약이 취소되고 불이익을 받을 수 있어요.\n신중하게 생각 후 예약 버튼을 눌러주세요.',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // 다이얼로그 닫기
                      },
                      child: const Text(
                        '취소',
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // 예약 상태 업데이트
                        setState(() {
                          productDetail!.count -= quantity; // 수량 감소
                        });

                        makeReservation(widget.product.foodId, quantity).then((_) {
                          // 예약 성공 후 처리
                          Navigator.pop(context); // 다이얼로그 닫기
                          Navigator.pop(context, productDetail); // 디테일 화면 닫고 데이터 반환
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('예약이 완료되었습니다.')),
                          );
                        }).catchError((e) {
                          // 예약 실패 시 처리
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('예약 실패: $e')),
                          );
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.greenColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        minimumSize: const Size(125, 40),
                      ),
                      child: const Text(
                        '예약하기',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
