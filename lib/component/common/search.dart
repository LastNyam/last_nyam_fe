import 'package:flutter/material.dart';
import 'package:last_nyam/model/product.dart'; // Product 모델 경로에 맞게 수정하세요.

class ProductSearchDelegate extends SearchDelegate {
  final List<Product> products;

  ProductSearchDelegate(this.products);

  @override
  List<Widget>? buildActions(BuildContext context) {
    // 검색창 오른쪽에 표시될 액션
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = ''; // 검색어 초기화
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // 검색창 왼쪽에 표시될 위젯
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null); // 검색 닫기
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // 검색 결과 화면
    final results = products.where((product) =>
        product.foodName.toLowerCase().contains(query.toLowerCase())
    ).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final product = results[index];
        return ListTile(
          title: Text(product.foodName),
          onTap: () {
            close(context, product);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // 검색창에 입력할 때 추천되는 아이템
    final suggestions = products.where((product) =>
        product.foodName.toLowerCase().contains(query.toLowerCase())
    ).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final product = suggestions[index];
        return ListTile(
          title: Text(product.foodName),
          onTap: () {
            query = product.foodName; // 검색창에 선택된 아이템 입력
            showResults(context); // 결과 표시
          },
        );
      },
    );
  }
}
