// ============================================================
// Customer Support Chat Screen — n8n Integration
// ============================================================
// Dependencies needed in pubspec.yaml:
//
// dependencies:
//   http: ^1.2.0
//   uuid: ^4.4.0
//   shared_preferences: ^2.2.3
//
// ============================================================

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ------------------------------------------------------------
// 1) Chat message model
// ------------------------------------------------------------
class ChatMessage {
  final String text;
  final bool isUser; // true = user, false = agent
  final DateTime timestamp;

  ChatMessage({required this.text, required this.isUser, DateTime? timestamp})
    : timestamp = timestamp ?? DateTime.now();
}

// ------------------------------------------------------------
// 2) API service — talks to your n8n webhook
// ------------------------------------------------------------
class SupportApiService {
  // 🔴 غيّر ده لرابط الـ Webhook بتاعك من n8n
  // (test webhook أثناء التطوير، وبعدين production webhook لما تفعّل الـ workflow)
  static const String webhookUrl =
      'https://YOUR-N8N-INSTANCE.app.n8n.cloud/webhook/customer-support';

  /// Sends the user's message + session_id to n8n and returns the reply text.
  static Future<String> sendMessage({
    required String message,
    required String sessionId,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse(webhookUrl),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'message': message, 'session_id': sessionId}),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Expecting: { "reply": "..." }
        if (data is Map && data.containsKey('reply')) {
          return data['reply'].toString();
        }
        // Fallback in case n8n returns a list (common with "Respond to Webhook")
        if (data is List && data.isNotEmpty && data[0]['reply'] != null) {
          return data[0]['reply'].toString();
        }
        return 'عذرًا، حصل خطأ في قراءة الرد.';
      } else {
        return 'حصل خطأ (${response.statusCode})، حاول تاني بعد شوية.';
      }
    } catch (e) {
      return 'فشل الاتصال بالسيرفر. تأكد من اتصال الإنترنت وحاول تاني.';
    }
  }
}

// ------------------------------------------------------------
// 3) Session ID handling — persists per device/user across app opens
// ------------------------------------------------------------
class SessionManager {
  static const _key = 'support_session_id';

  static Future<String> getOrCreateSessionId() async {
    final prefs = await SharedPreferences.getInstance();
    String? existing = prefs.getString(_key);
    if (existing != null) return existing;

    final newId = const Uuid().v4();
    await prefs.setString(_key, newId);
    return newId;
  }

  /// Call this if you want to start a fresh conversation (clears memory context on n8n side too,
  /// since your n8n memory node is keyed by session_id).
  static Future<String> resetSession() async {
    final prefs = await SharedPreferences.getInstance();
    final newId = const Uuid().v4();
    await prefs.setString(_key, newId);
    return newId;
  }
}

// ------------------------------------------------------------
// 4) The Chat Screen
// ------------------------------------------------------------
class SupportChatScreen extends StatefulWidget {
  const SupportChatScreen({super.key});

  @override
  State<SupportChatScreen> createState() => _SupportChatScreenState();
}

class _SupportChatScreenState extends State<SupportChatScreen> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String? _sessionId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initSession();
  }

  Future<void> _initSession() async {
    final id = await SessionManager.getOrCreateSessionId();
    setState(() {
      _sessionId = id;
      _messages.add(
        ChatMessage(
          text:
              'أهلاً بيك في خدمة عملاء تطبيق "الأخبار" 📰\nاسألني عن الأخبار، التنبيهات، الاشتراك، أو أي مشكلة في حسابك.',
          isUser: false,
        ),
      );
    });
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _sessionId == null || _isLoading) return;

    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true));
      _isLoading = true;
    });
    _controller.clear();
    _scrollToBottom();

    final reply = await SupportApiService.sendMessage(
      message: text,
      sessionId: _sessionId!,
    );

    setState(() {
      _messages.add(ChatMessage(text: reply, isUser: false));
      _isLoading = false;
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 80,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _startNewConversation() async {
    final newId = await SessionManager.resetSession();
    setState(() {
      _sessionId = newId;
      _messages.clear();
      _messages.add(
        ChatMessage(
          text: 'تم بدء محادثة جديدة 📰 إزاي أقدر أساعدك؟',
          isUser: false,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الدعم الفني - تطبيق الأخبار'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'محادثة جديدة',
            onPressed: _startNewConversation,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _ChatBubble(message: _messages[index]);
              },
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: _TypingIndicator(),
            ),
          _MessageInputBar(
            controller: _controller,
            onSend: _sendMessage,
            enabled: !_isLoading,
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------
// 5) Chat bubble widget
// ------------------------------------------------------------
class _ChatBubble extends StatelessWidget {
  final ChatMessage message;
  const _ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    final theme = Theme.of(context);

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isUser
              ? theme.colorScheme.primary
              : theme.colorScheme.surfaceVariant,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isUser ? 16 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 16),
          ),
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: isUser
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.onSurfaceVariant,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}

// ------------------------------------------------------------
// 6) Typing indicator (shown while waiting for n8n response)
// ------------------------------------------------------------
class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(right: 90, left: 16),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: 8),
            Text(
              'المساعد بيكتب...',
              style: TextStyle(
                color: Theme.of(context).colorScheme.outline,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------------------------
// 7) Input bar (text field + send button)
// ------------------------------------------------------------
class _MessageInputBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final bool enabled;

  const _MessageInputBar({
    required this.controller,
    required this.onSend,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                enabled: enabled,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => onSend(),
                decoration: InputDecoration(
                  hintText: 'اكتب رسالتك...',
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surfaceVariant,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              onPressed: enabled ? onSend : null,
              icon: const Icon(Icons.send),
            ),
          ],
        ),
      ),
    );
  }
}
