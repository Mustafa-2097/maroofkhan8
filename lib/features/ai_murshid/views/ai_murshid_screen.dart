import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../controller/service/ai_murshid_service.dart';
import '../model/chat_message_model.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final AiMurshidService aiService = AiMurshidService();

  final ScrollController _scrollController = ScrollController();


  final List<ChatMessage> messages = [];
  bool isTyping = false;


  final Color rustBrown = const Color(0xFF80381C);
  final Color bgColor = const Color(0xFFF8F9FF);



  Future<void> _addTypingMessage(String fullText) async {
    final chatMessage = ChatMessage(
      text: '',
      isUser: false,
      isTyping: true,
    );

    setState(() => messages.add(chatMessage));
    _scrollToBottom();


    const int chunkSize = 3; // 👈 try 2–5
    const int delayMs = 16;  // ~60fps

    for (int i = 0; i < fullText.length; i += chunkSize) {
      await Future.delayed(const Duration(milliseconds: delayMs));

      setState(() {
        chatMessage.text += fullText.substring(
          i,
          (i + chunkSize).clamp(0, fullText.length),
        );
      });

      _scrollToBottom();
    }

    chatMessage.isTyping = false;
  }


  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }




  @override
  void dispose(){

    _scrollController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
            ),
            child: Row(
              children: [
                // Logo Circle
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade300, width: 2),
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/images/onboarding02.png',
                      height: 100,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Al Murshid",
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2E2E2E),
                      ),
                    ),
                    Text(
                      "Your Spiritual Guide",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                // const Spacer(),
                // const Icon(Icons.more_horiz, color: Colors.black),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: messages.isEmpty && !isTyping
                ? Center(
              child: Text(
                "Learn Islam with AI",
                style: GoogleFonts.playfairDisplay(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade400,
                ),
                textAlign: TextAlign.center,
              ),
            )
                : ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(20),
              itemCount: messages.length + (isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == messages.length && isTyping) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const ThreeDotTyping(),
                    ),
                  );
                }

                final message = messages[index];
                final isUser = message.isUser;

                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 12, top: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: isUser ? rustBrown : Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(15),
                            topRight: const Radius.circular(15),
                            bottomLeft: Radius.circular(isUser ? 15 : 0),
                            bottomRight: Radius.circular(isUser ? 0 : 15),
                          ),
                          boxShadow: isUser
                              ? []
                              : [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            )
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(top: isUser ? 0 : 8),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: message.text,
                                  style: TextStyle(
                                    color: isUser ? Colors.white : Colors.black87,
                                    fontSize: 14,
                                  ),
                                ),
                                if (message.isTyping)
                                  const TextSpan(
                                    text: '▍',
                                    style: TextStyle(color: Colors.black54),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Copy button for AI messages
                      if (!isUser && !message.isTyping)
                        Positioned(
                          right: 4,
                          top: 12,
                          child: GestureDetector(
                            onTap: () {
                              Clipboard.setData(ClipboardData(text: message.text));

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Copied to clipboard"),
                                  duration: Duration(milliseconds: 800),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.copy,
                                size: 14,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                );

              },
            ),
          ),




          VoiceInputBar(
            onSend: (text) async {
              setState(() {
                messages.add(ChatMessage(text: text, isUser: true));
                isTyping = true;
              });

              _scrollToBottom();


              try {
                final aiResp = await aiService.sendMessage("test_user_123", text);

                setState(() {
                  isTyping = false;
                });

                await _addTypingMessage(aiResp.explanation);


              } catch (e) {
                setState(() {
                  isTyping = false;
                });
              }
            },
          ),


        ],
      ),
    );
  }
}



class VoiceInputBar extends StatefulWidget {
  final Function(String) onSend;

  const VoiceInputBar({super.key, required this.onSend});

  @override
  State<VoiceInputBar> createState() => _VoiceInputBarState();
}

class _VoiceInputBarState extends State<VoiceInputBar> {
  bool isListening = false;

