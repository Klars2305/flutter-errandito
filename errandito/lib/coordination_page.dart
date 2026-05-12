import 'package:flutter/material.dart';

class CoordinationChatPage extends StatelessWidget {
  const CoordinationChatPage({super.key});

  static const Color background = Color(0xFFF8F9FD);
  static const Color navy = Color(0xFF003C56);
  static const Color green = Color(0xFF004035);
  static const Color grayText = Color(0xFF536167);
  static const Color secureText = Color(0xFF58676D);
  static const Color lightPanel = Color(0xFFF2F3F7);
  static const Color borderColor = Color(0xFFECEEF1);

  static const List<ChatMessage> messages = [
    ChatMessage(
      side: ChatSide.left,
      text: 'Good pm, boss. naa nako sa grocerihan, naa pa kay gusto ipapalit?',
      time: '09:12 AM',
    ),
    ChatMessage(
      side: ChatSide.right,
      text: 'Paapil nalag palit ug loaf bread mga lima.',
      time: '09:14 AM',
    ),
    ChatMessage(
      side: ChatSide.left,
      text: 'Ok boss, noted!',
      time: '09:28 AM',
      tag: 'Inventory Check',
    ),
    ChatMessage(
      side: ChatSide.right,
      text:
          "Perfect, thank you! One last change: I won't be home until 11:30 AM. Is it okay to leave the bags with the concierge?",
      time: '09:30 AM',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: Column(
        children: [
          SafeArea(
            bottom: false,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 16,
              ),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: borderColor,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              Navigator.pushNamed(context, '/message');
                            },
                            child: const SizedBox(
                              width: 32,
                              height: 32,
                              child: Center(
                                child: Text(
                                  '←',
                                  style: TextStyle(
                                    color: navy,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: SizedBox(
                            width: 26,
                            height: 40,
                            child: Image.asset(
                              'assets/images/helper.png',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: const Color(0xFFE1E2E6),
                                  child: const Icon(
                                    Icons.person,
                                    color: navy,
                                    size: 20,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Bronny James',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: navy,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Active Now • Professional Steward',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: grayText,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Material(
                    color: navy,
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        Navigator.pushNamed(context, '/live-tracking');
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        child: Text(
                          'Live Tracking',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 20,
              ),
              children: [
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: lightPanel,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Today',
                      style: TextStyle(
                        color: grayText,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                ...messages.map(
                  (message) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: ChatBubble(message: message),
                  ),
                ),

                const SizedBox(height: 8),

                Center(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 280),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD8DADD).withOpacity(0.30),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'Your connection is secured with end-to-end encryption by Steward Safety Protocol.',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: secureText,
                        fontSize: 11,
                        height: 1.35,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SafeArea(
            top: false,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 16,
              ),
              child: Row(
                children: [
                  Material(
                    color: lightPanel,
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {},
                      child: const SizedBox(
                        width: 36,
                        height: 36,
                        child: Icon(
                          Icons.add,
                          color: navy,
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Message Bronny...',
                        filled: true,
                        fillColor: lightPanel,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(999),
                          borderSide: BorderSide.none,
                        ),
                        hintStyle: const TextStyle(
                          color: grayText,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Material(
                    color: navy,
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {},
                      child: const SizedBox(
                        width: 36,
                        height: 36,
                        child: Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({
    super.key,
    required this.message,
  });

  static const Color navy = Color(0xFF003C56);
  static const Color green = Color(0xFF004035);
  static const Color grayText = Color(0xFF536167);

  @override
  Widget build(BuildContext context) {
    final bool isRight = message.side == ChatSide.right;

    return Align(
      alignment: isRight ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        child: Column(
          crossAxisAlignment:
              isRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (message.tag != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F4EF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  message.tag!,
                  style: const TextStyle(
                    color: green,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 6),
            ],
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isRight ? navy : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: isRight
                    ? null
                    : const Border(
                        left: BorderSide(
                          color: navy,
                          width: 4,
                        ),
                      ),
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: isRight ? Colors.white : Colors.black,
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                message.time,
                style: const TextStyle(
                  color: grayText,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessage {
  final ChatSide side;
  final String text;
  final String time;
  final String? tag;

  const ChatMessage({
    required this.side,
    required this.text,
    required this.time,
    this.tag,
  });
}

enum ChatSide {
  left,
  right,
}
