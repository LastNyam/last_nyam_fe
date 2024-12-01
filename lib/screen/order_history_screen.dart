import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AppColors {
  static const Color blackColor = Color(0xFF262626);
  static const Color whiteColor = Color(0xFFFAFAFA);
  static const Color semiwhite = Color(0xFFF2F2F2);
  static const Color grayColor = Color(0xFF6B7280);
  static const Color semigray = Color(0xFFf9f9f9);
  static const Color greenColor = Color(0xFF417C4E);
  static const Color semigreen = Color(0xFFB9C6BC);
}

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({Key? key}) : super(key: key);

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  List<Map<String, dynamic>> orderItems = [
    {
      'progress': '사장님이 주문을 확인하고 있어요.',
      'storeName': '바들바들 동물콘',
      'foodName': '안아줘요',
      'amount': '1개',
      'discountPrice': '12,900원',
      'isCompleted': false,
      'image': 'https://pbs.twimg.com/media/FaP2c_FaIAAzFZa?format=jpg&name=large',
      'status': 'accepting',
    },
    {
      'progress': '사장님이 예약을 수락했어요, 가게에 방문하여 상품을 수령해주세요.',
      'storeName': '대머리라서 좋은 점',
      'foodName': '타코야끼 같은 내 머리',
      'amount': '10개',
      'discountPrice': '2,500원',
      'isCompleted': false,
      'image': 'https://media.istockphoto.com/id/622003890/ko/사진/문어-빵.jpg?s=612x612&w=0&k=20&c=f_J2S-EDzqquyDaTHnxQyVIl83Yqs5TkoNIa-YL8Qt4=',
      'status': 'visiting',
    },
    {
      'progress': '고객님의 상품 수령 여부를 확인하는 중이에요.',
      'storeName': '왕가탕후루',
      'foodName': '그럼 제가 손님 맘에',
      'amount': '1개',
      'discountPrice': '500원',
      'isCompleted': false,
      'image': 'https://health.chosun.com/site/data/img_dir/2023/09/01/2023090102254_0.jpg',
      'status': 'checking',
    },
    {
      'progress': '2024.11.11(월) 수령 완료',
      'storeName': '과일장수',
      'foodName': '망고 먹은지 얼망고',
      'amount': '8개',
      'discountPrice': '4,500원',
      'isCompleted': true,
      'image': 'https://www.gunwi.net/data/editor/2308/14f523ccf20ea952636e572ec3a87377_1693292273_01.jpg',
      'status': 'review',
    },
    {
      'progress': '2024.6.11(화) 수령 완료',
      'storeName': '구황작물 킬러',
      'foodName': '호구마',
      'amount': '4개',
      'discountPrice': '1,300원',
      'isCompleted': true,
      'image': 'https://noblegochang.com/web/product/big/202401/1dab9b010bc4a55cae9487c1795d4136.jpg',
      'status': 'success',
    },
    {
      'progress': '2024.5.3(금) 미수령',
      'storeName': '붕어빵빵',
      'foodName': '따끈따끈 붕어빵',
      'discountPrice': '2,000원',
      'amount': '10개',
      'isCompleted': true,
      'image': 'https://partner.yogiyo.co.kr/upload/editor/2021/01/25/d4b837aad7524462a1d0f5f552b7cd03.jpg',
      'status': 'fail',
    }
  ];

  void removeOrder(int index) {
    setState(() {
      orderItems.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '주문 내역',
          style: TextStyle(fontSize: 15),
        ),
        backgroundColor: AppColors.whiteColor,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(8.0),
        itemCount: orderItems.length,
        itemBuilder: (context, index) {
          final order = orderItems[index];
          return OrderItem(
            progress: order['progress'],
            storeName: order['storeName'],
            foodName: order['foodName'],
            amount: order['amount'],
            discountPrice: order['discountPrice'],
            isCompleted: order['isCompleted'],
            image: order['image'],
            status: order['status'],
            onCancel: () => removeOrder(index), // 삭제 함수 전달
          );
        },
      ),
    );
  }
}

