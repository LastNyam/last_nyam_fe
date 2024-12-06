import 'package:flutter/material.dart';
import 'package:last_nyam/colors.dart';
import 'package:last_nyam/const/colors.dart';
import 'home_screen.dart';
import 'package:last_nyam/component/common/search.dart';

import 'package:intl/intl.dart'; // 숫자 포맷을 위한 패키지 추가

class ContentDetail extends StatefulWidget {
  final Product product;
  final List<Product> products; // 추가: 전체 상품 리스트 전달

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
  String selectedRecipe = ''; // 추가: 선택된 레시피 아이콘 상태 저장

  // 숫자 포맷터 생성
  final NumberFormat currencyFormat = NumberFormat("#,###");

  @override
  Widget build(BuildContext context) {
    // 할인된 가격 계산
    final int discountedPrice = (int.parse(widget.product.price.replaceAll(RegExp(r'[^0-9]'), '')) * (100 - int.parse(widget.product.discount.replaceAll('%', '')))) ~/ 100;

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.navigate_before),
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
      body: Column(
        children: [
          // 상단 이미지
          Container(
            width: MediaQuery.of(context).size.width, // 화면 너비에 맞추기
            height: 280,
            child: Stack(
              children: [
                Image.asset(
                  widget.product.imagePath, // 상품 이미지
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width,
                  height: 280,
                ),
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
                        '${widget.product.amount}개 남았습니다',
                        style: const TextStyle(
                            color: Color(0xffFAFAFA),
                            fontSize: 12
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 20),

          // 상품 정보 및 예약 버튼
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Producer와 하트 아이콘
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // 가게 이미지와 이름
                        Row(
                          children: [
                            // 가게 이미지
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20), // 원형 이미지를 위해 둥근 테두리 적용
                              child: Image.asset(
                                'assets/image/tteopokki_card.png', // 가게 이미지 경로
                                width: 20, // 이미지 크기
                                height: 20,
                                fit: BoxFit.cover, // 이미지 비율 유지
                              ),
                            ),
                            const SizedBox(width: 5), // 이미지와 텍스트 간격
                            // Producer (가게 이름)
                            Text(
                              widget.product.producer,
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        // 하트 아이콘
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isLiked = !isLiked; // 하트 상태 토글
                            });
                          },
                          child: Icon(
                            isLiked ? Icons.favorite : Icons.favorite_border,
                            color: isLiked ? AppColors.greenColor : AppColors.semigreen,
                            size: 18,
                          ),
                        ),
                      ],
                    ),

                    Divider(
                      color: AppColors.semigreen,
                      thickness: 0.1,
                    ),
                    const SizedBox(height: 5),

                    // 상품 유형
                    Text(
                      widget.product.type == 'ingredients' ? '식자재' : '완제품',
                      style: const TextStyle(
                        color: AppColors.semigreen,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // 상품 이름
                    Text(
                      widget.product.title, // 상품 이름
                      style: const TextStyle(
                        fontSize: 17,
                      ),
                    ),

                    // 할인율, 할인된 가격, 원래 가격
                    Row(
                      children: [
                        // 할인율
                        Text(
                          widget.product.discount, // 할인율
                          style: const TextStyle(
                            color: Color(0xFF417C4E),
                            fontSize: 17,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(width: 4),

                        // 할인된 가격
                        Text(
                          '${currencyFormat.format(discountedPrice)}원',
                          style: const TextStyle(
                            color: Color(0xFF262626),
                            fontSize: 17,
                          ),
                        ),
                        const SizedBox(width: 10),

                        // 남은 시간
                        Spacer(), // 남은 시간 부분을 오른쪽으로 밀기 위한 Spacer
                        Row(
                          children: [
                            Image.asset(
                              'assets/icon/alarm.png',
                              width: 13,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              widget.product.timeLeft,
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),

                    // 상품 설명
                    Text(
                      widget.product.detail,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                      ),
                    ),

                    const SizedBox(height: 5),
                    Divider(
                      color: AppColors.semigreen,
                      thickness: 0.1,
                    ),
                    const SizedBox(height: 8),

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
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedRecipe = 'ai';
                                  selectedRecipeDetail =
                                  'AI를 활용한 추천 레시피입니다. 간단한 재료로 빠르게 요리할 수 있어요!';
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
                                      color: selectedRecipe == 'ai' ? AppColors.greenColor : null,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  // 이미지
                                  Image.asset(
                                    'assets/icon/recipe_Ai.png',
                                    color: selectedRecipe == 'ai'
                                        ? AppColors.whiteColor : null,
                                    width: 40,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 6),
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
                                      color: selectedRecipe == 'chef' ? AppColors.greenColor : null,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  // 이미지
                                  Image.asset(
                                    'assets/icon/recipe_chef.png',
                                    color: selectedRecipe == 'chef'
                                        ? AppColors.whiteColor : null,
                                    width: 40,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 6),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedRecipe = 'user';
                                  selectedRecipeDetail =
                                  '사용자가 공유한 레시피입니다. 다양한 아이디어를 참고해 보세요!'
                                      '\n나\n나\n나';
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
                                      color: selectedRecipe == 'user' ? AppColors.greenColor : null,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  // 이미지
                                  Image.asset(
                                    'assets/icon/recipe_user.png',
                                    color: selectedRecipe == 'user'
                                        ? AppColors.whiteColor : null,
                                    width: 40,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        if (isRecipeDetailVisible)
                          Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
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
                            )
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),


          // 예약하기 버튼
          Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: AppColors.greenColor, width: 0.1), // 윗 테두리 설정
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: widget.product.amount > 0
                      ? () {
                    _showPurchaseModal(context);
                  }
                  : () {
                    _showErrorDialog(context); // 예약하기 클릭 시 모달 실행
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.product.amount > 0 ? AppColors.greenColor : AppColors.semigreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  child: Text(
                    widget.product.amount > 0 ? '예약하기' : 'SOLD OUT',
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
          SizedBox(height: 20),
        ],
      ),
    );
  }

  // 남은 수량이 0개일 때
  void _showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
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
                    crossAxisAlignment: CrossAxisAlignment.end, // 전체 하단 정렬
                    children: [
                      // 상품 정보
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.product.title,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.product.price,
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      // 버튼 및 수량
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end, // 내부 정렬 수정
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
                                color: quantity > 1 ? AppColors.greenColor : AppColors.semigreen,
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
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
                            ),
                          ),
                          // + 버튼
                          Container(
                            alignment: Alignment.bottomCenter, // 하단 정렬
                            height: 20, // 통일된 높이
                            child: IconButton(
                              onPressed: quantity < widget.product.amount
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
                                color: quantity < widget.product.amount ? AppColors.greenColor : AppColors.semigreen,
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 16),
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
                          widget.product.isReserved = true;
                          widget.product.amount -= quantity; // 수량 감소
                        });

                        // 변경된 Product 객체 반환 및 화면 닫기
                        Navigator.pop(context); // 다이얼로그 닫기
                        Navigator.pop(context, widget.product); // 디테일 화면 닫고 데이터 반환
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.greenColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        minimumSize: Size(125, 40),
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