import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:maroofkhan8/core/network/api_endpoints.dart';
import '../../model/ai_murshid_request_model.dart';

class AiMurshidService {

  String? _sessionId; // keep session in memory

  /// Send text to AI Murshid
  Future<AiMurshidResponse> sendMessage(String userId, String text) async {
    final req = AiMurshidRequest(
      sessionId: _sessionId,
      userId: userId,
      text: text,
    );

    final response = await http.post(
      Uri.parse(ApiEndpoints.aiExplanationGeneral),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(req.toJson()),
    );

    if (response.statusCode == 200) {
      final data = AiMurshidResponse.fromJson(jsonDecode(response.body));
      // Save session_id for next call
      _sessionId = data.sessionId;
      return data;
    } else {
      throw Exception("AI Murshid API error: ${response.statusCode}");
    }
  }

  /// Optional: reset session
  void resetSession() {
    _sessionId = null;
  }
}
