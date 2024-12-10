// lib/screen/review_screen.dart

import 'package:flutter/material.dart';
import 'package:last_nyam/colors.dart';
import 'package:last_nyam/service/reservation_service.dart';

class ReviewScreen extends StatefulWidget {
  final String storeName;
  final String foodName;
  final String storeId; // reservationId 대신 storeId 추가
  final Function(String) onStatusChanged;

  const ReviewScreen({
    Key? key,
    required this.storeName,
    required this.foodName,
    required this.storeId, // reservationId 대신 storeId 전달
    required this.onStatusChanged,
  }) : super(key: key);

  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  List<bool> selectedStars = [false, false, false, false, false];
  bool showError = false;
  String reviewMessage = '';
  String recipeRecommendation = '';
  bool isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '리뷰 남기기',
          style: TextStyle(fontSize: 15),
        ),
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.navigate_before),
          onPressed: () => Navigator.pop(context),
          color: AppColors.blackColor, // 아이콘 색상 지정
        ),
      ),
      backgroundColor: AppColors.whiteColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 50),
              const Text(
                '상품은 어떠셨나요?',
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Text(
                '${widget.foodName} 1개',
                style: const TextStyle(fontSize: 12, color: AppColors.grayColor),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        for (int i = 0; i <= index; i++) {
                          selectedStars[i] = true;
                        }
                        for (int i = index + 1; i < 5; i++) {
                          selectedStars[i] = false;
                        }
                        showError = false; // 별점을 선택하면 오류 메시지 숨김
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Image.asset(
                        selectedStars[index]
                            ? 'assets/icon/star_fill.png'
                            : 'assets/icon/star.png',
                        width: 26,
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 22),
              const Divider(
                color: AppColors.greenColor,
                thickness: 0.1,
              ),
              const SizedBox(height: 15),
              const Text.rich(
                TextSpan(
                  text: '사장님께 전할 말 ',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  children: [
                    TextSpan(
                      text: '(선택)',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w100,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                onChanged: (value) {
                  reviewMessage = value;
                },
                decoration: InputDecoration(
                  hintText:
                  '맛, 양, 가격, 포장 상태 등에 대해 사장님께 전하고 싶은 내용을 작성해주세요. 앞으로의 가게 운영에 큰 도움이 됩니다!'
                      '\n\n작성한 리뷰는 사장님에게만 보이니 걱정마세요.',
                  border: InputBorder.none,
                  filled: true,
                  fillColor: AppColors.semiwhite,
                  hintStyle: const TextStyle(
                    fontSize: 12,
                    color: AppColors.semigreen,
                  ),
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 14),
              const Divider(
                color: AppColors.greenColor,
                thickness: 0.1,
              ),
              const SizedBox(height: 14),
              const Text.rich(
                TextSpan(
                  text: '레시피 추천 ',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  children: [
                    TextSpan(
                      text: '(선택)',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w100,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                onChanged: (value) {
                  recipeRecommendation = value;
                },
                decoration: InputDecoration(
                  hintText:
                  '구매한 상품과 어울리는 음식 조합이나 상품을 더 맛있게 즐길 수 있는 고객님만의 꿀팁을 공유해주세요!'
                      '\n\n작성해주신 레시피는 상품 상세 페이지에 공유돼요.',
                  border: InputBorder.none,
                  filled: true,
                  fillColor: AppColors.semiwhite,
                  hintStyle: const TextStyle(
                    fontSize: 12,
                    color: AppColors.semigreen,
                  ),
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showError)
              const Padding(
                padding: EdgeInsets.only(bottom: 0),
                child: Text(
                  '별점을 남겨주세요.',
                  style: TextStyle(color: AppColors.greenColor, fontSize: 10),
                  textAlign: TextAlign.center,
                ),
              ),
            SizedBox(
              width: double.infinity, // 버튼의 너비를 부모의 전체 너비로 설정
              child: ElevatedButton(
                onPressed: isSubmitting
                    ? null
                    : () async {
                  if (!selectedStars.contains(true)) {
                    setState(() {
                      showError = true;
                    });
                  } else {
                    setState(() {
                      isSubmitting = true;
                    });
                    try {
                      final rating =
                          selectedStars.where((star) => star).length;
                      final service = ReservationService();
                      final intStoreId = int.parse(widget.storeId);
                      await service.submitReview(
                        storeId: intStoreId, // reservationId 대신 storeId 전달
                        rating: rating,
                        reviewMessage: reviewMessage,
                        recipeRecommendation: recipeRecommendation,
                      );
                      widget.onStatusChanged('RECEIVED'); // 상태를 'RECEIVED'로 변경
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('리뷰가 제출되었습니다.')),
                      );
                      Navigator.pop(context);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('리뷰 제출 실패: $e')),
                      );
                    } finally {
                      setState(() {
                        isSubmitting = false;
                      });
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  showError ? AppColors.semigreen : AppColors.greenColor,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: isSubmitting
                    ? const CircularProgressIndicator(
                  valueColor:
                  AlwaysStoppedAnimation<Color>(AppColors.whiteColor),
                )
                    : const Text(
                  '작성 완료',
                  style: TextStyle(
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