  late stt.SpeechToText _speech;
  String recognizedText = '';


  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  Future<void> _startListening() async {
    bool available = await _speech.initialize(
      onStatus: (status) {
        debugPrint('STATUS: $status');

        if (status == 'notListening' || status == 'done') {
          if (mounted) {
            setState(() => isListening = false);
          }
        }
      },
      onError: (error) {
        debugPrint('ERROR: $error');

        if (mounted) {
          setState(() => isListening = false);
        }
      },
    );

    if (available) {
      setState(() => isListening = true);

      _speech.listen(
        listenMode: stt.ListenMode.dictation,
        pauseFor: const Duration(seconds: 8),
        listenFor: const Duration(seconds: 30),
        partialResults: true,
        cancelOnError: false,
        onResult: (result) {
          setState(() {
            recognizedText = result.recognizedWords;
            _controller.text = recognizedText;
          });
        },
      );
    }
  }


  void _stopListening() {
    _speech.stop();
    setState(() {
      isListening = false;
    });
  }



  @override
  void dispose() {
    _controller.dispose();


    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 120),
      child: Stack(
        alignment: Alignment.centerRight,
        clipBehavior: Clip.none,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            height: 70,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                const SizedBox(width: 25),

                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    },
                    child: isListening
                        ? Container(
                      key: const ValueKey('speakNow'),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "Speak now",
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF4A4A4A),
                        ),
                      ),
                    )
                        : TextField(
                      key: const ValueKey('textField'),
                      controller: _controller,
                      enabled: !isListening,
                      maxLines: null,
                      minLines: 1,
                      decoration: const InputDecoration(
                        hintText: "Type a message...",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(
                          left: 0,
                          top: 12,
                          bottom: 12,
                          right: 110,
                        ),
                      ),
                      onChanged: (_) {
                        setState(() {}); // to update send button
                      },
                      onTap: () {
                        if (isListening) {
                          setState(() => isListening = false);
                        }
                      },
                    ),
                  ),
                ),

              ],
            ),
          ),

          // Mic Button
          // Mic + Send Buttons
          Positioned(
            right: 5,
            child: Row(
              children: [
                // Mic Button
                GestureDetector(
                  onTap: () {
                    if (isListening) {
                      _stopListening();
                    } else {
                      _startListening();
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    height: isListening ? 60 : 40,
                    width: isListening ? 60 : 40,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      isListening ? Icons.mic : Icons.mic_none,
                      color: Colors.white,
                      size: isListening ? 30 : 22,
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                // Send Button
                GestureDetector(
                  onTap: _controller.text.trim().isEmpty || isListening
                      ? null
                      : () {
                    final text = _controller.text.trim();

                    widget.onSend(text); // 🔥 SEND TO CHAT

                    _controller.clear();
                    setState(() {});
                  },

                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 42,
                    width: 42,
                    decoration: BoxDecoration(
                      color: _controller.text.trim().isEmpty || isListening
                          ? Colors.grey.shade300
                          : Colors.blueAccent,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.send,
                      color: _controller.text.trim().isEmpty || isListening
                          ? Colors.grey
                          : Colors.white,
                      size: 20,
                    ),

                  ),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}

class ThreeDotTyping extends StatefulWidget {
  const ThreeDotTyping({super.key});

  @override
  State<ThreeDotTyping> createState() => _ThreeDotTypingState();
}

class _ThreeDotTypingState extends State<ThreeDotTyping> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _dotOneAnim;
  late Animation<double> _dotTwoAnim;
  late Animation<double> _dotThreeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat();

    _dotOneAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.3, curve: Curves.easeInOut)),
    );
    _dotTwoAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.3, 0.6, curve: Curves.easeInOut)),
    );
    _dotThreeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.6, 0.9, curve: Curves.easeInOut)),
    );
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FadeTransition(opacity: _dotOneAnim, child: Dot()),
          FadeTransition(opacity: _dotTwoAnim, child: Dot()),
          FadeTransition(opacity: _dotThreeAnim, child: Dot()),
        ],
      ),
    );
  }
}

class Dot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 4,
      height: 4,
      decoration: const BoxDecoration(
        color: Colors.grey,
        shape: BoxShape.circle,
      ),
    );
  }
}
