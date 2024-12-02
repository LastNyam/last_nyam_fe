import 'package:flutter/material.dart';
import 'package:last_nyam/component/home/category.dart';
import 'package:last_nyam/screen/content_detail.dart';

// 상품 데이터 모델
class Product {
  final String title;
  final String type;
  final String discount;
  final String price;
  final String timeLeft;
  final String imagePath;
  final String detail;
  int amount;
  final String producer;
  bool isReserved;

  Product({
    required this.title,
    required this.type,
    required this.discount,
    required this.price,
    required this.timeLeft,
    required this.imagePath,
    required this.detail,
    required this.amount,
    required this.producer,
    this.isReserved = false,
  });
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  // 상품 데이터 리스트
  final List<Product> products = [
    Product(
      title: '국내산 돼지고기',
      type: 'ingredients',
      discount: '10%',
      price: '10,000원',
      timeLeft: '11분',
      imagePath: 'assets/image/pork_detail.png',
      detail: '어제 도축한 돼지고기입니다. 지방과 살의 비율이 적절해서 드시기 좋습니다~',
      amount: 5,
      producer: '고령축산',
    ),
    Product(
      title: '달콤매콤 시장 쌀 떡볶이',
      type: 'product',
      discount: '34%',
      price: '2,000원',
      timeLeft: '3시간',
      imagePath: 'assets/image/tteopokki_card.png',
      detail: '둘이 먹다가 둘다 죽어도 모를 맛입니다~',
      amount: 3,
      producer : '벽종원의 시장정복',
    ),
  ];





  // 선택된 카테고리
  String selectedCategory = 'all';



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // 카테고리 위젯 추가
          Category(
            onCategorySelected: (String categoryType) {
              setState(() {
                selectedCategory = categoryType;
              });
            },
          ),
          const SizedBox(height: 10),



          // 필터링된 상품 리스트 출력
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                if (selectedCategory == 'all' || product.type == selectedCategory) {
                  return Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ContentDetail(product: products[index]),
                          ),
                        ).then((updatedProduct) {
                          if (updatedProduct != null) {
                            setState(() {
                              products[index] = updatedProduct; // 변경된 상태 반영
                            });
                          }
                        });
                      },
                      child: ContentCard(product: products[index]),
                    ),

                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),


        ],
      ),
    );
  }
}





// 상품 카드 위젯
class ContentCard extends StatelessWidget {
  final Product product;

  const ContentCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    // 할인된 가격 계산
    final int discountedPrice = (int.parse(product.price.replaceAll(RegExp(r'[^0-9]'), '')) * (100 - int.parse(product.discount.replaceAll('%', '')))) ~/ 100;

    return Stack(
      children: [
        // 카드 UI
        Container(
          width: MediaQuery.of(context).size.width * 0.9,
          constraints: const BoxConstraints(maxWidth: 350),
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: ShapeDecoration(
            color: Colors.white,
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
          child: Row(
            children: [
              // 이미지
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(
                  product.imagePath,
                  width: 100,
                  height: 72,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),

              // 텍스트와 정보 영역
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 상품 제목
                    Text(
                      product.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF262626),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // 할인율, 할인된 가격, 원래 가격
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // 할인율
                        Text(
                          product.discount,
                          style: const TextStyle(
                            color: Color(0xFF417C4E),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 10),

                        // 할인된 가격
                        Text(
                          '${discountedPrice.toString()}원',
                          style: const TextStyle(
                            color: Color(0xFF262626),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(width: 8),

                        // 원래 가격 (취소선)
                        Text(
                          '${product.price}원',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // 남은 시간
                    Row(
                      children: [
                        const Icon(Icons.timer, size: 13),
                        const SizedBox(width: 5),
                        Text(
                          product.timeLeft,
                          style: const TextStyle(
                            color: Color(0xFF262626),
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // 예약 중 표시
        if (product.isReserved)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.5), // 반투명 블러 효과
              alignment: Alignment.center,
              child: const Text(
                '예약 중',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),



      ],
    );
  }
}










