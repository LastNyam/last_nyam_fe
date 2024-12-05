import 'package:flutter/material.dart';
import 'package:last_nyam/colors.dart';
import 'package:last_nyam/component/home/category.dart';
import 'package:last_nyam/screen/content_detail.dart';
import 'package:last_nyam/component/common/search.dart';

// 1000원 표시 ','
import 'package:intl/intl.dart';

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
    // 수량 0인 상품을 하단으로 정렬
    final filteredProducts = [...products]
      ..sort((a, b) {
        if (a.amount == 0 && b.amount > 0) return 1; // `a`가 수량 0이면 뒤로 이동
        if (a.amount > 0 && b.amount == 0) return -1; // `b`가 수량 0이면 `a`가 앞으로 이동
        return 0; // 수량이 같으면 순서 유지
      });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.semiwhite,
        // 카테고리 위젯 추가
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
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                if (selectedCategory == 'all' || product.type == selectedCategory) {
                  return Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ContentDetail(
                              product: filteredProducts[index],
                              products: products,
                            ),
                          ),
                        ).then((updatedProduct) {
                          if (updatedProduct != null) {
                            setState(() {
                              final productIndex = products.indexOf(filteredProducts[index]);
                              products[productIndex] = updatedProduct;
                            });
                          }
                        });
                      },
                      child: ContentCard(product: filteredProducts[index]),
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


class ContentCard extends StatelessWidget {
  final Product product;

  const ContentCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    // 할인된 가격 계산
    int discountedPrice = 0;
    try {
      discountedPrice = (int.parse(product.price.replaceAll(RegExp(r'[^0-9]'), '')) *
          (100 - int.parse(product.discount.replaceAll('%', '')))) ~/
          100;
    } catch (e) {
      discountedPrice = 0; // 계산 오류 시 기본값
    }

    // 숫자에 쉼표 추가
    final formattedOriginalPrice = NumberFormat("#,###").format(
      int.parse(product.price.replaceAll(RegExp(r'[^0-9]'), '')),
    );
    final formattedDiscountedPrice = NumberFormat("#,###").format(discountedPrice);

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
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10, // 상하 여백
              horizontal: 16, // 좌우 여백
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 텍스트와 정보 영역
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 카테고리 표시
                      Text(
                        product.type == 'ingredients' ? '식자재' : '완제품',
                        style: const TextStyle(
                          color: AppColors.semigreen,
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(height: 9),

                      // 상품 제목 및 예약 상태
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              product.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 10,
                              ),
                            ),
                          ),
                          if (product.isReserved)
                            const SizedBox(width: 5)
                        ],
                      ),

                      // 할인율, 할인된 가격, 원래 가격
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            product.discount,
                            style: const TextStyle(
                              color: AppColors.greenColor,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '$formattedDiscountedPrice원',
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),

                      // 남은 시간
                      Row(
                        children: [
                          Image.asset(
                            'assets/icon/alarm.png',
                            width: 13,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            product.timeLeft,
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // 이미지
                ClipRRect(
                  child: Image.asset(
                    product.imagePath,
                    width: 100,
                    height: 72,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),

          // 초록색 불투명 오버레이 추가 (수량이 0일 때만)
          if (product.amount == 0)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.greenColor.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Center(
                  child: Text(
                    'SOLD OUT',
                    style: TextStyle(
                      color: AppColors.whiteColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
