import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../offline_storage/shared_pref.dart';
import '../utils/snackbar_utils.dart';

class ApiService {
  static const Duration timeout = Duration(seconds: 30);

  /// Helper to get default headers with Auth token
  static Future<Map<String, String>> _getHeaders(
    Map<String, String>? extraHeaders,
  ) async {
    final token = await SharedPreferencesHelper.getToken();
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (token != null && token.isNotEmpty) {
      if (kDebugMode) print('ApiService: Token found, length: ${token.length}');

      final bearerToken = token;

      // We send both to be safe, though standard is 'Authorization'
      headers['Authorization'] = bearerToken;
      headers['authorization'] = bearerToken;
    } else {
      if (kDebugMode) print('ApiService: NO TOKEN FOUND in SharedPreferences');
    }

    if (extraHeaders != null) {
      headers.addAll(extraHeaders);
    }
    return headers;
  }

  /// POST REQUEST
  static Future<Map<String, dynamic>> post(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    bool showErrorSnackbar = true,
  }) async {
    try {
      final finalHeaders = await _getHeaders(headers);

      debugPrint('🚨🚨🚨 API POST REQUEST START 🚨🚨🚨');
      debugPrint('URL: $url');
      debugPrint('HEADERS: $finalHeaders');
      debugPrint('BODY: ${jsonEncode(body)}');

      final response = await http
          .post(
            Uri.parse(url),
            headers: finalHeaders,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(timeout);

      debugPrint('🟢🟢🟢 API RESPONSE 🟢🟢🟢');
      debugPrint('STATUS: ${response.statusCode}');
      debugPrint('BODY: ${response.body}');

      final decoded = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return decoded;
      } else {
        String errorMsg = decoded['message'] ?? 'Something went wrong';
        if (decoded['errorMessages'] != null &&
            decoded['errorMessages'] is List &&
            (decoded['errorMessages'] as List).isNotEmpty) {
          errorMsg = decoded['errorMessages'][0]['message'] ?? errorMsg;
        }
        throw errorMsg;
      }
    } catch (e) {
      final friendlyMsg = _friendlyError(e);
      if (friendlyMsg != null && showErrorSnackbar) {
        SnackbarUtils.showSnackbar("Error", friendlyMsg, isError: true);
      }
      rethrow;
    }
  }

  /// GET REQUEST
  static Future<Map<String, dynamic>> get(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    bool showErrorSnackbar = true,
  }) async {
    try {
      final finalHeaders = await _getHeaders(headers);
      final uri = Uri.parse(url).replace(queryParameters: queryParameters);

      debugPrint('🚨🚨🚨 API GET REQUEST START 🚨🚨🚨');
      debugPrint('URL: $uri');
      debugPrint('HEADERS: $finalHeaders');

      final response = await http
          .get(uri, headers: finalHeaders)
          .timeout(timeout);

      debugPrint('🟢🟢🟢 API RESPONSE 🟢🟢🟢');
      debugPrint('STATUS: ${response.statusCode}');
      debugPrint('BODY: ${response.body}');

      final decoded = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return decoded;
      } else {
        String errorMsg = decoded['message'] ?? 'Something went wrong';
        if (decoded['errorMessages'] != null &&
            decoded['errorMessages'] is List &&
            (decoded['errorMessages'] as List).isNotEmpty) {
          errorMsg = decoded['errorMessages'][0]['message'] ?? errorMsg;
        }
        throw errorMsg;
      }
    } catch (e) {
      final friendlyMsg = _friendlyError(e);
      if (friendlyMsg != null && showErrorSnackbar) {
        SnackbarUtils.showSnackbar("Error", friendlyMsg, isError: true);
      }
      rethrow;
    }
  }

  /// PUT REQUEST
  static Future<Map<String, dynamic>> put(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    bool showErrorSnackbar = true,
  }) async {
    try {
      final finalHeaders = await _getHeaders(headers);

      debugPrint('🚨🚨🚨 API PUT REQUEST START 🚨🚨🚨');
      debugPrint('URL: $url');
      debugPrint('HEADERS: $finalHeaders');
      debugPrint('BODY: ${jsonEncode(body)}');

      final response = await http
          .put(
            Uri.parse(url),
            headers: finalHeaders,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(timeout);

      debugPrint('🟢🟢🟢 API RESPONSE 🟢🟢🟢');
      debugPrint('STATUS: ${response.statusCode}');
      debugPrint('BODY: ${response.body}');

      final decoded = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return decoded;
      } else {
        String errorMsg = decoded['message'] ?? 'Something went wrong';
        if (decoded['errorMessages'] != null &&
            decoded['errorMessages'] is List &&
            (decoded['errorMessages'] as List).isNotEmpty) {
          errorMsg = decoded['errorMessages'][0]['message'] ?? errorMsg;
        }
        throw errorMsg;
      }
    } catch (e) {
      final friendlyMsg = _friendlyError(e);
      if (friendlyMsg != null && showErrorSnackbar) {
        SnackbarUtils.showSnackbar("Error", friendlyMsg, isError: true);
      }
      rethrow;
    }
  }

  /// DELETE REQUEST
  static Future<Map<String, dynamic>> delete(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    bool showErrorSnackbar = true,
  }) async {
    try {
      final finalHeaders = await _getHeaders(headers);

      debugPrint('🚨🚨🚨 API DELETE REQUEST START 🚨🚨🚨');
      debugPrint('URL: $url');
      debugPrint('HEADERS: $finalHeaders');
      if (body != null) debugPrint('BODY: ${jsonEncode(body)}');

      final response = await http
          .delete(
            Uri.parse(url),
            headers: finalHeaders,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(timeout);

      debugPrint('🟢🟢🟢 API RESPONSE 🟢🟢🟢');
      debugPrint('STATUS: ${response.statusCode}');
      debugPrint('BODY: ${response.body}');

      final decoded = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return decoded;
      } else {
        String errorMsg = decoded['message'] ?? 'Something went wrong';
        if (decoded['errorMessages'] != null &&
            decoded['errorMessages'] is List &&
            (decoded['errorMessages'] as List).isNotEmpty) {
          errorMsg = decoded['errorMessages'][0]['message'] ?? errorMsg;
        }
        throw errorMsg;
      }
    } catch (e) {
      final friendlyMsg = _friendlyError(e);
      if (friendlyMsg != null && showErrorSnackbar) {
        SnackbarUtils.showSnackbar("Error", friendlyMsg, isError: true);
      }
      rethrow;
    }
  }

  /// PATCH REQUEST
  static Future<Map<String, dynamic>> patch(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    bool showErrorSnackbar = true,
  }) async {
    try {
      final finalHeaders = await _getHeaders(headers);

      debugPrint('🚨🚨🚨 API PATCH REQUEST START 🚨🚨🚨');
      debugPrint('URL: $url');
      debugPrint('HEADERS: $finalHeaders');
      debugPrint('BODY: ${jsonEncode(body)}');

      final response = await http
          .patch(
            Uri.parse(url),
            headers: finalHeaders,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(timeout);

      debugPrint('🟢🟢🟢 API RESPONSE 🟢🟢🟢');
      debugPrint('STATUS: ${response.statusCode}');
      debugPrint('BODY: ${response.body}');

      final decoded = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return decoded;
      } else {
        String errorMsg = decoded['message'] ?? 'Something went wrong';
        if (decoded['errorMessages'] != null &&
            decoded['errorMessages'] is List &&
            (decoded['errorMessages'] as List).isNotEmpty) {
          errorMsg = decoded['errorMessages'][0]['message'] ?? errorMsg;
        }
        throw errorMsg;
      }
    } catch (e) {
      final friendlyMsg = _friendlyError(e);
      if (friendlyMsg != null && showErrorSnackbar) {
        SnackbarUtils.showSnackbar("Error", friendlyMsg, isError: true);
      }
      rethrow;
    }
  }

  /// PATCH MULTIPART REQUEST
  static Future<Map<String, dynamic>> patchMultipart(
    String url, {
    required Map<String, String> headers,
    Map<String, String>? fields,
    File? imageFile,
    String imageFieldName = 'profileImage',
    bool showErrorSnackbar = true,
  }) async {
    try {
      final request = http.MultipartRequest('PATCH', Uri.parse(url));

      final token = await SharedPreferencesHelper.getToken();
      if (token != null && token.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $token';
        request.headers['authorization'] = 'Bearer $token';
      }

      headers.forEach((key, value) {
        if (key.toLowerCase() != 'content-type') {
          request.headers[key] = value;
        }
      });

      if (fields != null) {
        request.fields.addAll(fields);
      }

      if (imageFile != null) {
        final mimeType = _getMimeType(imageFile.path);
        request.files.add(
          await http.MultipartFile.fromPath(
            imageFieldName,
            imageFile.path,
            contentType: mimeType,
          ),
        );
      }

      final streamedResponse = await request.send().timeout(timeout);
      final response = await http.Response.fromStream(streamedResponse);
      final decoded = jsonDecode(response.body);

      debugPrint('🟢🟢🟢 API MULTIPART RESPONSE 🟢🟢🟢');
      debugPrint('STATUS: ${response.statusCode}');
      debugPrint('BODY: ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return decoded;
      } else {
        String errorMsg = decoded['message'] ?? 'Something went wrong';
        if (decoded['errorMessages'] != null &&
            decoded['errorMessages'] is List &&
            (decoded['errorMessages'] as List).isNotEmpty) {
          errorMsg = decoded['errorMessages'][0]['message'] ?? errorMsg;
        }
        throw errorMsg;
      }
    } catch (e) {
      final friendlyMsg = _friendlyError(e);
      if (friendlyMsg != null && showErrorSnackbar) {
        SnackbarUtils.showSnackbar("Error", friendlyMsg, isError: true);
      }
      rethrow;
    }
  }

  static MediaType _getMimeType(String path) {
    final ext = path.split('.').last.toLowerCase();
    switch (ext) {
      case 'jpg':
      case 'jpeg':
        return MediaType('image', 'jpeg');
      case 'png':
        return MediaType('image', 'png');
      case 'webp':
        return MediaType('image', 'webp');
      default:
        return MediaType('image', 'jpeg');
    }
  }

  static String? _friendlyError(Object e) {
    final msg = e.toString();
    if (msg.contains('TimeoutException')) return 'Request timed out.';
    if (msg.contains('SocketException')) return 'No internet connection.';
    if (msg.contains('FormatException')) return 'Server response error.';
    if (msg.toLowerCase().contains('invalid credentials'))
      return 'Invalid email or password';
    if (msg.toLowerCase().contains('phone must be a valid phone number')) {
      return null;
    }
    if (!msg.contains('Exception:') && !msg.contains('Error:')) return msg;
    return 'Something went wrong.';
  }
}
