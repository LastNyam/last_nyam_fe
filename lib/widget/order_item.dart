// lib/widget/order_item.dart

import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:last_nyam/colors.dart';
import 'package:last_nyam/screen/review_screen.dart';
import 'package:last_nyam/widget/custom_circular_timer.dart';

class OrderItem extends StatefulWidget {
  final String progress;
  final String storeName;
  final String storeId; // 추가
  final String foodName;
  final String amount;
  final String discountPrice;
  final bool isCompleted;
  final String image; // Base64 인코딩된 이미지 문자열
  final String status;
  final String reservationId; // 예약 ID 유지 (필요 시 사용)
  final VoidCallback? onCancel;
  final ValueChanged<String> onStatusChanged;

  const OrderItem({
    Key? key,
    required this.progress,
    required this.storeName,
    required this.storeId, // 추가
    required this.foodName,
    required this.amount,
    required this.discountPrice,
    required this.isCompleted,
    required this.image,
    required this.status,
    required this.reservationId, // 예약 ID 전달
    this.onCancel,
    required this.onStatusChanged,
  }) : super(key: key);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  Uint8List? decodedImage;

  @override
  void initState() {
    super.initState();
    _decodeImage();
  }

  void _decodeImage() {
    try {
      decodedImage = base64Decode(widget.image);
    } catch (e) {
      print('이미지 디코딩 실패: $e');
      decodedImage = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      color: AppColors.whiteColor,
      elevation: widget.isCompleted ? 0 : 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            title: Text(
              widget.progress,
              style: const TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 7),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: decodedImage != null
                          ? Image.memory(
                        decodedImage!,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      )
                          : Container(
                        width: 50,
                        height: 50,
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.broken_image,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.storeName,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              Text(
                                widget.foodName,
                                style: const TextStyle(
                                  fontSize: 10,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                widget.amount,
                                style: const TextStyle(
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            widget.discountPrice,
                            style: const TextStyle(
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // 예약 취소 버튼 추가
                    if (widget.status == 'BEFORE_ACCEPT')
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor: AppColors.whiteColor,
                                    title: const Text("예약 취소"),
                                    content: const Text("예약을 취소하시겠습니까?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text("아니오"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          widget.onCancel?.call(); // 삭제 콜백 호출
                                        },
                                        style: TextButton.styleFrom(
                                          backgroundColor: AppColors.greenColor,
                                        ),
                                        child: const Text(
                                          "예",
                                          style: TextStyle(color: AppColors.whiteColor),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.semiwhite,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                              minimumSize: const Size(0, 30),
                            ),
                            child: const Text(
                              "예약취소",
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    // 타이머 생성
                    if (widget.status == 'RESERVATION')
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: CustomCircularTimer(
                          remainingMinutes: 2, // 실제 구현 시 서버에서 남은 시간을 가져와 설정
                          onTimerComplete: () {
                            widget.onStatusChanged('CHECKING'); // 상태를 'CHECKING'으로 변경
                          },
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          // 리뷰 남기기
          if (widget.status == 'RECEIVED') ...[
            Container(
              width: double.infinity,
              child: const Divider(
                color: AppColors.greenColor,
                thickness: 0.1,
              ),
            ),
            const SizedBox(height: 1),
            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReviewScreen(
                        storeName: widget.storeName,
                        foodName: widget.foodName,
                        storeId: widget.storeId, // storeId 전달
                        onStatusChanged: widget.onStatusChanged,
                      ),
                    ),
                  );
                },
                child: const Text.rich(
                  TextSpan(
                    text: '리뷰 남기기',
                    style: TextStyle(
                      color: AppColors.greenColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    children: [
                      TextSpan(
                        text: '(3일이내)',
                        style: TextStyle(fontWeight: FontWeight.w100),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 7),
          ]
        ],
      ),
    );
  }
}
