import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class ApiService {
  static Future<bool> checkConnection() async {
    try {
      final response = await http
          .get(Uri.parse(ApiConfig.baseUrl))
          .timeout(const Duration(seconds: ApiConfig.timeoutSeconds));
      
      return response.statusCode == 200;
    } catch (e) {
      print('API Connection Error: $e');
      return false;
    }
  }

  static Future<Map<String, dynamic>> makeRequest({
    required String url,
    required String method,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    try {
      final uri = Uri.parse(url);
      final requestHeaders = {
        ...ApiConfig.defaultHeaders,
        ...?headers,
      };

      http.Response response;

      switch (method.toUpperCase()) {
        case 'GET':
          response = await http
              .get(uri, headers: requestHeaders)
              .timeout(const Duration(seconds: ApiConfig.timeoutSeconds));
          break;
        case 'POST':
          response = await http
              .post(
                uri,
                headers: requestHeaders,
                body: body != null ? jsonEncode(body) : null,
              )
              .timeout(const Duration(seconds: ApiConfig.timeoutSeconds));
          break;
        case 'PUT':
          response = await http
              .put(
                uri,
                headers: requestHeaders,
                body: body != null ? jsonEncode(body) : null,
              )
              .timeout(const Duration(seconds: ApiConfig.timeoutSeconds));
          break;
        case 'DELETE':
          response = await http
              .delete(uri, headers: requestHeaders)
              .timeout(const Duration(seconds: ApiConfig.timeoutSeconds));
          break;
        default:
          throw Exception('Unsupported HTTP method: $method');
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (response.body.isNotEmpty) {
          return jsonDecode(response.body);
        } else {
          return {'success': true};
        }
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('API Request Error: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> makeFormRequest({
    required String url,
    required Map<String, String> fields,
    Map<String, String>? headers,
  }) async {
    try {
      final uri = Uri.parse(url);
      final requestHeaders = {
        ...?headers,
      };

      final request = http.MultipartRequest('POST', uri);
      request.headers.addAll(requestHeaders);
      request.fields.addAll(fields);

      final streamedResponse = await request
          .send()
          .timeout(const Duration(seconds: ApiConfig.timeoutSeconds));
      
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (response.body.isNotEmpty) {
          return jsonDecode(response.body);
        } else {
          return {'success': true};
        }
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('API Form Request Error: $e');
      rethrow;
    }
  }
} 