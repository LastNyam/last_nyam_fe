import 'package:flutter/material.dart';

class ContentDetail extends StatefulWidget {
  const ContentDetail({super.key});

  @override
  _ContentDetailState createState() => _ContentDetailState();
}

class _ContentDetailState extends State<ContentDetail> {
  bool isLiked = false;// 하트 상태를 저장하는 변수
  int quantity = 1; //수량을 저장하는 변수

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [

            Positioned(
              top: 40, // 상단 위치
              left: 10, // 왼쪽 위치
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context); // 뒤로가기 동작
                },
                icon: const Icon(
                  Icons.arrow_back, // 뒤로가기 아이콘
                  color: Colors.black, // 아이콘 색상
                  size: 24, // 아이콘 크기
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
                      'assets/image/pork_detail.png', // 이미지 경로
                      fit: BoxFit.cover,
                      width: 375,
                      height: 300,
                    ),


                    Positioned(
                      right: 10,
                      bottom: 10,
                      child: Container(
                        width: 80,
                        height: 25,
                        decoration: BoxDecoration(
                          color: const Color(0xE5417C4E), // 초록색 배경
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Center(
                          child: Text(
                            '9개 남았습니다',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white, // 텍스트 색상
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

            // 고령축산 및 하트 아이콘
            Positioned(
              top: 310,
              child: Column(
                children: [
                  Container(
                    width: 328,
                    height: 28,
                    child: Stack(
                      children: [
                        Positioned(
                          right: 10,
                          top: 5,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                isLiked = !isLiked; // 하트 상태 토글
                              });
                            },
                            child: Icon(
                              isLiked ? Icons.favorite : Icons.favorite_border,
                              color: isLiked ? Colors.red : Colors.grey,
                              size: 20,
                            ),
                          ),
                        ),

                        const Positioned(
                          left: 21,
                          top: 2,
                          child: Text(
                            '고령축산',
                            style: TextStyle(
                              color: Color(0xFF262626),
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),

                        Positioned(
                          left: 2,
                          top: 1,
                          child: Container(
                            width: 14,
                            height: 14,
                            decoration: const ShapeDecoration(
                              color: Color(0xFFF2F2F2),
                              shape: OvalBorder(),
                            ),
                          ),
                        ),


                      ],
                    ),
                  ),
                  const SizedBox(height: 15),



                  // 상품 정보
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 상품 태그
                      const Text(
                        '식자재',
                        style: TextStyle(
                          color: Color(0xFFB9C6BC),
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 5),








                      // 상품 이름 및 타이머 정보
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                '국내산 돼지고기',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  Text(
                                    '10%',
                                    style: TextStyle(
                                      color: Color(0xFF417C4E),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    '10,000원',
                                    style: TextStyle(
                                      color: Color(0xFF262626),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(width: 20),







                          // 타이머 아이콘과 시간
                          Row(
                            children: const [
                              Icon(Icons.timer, size: 16, color: Colors.black),
                              SizedBox(width: 5),
                              Text(
                                '11분',
                                style: TextStyle(
                                  color: Color(0xFF262626),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),




                      // 상품 설명
                      const Text(
                        '어제 도축한 돼지고기 입니다. 지방과 살의 비율이 적절해서 드시기 좋습니다~',
                        style: TextStyle(
                          color: Color(0xFF262626),
                          fontSize: 10,
                          fontWeight: FontWeight.w300,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 15),




                      // 추천 레시피 섹션
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            '추천 레시피',
                            style: TextStyle(
                              color: Color(0xFFB9C6BC),
                              fontWeight: FontWeight.w400,
                              fontSize: 10,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildRecipeIcon('AI', Icons.smart_toy), // AI 아이콘
                              const SizedBox(width: 10),
                              _buildRecipeIcon('요리사', Icons.restaurant_menu), // 요리 아이콘
                              const SizedBox(width: 10),
                              _buildRecipeIcon('좋아요', Icons.thumb_up), // 좋아요 아이콘
                            ],
                          ),
                        ],
                      ),



                    ],
                  ),

                ],
              ),
            ),








            // 하단 예약 버튼
            Positioned(
              bottom: 20,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - 32,
                  child: ElevatedButton(
                    onPressed: () {
                      _showPurchaseModal(context); // 예약하기 버튼 클릭 시 모달 실행
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
      width: 50, // 버튼의 크기 설정
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: const Color(0xFF417C4E)), // 테두리 설정
        borderRadius: BorderRadius.circular(8), // 둥근 모서리 설정
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 20,
            color: const Color(0xFF417C4E), // 아이콘 색상
          ),
          const SizedBox(height: 5), // 아이콘과 텍스트 간격
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Color(0xFF417C4E), // 텍스트 색상
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
                        children: const [
                          Text(
                            '국내산 돼지고기',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            '10,000원',
                            style: TextStyle(
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
                            onPressed: () {
                              if (quantity > 1) {
                                setState(() {
                                  quantity--;
                                });
                              }
                            },
                            icon: const Icon(Icons.remove_circle_outline),
                            color: Colors.grey,
                          ),

                          // 수량 표시
                          Text(
                            '$quantity',
                            style: const TextStyle(fontSize: 16),
                          ),

                          // + 버튼
                          IconButton(
                            onPressed: () {
                              setState(() {
                                quantity++;
                              });
                            },
                            icon: const Icon(Icons.add_circle_outline),
                            color: Colors.grey,
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
                        Navigator.pop(context); // 다이얼로그 닫기
                        Navigator.popUntil(context, (route) => route.isFirst); // 첫 번째 화면으로 이동
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
