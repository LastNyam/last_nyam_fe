import 'dart:async';
import 'package:flutter/material.dart';
import 'package:last_nyam/const/colors.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OrderHistoryScreen(),
    );
  }
}

class OrderHistoryScreen extends StatefulWidget {
  @override
  _OrderHistoryScreenState createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  String orderStatus =
      "pending"; // "pending", "accepted", "completed", "review"
  int countdown = 10; // 카운트다운 초기값
  Timer? _timer;

  // 이전 주문 내역 더미 데이터
  final List<Map<String, String>> pastOrders = [
    {
      'date': '2024.10.13(일)',
      'status': '수령 완료',
      'storeName': '콩자반분식',
      'item': 'MZ 떡볶이 1개',
      'price': '5,000원'
    },
  ];

  // 카운트다운 시작
  void _startCountdown() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (countdown > 0) {
        setState(() {
          countdown--;
        });
      } else {
        _timer?.cancel();
        setState(() {
          orderStatus = "completed"; // 수령 확인 중 상태로 변경
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "주문 내역",
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (orderStatus == "pending") ...[
              // 현재 주문 상태 - 대기 중
              _buildCurrentOrder(
                context,
                "사장님이 주문을 확인하고 있어요.",
                "고령축산",
                "국내산 돼지고기 4개",
                "40,000원",
                buttonText: "예약취소",
                onPressed: () {
                  setState(() {
                    orderStatus = ""; // 현재 주문 삭제
                  });
                },
              ),
            ] else if (orderStatus == "accepted") ...[
              // 현재 주문 상태 - 수락됨
              _buildCurrentOrder(
                context,
                "사장님이 예약을 수락했어요. 가게에 방문하여 상품을 수령해주세요.",
                "고령축산",
                "국내산 돼지고기 4개",
                "40,000원",
                countdownWidget: Text(
                  "$countdown분",
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ] else if (orderStatus == "completed") ...[
              // 현재 주문 상태 - 수령 확인 중
              _buildCurrentOrder(
                context,
                "고객님의 상품 수령 여부를 확인하는 중이에요.",
                "고령축산",
                "국내산 돼지고기 4개",
                "40,000원",
              ),
            ],
            Divider(),
            // 이전 주문 내역
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var order in pastOrders)
                    _buildPastOrder(
                      order['date']!,
                      order['status']!,
                      order['storeName']!,
                      order['item']!,
                      order['price']!,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 현재 주문 UI
  Widget _buildCurrentOrder(
    BuildContext context,
    String statusText,
    String storeName,
    String item,
    String price, {
    String? buttonText,
    VoidCallback? onPressed,
    Widget? countdownWidget,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16),
          Card(
            color: Colors.white,
            elevation: 12,
            shadowColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8),
                Row(
                  children: [
                    SizedBox(width: 16),
                    Text(
                      statusText,
                      style: TextStyle(
                          fontSize: 10,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                ListTile(
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.store, color: Colors.grey),
                  ),
                  title: GestureDetector(
                    child: Row(
                      children: [
                        Text(
                          storeName,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        Icon(Icons.arrow_forward_ios, size: 12, color: Colors.black)
                      ],
                    ),
                    onTap: () {
                      print('상품 이동 처리');
                      // 상품 이동 처리
                    },
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item,
                        style: TextStyle(fontSize: 10),
                      ),
                      Text(
                        price,
                        style: TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                  trailing: countdownWidget ??
                      (buttonText != null
                          ? Column(
                        children: [
                          SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: onPressed,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: defaultColors['white'],
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                            ),
                            child: Text(
                              buttonText,
                              style: TextStyle(color: defaultColors['black'], fontSize: 10),
                            ),
                          ),
                          SizedBox(height: 8),
                        ],
                      )
                          : null),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 과거 주문 UI
  Widget _buildPastOrder(
    String date,
    String status,
    String storeName,
    String item,
    String price,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$date | $status",
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        ListTile(
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.store, color: Colors.grey),
          ),
          title: Text(
            storeName,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item),
              SizedBox(height: 4),
              Text(
                price,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          trailing: status == "수령 완료"
              ? TextButton(
                  onPressed: () {
                    // 리뷰 작성 페이지로 이동
                  },
                  child: Text(
                    "리뷰 남기기 (3일 이내)",
                    style: TextStyle(color: Colors.green),
                  ),
                )
              : null,
        ),
        Divider(),
      ],
    );
  }
}