class OrderItem extends StatelessWidget {
  final String progress;
  final String storeName;
  final String foodName;
  final String amount;
  final String discountPrice;
  final bool isCompleted;
  final String image;
  final String status;
  final VoidCallback? onCancel; // 추가

  OrderItem({
    required this.progress,
    required this.storeName,
    required this.foodName,
    required this.amount,
    required this.discountPrice,
    required this.isCompleted,
    required this.image,
    required this.status,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 6.0),
      color: AppColors.whiteColor,
      elevation: isCompleted ? 0 : 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            title: Text(
              progress,
              style: TextStyle(
                color: AppColors.blackColor,
                fontSize: 8,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 7),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        image,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            storeName,
                            style: TextStyle(
                              color: AppColors.blackColor,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 3),
                          Row(
                            children: [
                              Text(
                                foodName,
                                style: TextStyle(
                                  fontSize: 10,
                                ),
                              ),
                              SizedBox(width: 5),
                              Text(
                                amount,
                                style: TextStyle(
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            discountPrice,
                            style: TextStyle(
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // 예약 취소 버튼 추가
                    if (status == 'accepting')
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: AppColors.whiteColor,
                                  title: Text("예약 취소"),
                                  content: Text("예약을 취소하시겠습니까?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("아니오"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        onCancel?.call(); // 삭제 콜백 호출
                                      },
                                      style: TextButton.styleFrom(
                                          backgroundColor: AppColors.greenColor,
                                      ),
                                      child: Text("예", style: TextStyle(color: AppColors.whiteColor),),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.semiwhite,
                            elevation: 0, // 그림자 제거
                            padding: EdgeInsets.symmetric(horizontal: 13.0),
                            minimumSize: Size(0, 30),
                            textStyle: TextStyle(fontSize: 10, color: AppColors.blackColor),
                          ),
                          child: Text("예약취소", style: TextStyle(color: AppColors.blackColor),),
                        ),
                      ),
                    // 타이머 생성
                    if (status == 'visiting') // 타이머 위치 추가
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: CustomCircularTimer(remainingMinutes: 10),
                      ),
                  ],
                ),

              ],
            ),
          ),
          // 리뷰 남기기
          if (status == 'review') ...[
            Container(
              width: double.infinity,
              child: Divider(
                color: AppColors.greenColor,
                thickness: 0.1, // Divider thickness
              ),
            ),
            SizedBox(height: 1),
            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReviewScreen(
                        storeName: storeName,
                        foodName: foodName,
                      ),
                    ),
                  );
                },
                child: Text.rich(
                  TextSpan(
                    text: '리뷰 남기기', // Bold text
                    style: TextStyle(
                      color: AppColors.greenColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    children: [
                      TextSpan(
                        text: '(3일이내)', // Thin text
                        style: TextStyle(fontWeight: FontWeight.w100),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 7),
          ]
        ],
      ),
    );
  }
}



// 커스텀 타이머 위젯
class CustomCircularTimer extends StatefulWidget {
  final int remainingMinutes;

  CustomCircularTimer({required this.remainingMinutes});

  @override
  _CustomCircularTimerState createState() => _CustomCircularTimerState();
}

class _CustomCircularTimerState extends State<CustomCircularTimer> {
  late int remainingMinutes;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    remainingMinutes = widget.remainingMinutes;

