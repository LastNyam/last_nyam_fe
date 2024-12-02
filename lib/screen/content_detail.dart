import 'package:flutter/material.dart';
import 'home_screen.dart';

class ContentDetail extends StatefulWidget {
  final Product product; // 전달받은 상품 데이터

  const ContentDetail({super.key, required this.product});

  @override
  _ContentDetailState createState() => _ContentDetailState();
}

class _ContentDetailState extends State<ContentDetail> {
  bool isLiked = false; // 하트 상태를 저장하는 변수
  int quantity = 1; // 수량을 저장하는 변수

  @override
  Widget build(BuildContext context) {
    // 할인된 가격 계산
    final int discountedPrice = (int.parse(widget.product.price.replaceAll(RegExp(r'[^0-9]'), '')) * (100 - int.parse(widget.product.discount.replaceAll('%', '')))) ~/ 100;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 뒤로가기 버튼
            Positioned(
              top: 30,
              left: 10,
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                  size: 24,
                ),
              ),
            ),

            // 상단 이미지
            Positioned(
              top: 0,
              child: Container(
                width: 375,
                height: 300,
                child: Stack(
                  children: [
                    Image.asset(
                      widget.product.imagePath, // 상품 이미지
                      fit: BoxFit.cover,
                      width: 375,
                      height: 300,
                    ),

                    // 남은 수량
                    Positioned(
                      right: 10,
                      bottom: 10,
                      child: Container(
                        width: 80,
                        height: 25,
                        decoration: BoxDecoration(
                          color: const Color(0xE5417C4E),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(
                          child: Text(
                            '${widget.product.amount}개 남았습니다',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 상품 정보 및 예약 버튼
            Positioned(
              top: 320,
              left: 16,
              right: 16,
              child: Column(
                children: [
                  // Producer와 하트 아이콘
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Producer
                      Text(
                        widget.product.producer,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
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
                          color: isLiked ? Colors.red : Colors.grey,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // 상품 유형
                  Text(
                    widget.product.type == 'ingredients' ? '식자재' : '완제품',
                    style: const TextStyle(
                      color: Color(0xFFB9C6BC),
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 5),

                  // 상품 이름
                  Text(
                    widget.product.title, // 상품 이름
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // 할인율, 할인된 가격, 원래 가격
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 할인율
                      Text(
                        widget.product.discount, // 할인율
                        style: const TextStyle(
                          color: Color(0xFF417C4E),
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(width: 10),

                      // 할인된 가격
                      Text(
                        '${discountedPrice.toString()}원',
                        style: const TextStyle(
                          color: Color(0xFF262626),
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(width: 10),

                      // 원래 가격 (취소선)
                      Text(
                        '${widget.product.price}원',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          decoration: TextDecoration.lineThrough, // 취소선
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  // 상품 설명
                  Text(
                    widget.product.detail,
                    style: const TextStyle(
                      color: Color(0xFF262626),
                      fontSize: 10,
                      fontWeight: FontWeight.w300,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  // 추천 레시피 섹션
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        '추천 레시피',
                        style: TextStyle(
                          color: Color(0xFFB9C6BC),
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildRecipeIcon('AI', Icons.smart_toy),
                          const SizedBox(width: 10),
                          _buildRecipeIcon('요리사', Icons.restaurant_menu),
                          const SizedBox(width: 10),
                          _buildRecipeIcon('좋아요', Icons.thumb_up),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // 예약하기 버튼
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 32,
                    child: ElevatedButton(
                      onPressed: () {
                        _showPurchaseModal(context); // 예약하기 클릭 시 모달 실행
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF417C4E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: const Text(
                        '예약하기',
                        style: TextStyle(
                          color: Color(0xFFF2F2F2),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  // 추천 레시피 아이콘 빌더
  Widget _buildRecipeIcon(String label, IconData icon) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: const Color(0xFF417C4E)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 20,
            color: const Color(0xFF417C4E),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Color(0xFF417C4E),
            ),
          ),
        ],
      ),
    );
  }

  void _showPurchaseModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
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
                    height: 5,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2.5),
                    ),
                  ),

                  // 품목 정보
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.product.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            widget.product.price,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          // - 버튼
                          IconButton(
                            onPressed: quantity > 1
                                ? () {
                              setState(() {
                                quantity--;
                              });
                            }
                                : null, // 버튼 비활성화
                            icon: const Icon(Icons.remove_circle_outline),
                            color: quantity > 1 ? Colors.grey : Colors.grey[300],
                          ),

                          // 수량 표시
                          Text(
                            '$quantity',
                            style: const TextStyle(fontSize: 16),
                          ),

                          // + 버튼
                          IconButton(
                            onPressed: quantity < widget.product.amount
                                ? () {
                              setState(() {
                                quantity++;
                              });
                            }
                                : null, // 버튼 비활성화
                            icon: const Icon(Icons.add_circle_outline),
                            color: quantity < widget.product.amount
                                ? Colors.grey
                                : Colors.grey[300], // 비활성화 색상
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // 예약하기 버튼
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // 모달 닫기
                        _showConfirmationDialog(context); // 예약 확인 다이얼로그 표시
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF417C4E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: const Text(
                        '예약하기',
                        style: TextStyle(
                          color: Color(0xFFF2F2F2),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
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
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '10분 내로 가게를 방문할 수 있나요?',
                  style: TextStyle(
                    color: Color(0xFF262626),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  '10분 내로 구매하지 않으면 상품 예약이 취소되고 불이익을 받을 수 있어요. 신중하게 생각 후 예약 버튼을 눌러주세요.',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // 다이얼로그 닫기
                      },
                      child: const Text(
                        '취소',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          // 예약 상태 업데이트
                          widget.product.isReserved = true;
                          widget.product.amount -= quantity; // 수량 감소
                        });

                        // 다이얼로그 닫기 전에 홈 화면 상태 갱신
                        Navigator.pop(context, widget.product);
                        Navigator.pop(context); // ContentDetail 화면 닫기
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF417C4E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        '예약하기',
                        style: TextStyle(
                          color: Colors.white,
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
