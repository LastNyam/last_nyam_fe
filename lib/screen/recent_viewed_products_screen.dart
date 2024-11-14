import 'package:flutter/material.dart';

class RecentViewedProductsScreen extends StatefulWidget {
  @override
  _RecentViewedProductsScreenState createState() =>
      _RecentViewedProductsScreenState();
}

class _RecentViewedProductsScreenState
    extends State<RecentViewedProductsScreen> {
  // 더미 데이터
  final List<Map<String, dynamic>> recentProducts = [
    {
      'image': null, // 이미지 경로 (null로 기본 아이콘 표시)
      'name': '국내산 돼지고기',
      'discount': '10%',
      'price': '10,000원',
      'time': '11분',
    },
    {
      'image': null, // 이미지 경로
      'name': '숙주나물',
      'discount': '5%',
      'price': '4,500원',
      'time': '1시간',
    },
    {
      'image': null, // 이미지 경로
      'name': '크리스마스 귀요미 쿠키 세트',
      'discount': '12%',
      'price': '9,900원',
      'time': '45분',
    },
  ];

  // 전체 삭제
  void _clearAll() {
    setState(() {
      recentProducts.clear();
    });
  }

  // 개별 삭제
  void _removeProduct(int index) {
    setState(() {
      recentProducts.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '최근 본 상품',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 16, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: _clearAll,
            child: Text(
              "전체 삭제",
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: recentProducts.isEmpty
          ? Center(
        child: Text(
          "최근 본 상품이 없습니다.",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      )
          : ListView.separated(
        itemCount: recentProducts.length,
        separatorBuilder: (context, index) => Divider(),
        itemBuilder: (context, index) {
          final product = recentProducts[index];
          return ListTile(
            leading: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
              child: product['image'] == null
                  ? Icon(Icons.image, color: Colors.grey)
                  : Image.asset(product['image'], fit: BoxFit.cover),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "식자재",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  product['name'],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      product['discount'],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      product['price'],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.timer, size: 14, color: Colors.grey),
                    SizedBox(width: 4),
                    Text(
                      product['time'],
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            trailing: IconButton(
              icon: Icon(Icons.close, color: Colors.grey),
              onPressed: () => _removeProduct(index),
            ),
          );
        },
      ),
    );
  }
}