    // 타이머 시작: 1분마다 감소
    timer = Timer.periodic(Duration(minutes: 1), (timer) {
      if (remainingMinutes > 0) {
        setState(() {
          remainingMinutes--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double percentage = remainingMinutes / widget.remainingMinutes;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // SizedBox(height: 10),
        Container(
          width: 55, // 타이머 크기 조정 (가로)
          height: 55, // 타이머 크기 조정 (세로)
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: percentage, // 진행 상태
                color: AppColors.greenColor,
                backgroundColor: AppColors.grayColor.withOpacity(0.2),
                strokeWidth: 3.0, // 원의 두께
              ),
              Text(
                '${remainingMinutes}분',
                style: TextStyle(
                  fontSize: 12, // 타이머 텍스트 크기
                  color: AppColors.blackColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// 리뷰 남기기
class ReviewScreen extends StatefulWidget {
  final String storeName;
  final String foodName;

  ReviewScreen({required this.storeName, required this.foodName});

  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  // 별점 상태를 저장할 리스트 (5개의 별, 기본적으로 false로 설정)
  List<bool> selectedStars = [false, false, false, false, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '리뷰 남기기',
          style: TextStyle(fontSize: 15),
        ),
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.navigate_before),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: AppColors.whiteColor,
      body: Stack( // Stack 사용으로 위젯들을 겹치게 설정
        children: [
          SingleChildScrollView( // 내용은 스크롤 가능하게
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 50),
                  // 상품 리뷰 섹션
                  Text(
                    '상품은 어떠셨나요?',
                    style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 40),
                  Text(
                    '${widget.foodName} 1개',
                    style: TextStyle(fontSize: 12, color: AppColors.grayColor),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),

                  // 별점 섹션
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            // 클릭한 별까지 true로 설정 (그 이전의 별도 포함)
                            for (int i = 0; i <= index; i++) {
                              selectedStars[i] = true;
                            }
                            for (int i = index + 1; i < 5; i++) {
                              selectedStars[i] = false;
                            }
                          });
                        },
                        child: Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: Image.asset(
                            selectedStars[index]
                                ? 'assets/icon/star_fill.png' // 선택된 별
                                : 'assets/icon/star.png', // 비선택된 별
                            width: 26,
                          ),
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: 22),
                  Divider(
                    color: AppColors.greenColor,
                    thickness: 0.1,
                  ),
                  SizedBox(height: 15),

                  // 사장님께 전할 말 입력 필드
                  Text.rich(
                    TextSpan(
                      text: '사장님께 전할 말 ', // 기본 스타일
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                      children: [
                        TextSpan(
                          text: '(선택)', // '(선택)'의 스타일
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w100, // 굵기 변경
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    decoration: InputDecoration(
                        hintText: '맛, 양, 가격, 포장 상태 등에 대해 사장님께 전하고 싶은 내용을 작성해주세요. 앞으로의 가게 운영에 큰 도움이 됩니다!'
                            '\n\n작성한 리뷰는 사장님에게만 보이니 걱정마세요.',
                        border: InputBorder.none,
                        filled: true,
                        fillColor: AppColors.semiwhite,
                        hintStyle: TextStyle(
                            fontSize: 12,
                            color: AppColors.semigreen
                        )
                    ),
                    maxLines: 4,
                  ),
                  SizedBox(height: 14),
                  Divider(
                    color: AppColors.greenColor,
                    thickness: 0.1,
                  ),
                  SizedBox(height: 14),

                  // 레시피 추천 입력 필드
                  Text.rich(
                    TextSpan(
                      text: '레시피 추천 ', // 기본 스타일
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                      children: [
                        TextSpan(
                          text: '(선택)', // '(선택)'의 스타일
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w100, // 굵기 변경
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    decoration: InputDecoration(
                        hintText: '구매한 상품과 어울리는 음식 조합이나 상품을 더 맛있게 즐길 수 있는 고객님만의 꿀팁을 공유해주세요!'
                            '\n\n작성해주신 레시피는 상품 상세 페이지에 공유돼요.',
                        border: InputBorder.none,
                        filled: true,
                        fillColor: AppColors.semiwhite,
                        hintStyle: TextStyle(
                            fontSize: 12,
                            color: AppColors.semigreen
                        )
                    ),
                    maxLines: 4,
                  ),
                  SizedBox(height: 120), // 충분한 여백을 남겨 스크롤 시 텍스트 필드가 보이게 함
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0, // 버튼을 화면 하단에 고정
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  // 리뷰 저장 로직 추가
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.greenColor,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: Text(
                  '작성 완료',
                  style: TextStyle(fontSize: 14, color: AppColors.whiteColor, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
