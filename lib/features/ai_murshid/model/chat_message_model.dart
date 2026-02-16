class ChatMessage {
  String text;
  final bool isUser;
  bool isTyping;

  ChatMessage({
    required this.text,
    required this.isUser,
    this.isTyping = false,
  });
}
