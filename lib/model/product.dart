import 'dart:convert';

// lib/model/product.dart

class Product {
  final int foodId;
  final String foodCategory;
  final String foodName;
  final String storeName;
  final int originPrice;
  final int discountPrice;
  final String endTime;
  final double posX;
  final double posY;
  final String image;

  Product({
    required this.foodId,
    required this.foodCategory,
    required this.foodName,
    required this.storeName,
    required this.originPrice,
    required this.discountPrice,
    required this.endTime,
    required this.posX,
    required this.posY,
    required this.image,
  });

  // JSON 데이터를 Product 객체로 변환
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      foodId: json['foodId'] is int
          ? json['foodId']
          : int.tryParse(json['foodId'].toString()) ?? 0,
      foodCategory: json['foodCategory'] ?? 'Unknown',
      foodName: json['foodName'] ?? 'Unnamed Food',
      storeName: json['storeName'] ?? 'Unknown Store',
      originPrice: json['originPrice'] is int
          ? json['originPrice']
          : int.tryParse(json['originPrice'].toString()) ?? 0,
      discountPrice: json['discountPrice'] is int
          ? json['discountPrice']
          : int.tryParse(json['discountPrice'].toString()) ?? 0,
      endTime: json['endTime'] ?? '00:00',
      posX: (json['posX'] is double)
          ? json['posX']
          : double.tryParse(json['posX'].toString()) ?? 0.0,
      posY: (json['posY'] is double)
          ? json['posY']
          : double.tryParse(json['posY'].toString()) ?? 0.0,
      image: json['image'] ?? '',
    );
  }

  // copyWith 메서드 추가 (필요 시 사용)
  Product copyWith({
    int? foodId,
    String? foodCategory,
    String? foodName,
    String? storeName,
    int? originPrice,
    int? discountPrice,
    String? endTime,
    double? posX,
    double? posY,
    String? image,
  }) {
    return Product(
      foodId: foodId ?? this.foodId,
      foodCategory: foodCategory ?? this.foodCategory,
      foodName: foodName ?? this.foodName,
      storeName: storeName ?? this.storeName,
      originPrice: originPrice ?? this.originPrice,
      discountPrice: discountPrice ?? this.discountPrice,
      endTime: endTime ?? this.endTime,
      posX: posX ?? this.posX,
      posY: posY ?? this.posY,
      image: image ?? this.image,
    );
  }
}





class ProductDetail {
  final int storeId;
  final String storeName;
  final String foodName;
  final String content;
  final int originPrice;
  final int discountPrice;
  final String endTime;
  int count;
  final int reservationTime;
  final String status;
  final String image;
  final List<Recipe> recommendRecipe;

  ProductDetail({
    required this.storeId,
    required this.storeName,
    required this.foodName,
    required this.content,
    required this.originPrice,
    required this.discountPrice,
    required this.endTime,
    required this.count,
    required this.reservationTime,
    required this.status,
    required this.image,
    required this.recommendRecipe,
  });

  factory ProductDetail.fromJson(Map<String, dynamic> json) {
    return ProductDetail(
      storeId: json['storeId'] ?? 0,
      storeName: json['storeName'] ?? '',
      foodName: json['foodName'] ?? '',
      content: json['content'] ?? '',
      originPrice: json['originPrice'] ?? 0,
      discountPrice: json['discountPrice'] ?? 0,
      endTime: json['endTime'] ?? '',
      count: json['count'] ?? 0,
      reservationTime: json['reservationTime'] ?? 0,
      status: json['status'] ?? '',
      image: json['image'] ?? '',
      recommendRecipe: (json['recommendRecipe'] as List<dynamic>?)
          ?.map((e) => Recipe.fromJson(e))
          .toList() ??
          [],
    );
  }
}

class Recipe {
  final String recipe;
  final String? recipeImage;
  final String author;

  Recipe({
    required this.recipe,
    this.recipeImage,
    required this.author,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      recipe: json['recipe'] ?? '',
      recipeImage: json['recipeImage'],
      author: json['author'] ?? '',
    );
  }
}

class RecommendRecipe {
  final String recipe;
  final String? recipeImage;
  final String author;

  RecommendRecipe({
    required this.recipe,
    this.recipeImage,
    required this.author,
  });

  factory RecommendRecipe.fromJson(Map<String, dynamic> json) {
    return RecommendRecipe(
      recipe: json['recipe']?.toString() ?? '',
      recipeImage: json['recipeImage']?.toString(),
      author: json['author']?.toString() ?? '',
    );
  }
}




class Reservation {
  final int reservationId;
  final int storeId;
  final String storeName;
  final int foodId;
  final String foodImage;
  final String status;
  final String foodName;
  final int number;
  final int price;
  final String reservationTime;

  Reservation({
    required this.reservationId,
    required this.storeId,
    required this.storeName,
    required this.foodId,
    required this.foodImage,
    required this.status,
    required this.foodName,
    required this.number,
    required this.price,
    required this.reservationTime,
  });

  // copyWith 메서드 수정 (필드 타입에 맞게 변경)
  Reservation copyWith({
    int? reservationId,
    int? storeId,
    String? storeName,
    int? foodId,
    String? foodImage,
    String? status,
    String? foodName,
    int? number,
    int? price,
    String? reservationTime,
  }) {
    return Reservation(
      reservationId: reservationId ?? this.reservationId,
      storeId: storeId ?? this.storeId,
      storeName: storeName ?? this.storeName,
      foodId: foodId ?? this.foodId,
      foodImage: foodImage ?? this.foodImage,
      status: status ?? this.status,
      foodName: foodName ?? this.foodName,
      number: number ?? this.number,
      price: price ?? this.price,
      reservationTime: reservationTime ?? this.reservationTime,
    );
  }

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      reservationId: json['reservationId'] is int
          ? json['reservationId']
          : int.tryParse(json['reservationId'].toString()) ?? 0,
      storeId: json['storeId'] is int
          ? json['storeId']
          : int.tryParse(json['storeId'].toString()) ?? 0,
      storeName: json['storeName'] ?? 'Unknown Store',
      foodId: json['foodId'] is int
          ? json['foodId']
          : int.tryParse(json['foodId'].toString()) ?? 0,
      foodImage: json['foodImage'] ?? '',
      status: json['status'] ?? 'UNKNOWN',
      foodName: json['foodName'] ?? 'Unnamed Food',
      number: json['number'] is int
          ? json['number']
          : int.tryParse(json['number'].toString()) ?? 0,
      price: json['price'] is int
          ? json['price']
          : int.tryParse(json['price'].toString()) ?? 0,
      reservationTime: json['reservationTime'] ?? '00:00',
    );
  }
}

