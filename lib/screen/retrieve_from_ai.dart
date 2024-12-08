import 'dart:convert'; // JSON 처리
import 'package:http/http.dart' as http;
import 'package:last_nyam/screen/home_screen.dart';

class RetrieveFromAI {
  static Future<String> fetchAIResult(Product product) async {
    try {
      // Flask API URL 설정
      final String apiUrl = "http://192.168.63.55:5000/generate-recipe";

      // 요청 본문 데이터
      final Map<String, dynamic> requestData = {
        "type": product.type,
        "title": product.title,
        "info": product.detail,
      };

      // Flask API에 POST 요청
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestData),
      );

      // 응답 상태 확인
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return responseData["result"] ?? "Error: No result in response.";
      } else {
        return "Error: Flask API returned status code ${response.statusCode}.";
      }
    } catch (e) {
      print("Error during Flask API communication: $e");
      return "Error: Could not communicate with Flask API.";
    }
  }
}
