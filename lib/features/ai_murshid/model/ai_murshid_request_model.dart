class AiMurshidRequest {
  final String? sessionId;
  final String userId;
  final String text;

  AiMurshidRequest({this.sessionId, required this.userId, required this.text});

  Map<String, dynamic> toJson() => {
    "session_id": sessionId,
    "user_id": userId,
    "text": text,
  };
}

class AiMurshidResponse {
  final String sessionId;
  final String explanation;
  final String source;

  AiMurshidResponse({
    required this.sessionId,
    required this.explanation,
    required this.source,
  });

  factory AiMurshidResponse.fromJson(Map<String, dynamic> json) {
    return AiMurshidResponse(
      sessionId: json["session_id"],
      explanation: json["explanation"],
      source: json["source"],
    );
  }
}
