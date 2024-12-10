// lib/service/reservation_service.dart

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:last_nyam/model/product.dart';

class ReservationService {
  final _storage = const FlutterSecureStorage();
  final _dio = Dio();

  // 예약 내역 가져오기
  Future<List<Reservation>> fetchReservations() async {
    try {
      // 환경 변수에서 BASE_URL 가져오기
      final baseUrl = dotenv.env['BASE_URL'];
      if (baseUrl == null || baseUrl.isEmpty) {
        throw Exception('BASE_URL이 설정되지 않았습니다.');
      }

      // 사용자 토큰 읽기
      final token = await _storage.read(key: 'authToken');
      if (token == null) {
        throw Exception('인증 토큰이 없습니다. 로그인이 필요합니다.');
      }

      // API 호출
      final response = await _dio.get(
        '$baseUrl/reservation',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        return data.map((json) => Reservation.fromJson(json)).toList();
      } else {
        throw Exception('서버에서 실패 응답을 반환했습니다. 상태 코드: ${response.statusCode}');
      }
    } catch (e) {
      print('주문 내역 데이터 가져오기 실패: $e');
      throw Exception('주문 내역 요청 중 문제가 발생했습니다.');
    }
  }


  // 예약 상태 업데이트 API 함수 추가
  Future<void> updateReservationStatus(int reservationId, String newStatus) async {
    try {
      final baseUrl = dotenv.env['BASE_URL'];
      if (baseUrl == null || baseUrl.isEmpty) {
        throw Exception('BASE_URL이 설정되지 않았습니다.');
      }

      final token = await _storage.read(key: 'authToken');
      if (token == null) {
        throw Exception('인증 토큰이 없습니다. 로그인이 필요합니다.');
      }

      // API 엔드포인트 예시: '$baseUrl/reservation/{reservationId}/status'
      final response = await _dio.patch(
        '$baseUrl/reservation/$reservationId/status',
        data: {'status': newStatus},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        print('예약 상태 업데이트 성공');
      } else {
        throw Exception('예약 상태 업데이트 실패: 상태 코드 ${response.statusCode}');
      }
    } catch (e) {
      print('예약 상태 업데이트 실패: $e');
      throw Exception('예약 상태 업데이트 요청 중 문제가 발생했습니다.');
    }
  }

  // 예약 취소 API 함수 수정
  Future<void> cancelReservation(int reservationId) async {
    try {
      final baseUrl = dotenv.env['BASE_URL'];
      if (baseUrl == null || baseUrl.isEmpty) {
        throw Exception('BASE_URL이 설정되지 않았습니다.');
      }

      final token = await _storage.read(key: 'authToken');
      if (token == null) {
        throw Exception('인증 토큰이 없습니다. 로그인이 필요합니다.');
      }

      // reservationId를 String으로 변환
      final reservationIdStr = reservationId.toString();

      final response = await _dio.post(
        '$baseUrl/reservation/$reservationIdStr/cancel',
        data: {'reservationId': reservationIdStr},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        print('예약 취소 성공');
      } else {
        throw Exception('예약 취소 실패: 상태 코드 ${response.statusCode}');
      }
    } catch (e) {
      print('예약 취소 실패: $e');
      throw Exception('예약 취소 요청 중 문제가 발생했습니다.');
    }
  }

  // 리뷰 쓰기 API 수정
  Future<void> submitReview({
    required int storeId, // reservationId 대신 storeId를 int로 변경
    required int rating, // 별점 (1~5)
    String? reviewMessage,
    String? recipeRecommendation,
  }) async {
    try {
      final baseUrl = dotenv.env['BASE_URL'];
      if (baseUrl == null || baseUrl.isEmpty) {
        throw Exception('BASE_URL이 설정되지 않았습니다.');
      }

      final token = await _storage.read(key: 'authToken');
      if (token == null) {
        throw Exception('인증 토큰이 없습니다. 로그인이 필요합니다.');
      }

      final requestData = {
        'storeId': storeId.toString(), // storeId를 String으로 변환
        'rating': rating,
        'reviewMessage': reviewMessage,
        'recipeRecommendation': recipeRecommendation,
      };

      final response = await _dio.post(
        '$baseUrl/review',
        data: requestData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('리뷰 제출 성공');
      } else {
        throw Exception('리뷰 제출 실패: 상태 코드 ${response.statusCode}');
      }
    } catch (e) {
      print('리뷰 제출 실패: $e');
      throw Exception('리뷰 제출 중 문제가 발생했습니다.');
    }
  }
}
