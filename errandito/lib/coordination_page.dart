import 'package:flutter/material.dart';
import 'messages_page.dart';

class CoordinationChatPage extends StatefulWidget {
  const CoordinationChatPage({super.key});

  @override
  State<CoordinationChatPage> createState() => _CoordinationChatPageState();
}

class _CoordinationChatPageState extends State<CoordinationChatPage> {
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  final List<ChatMessage> messages = [
    const ChatMessage(
      text: 'Hi! I accepted your parcel pickup errand.',
      time: '9:16 AM',
      isMine: true,
    ),
    const ChatMessage(
      text: 'Thank you! Please pick it up at JRS Panabo.',
      time: '9:17 AM',
      isMine: false,
    ),
    const ChatMessage(
      text: 'Got it. Is the parcel already paid?',
      time: '9:18 AM',
      isMine: true,
    ),
    const ChatMessage(
      text: 'Yes, it is already paid. Just bring your valid ID.',
      time: '9:18 AM',
      isMine: false,
    ),
    const ChatMessage(
      text: 'Okay. I’ll update the task status once I arrive.',
      time: '9:19 AM',
      isMine: true,
    ),
  ];

  @override
  void dispose() {
    messageController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void sendMessage() {
    final String text = messageController.text.trim();

    if (text.isEmpty) {
      return;
    }

    setState(() {
      messages.add(ChatMessage(text: text, time: 'Now', isMine: true));
      messageController.clear();
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Object? argument = ModalRoute.of(context)?.settings.arguments;

    final MessageItem? conversation = argument is MessageItem ? argument : null;

    final String name = conversation?.name ?? 'Ella Cruz';
    final String task = conversation?.task ?? 'Courier Parcel Pickup';
    final String image =
        conversation?.image ?? 'assets/images/helper_female.png';
    final String status = conversation?.status ?? 'In Progress';

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      body: SafeArea(
        child: Column(
          children: [
            ChatHeader(
              name: name,
              image: image,
              onBackTap: () {
                Navigator.pop(context);
              },
              onStatusTap: () {
                Navigator.pushNamed(context, '/execution-status');
              },
            ),

            TaskContextCard(task: task, status: status),

            Expanded(
              child: ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
                physics: const BouncingScrollPhysics(),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return ChatBubble(message: messages[index]);
                },
              ),
            ),

            ChatInputBar(controller: messageController, onSend: sendMessage),
          ],
        ),
      ),
    );
  }
}

class ChatHeader extends StatelessWidget {
  final String name;
  final String image;
  final VoidCallback onBackTap;
  final VoidCallback onStatusTap;

  const ChatHeader({
    super.key,
    required this.name,
    required this.image,
    required this.onBackTap,
    required this.onStatusTap,
  });

  static const Color navy = Color(0xFF003C56);
  static const Color mutedText = Color(0xFF71787E);
  static const Color borderColor = Color(0xFFE6E9EF);
  static const Color teal = Color(0xFF005477);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 10),
      child: Row(
        children: [
          Material(
            color: Colors.white,
            shape: const CircleBorder(),
            child: InkWell(
              onTap: onBackTap,
              customBorder: const CircleBorder(),
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: borderColor),
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: navy,
                  size: 18,
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          Stack(
            clipBehavior: Clip.none,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(17),
                child: Image.asset(
                  image,
                  width: 44,
                  height: 44,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 44,
                      height: 44,
                      color: navy.withOpacity(0.10),
                      child: const Icon(Icons.person_rounded, color: navy),
                    );
                  },
                ),
              ),
              Positioned(
                right: -1,
                bottom: -1,
                child: Container(
                  width: 13,
                  height: 13,
                  decoration: BoxDecoration(
                    color: teal,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(width: 11),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: navy,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Requester • Active now',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: mutedText,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          Material(
            color: Colors.white,
            shape: const CircleBorder(),
            child: InkWell(
              onTap: onStatusTap,
              customBorder: const CircleBorder(),
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: borderColor),
                ),
                child: const Icon(
                  Icons.receipt_long_outlined,
                  color: navy,
                  size: 22,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TaskContextCard extends StatelessWidget {
  final String task;
  final String status;

  const TaskContextCard({super.key, required this.task, required this.status});

  static const Color navy = Color(0xFF003C56);
  static const Color teal = Color(0xFF005477);
  static const Color mutedText = Color(0xFF71787E);
  static const Color borderColor = Color(0xFFE6E9EF);

  @override
  Widget build(BuildContext context) {
    final bool completed = status.toLowerCase() == 'completed';

    return Container(
      margin: const EdgeInsets.fromLTRB(18, 4, 18, 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: navy.withOpacity(0.08),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.local_shipping_outlined,
              color: navy,
              size: 21,
            ),
          ),

          const SizedBox(width: 11),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: navy,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                const Text(
                  'Coordinate pickup, changes, and delivery updates.',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: mutedText,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
            decoration: BoxDecoration(
              color: teal.withOpacity(completed ? 0.06 : 0.10),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              completed ? 'Done' : 'Active',
              style: const TextStyle(
                color: teal,
                fontSize: 10,
                fontWeight: FontWeight.w900,
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

  const ChatBubble({super.key, required this.message});

  static const Color navy = Color(0xFF003C56);
  static const Color mutedText = Color(0xFF71787E);
  static const Color borderColor = Color(0xFFE6E9EF);

  @override
  Widget build(BuildContext context) {
    final bool isMine = message.isMine;

    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(
          crossAxisAlignment: isMine
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Container(
              constraints: const BoxConstraints(maxWidth: 286),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
              decoration: BoxDecoration(
                color: isMine ? navy : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(isMine ? 18 : 4),
                  bottomRight: Radius.circular(isMine ? 4 : 18),
                ),
                border: isMine ? null : Border.all(color: borderColor),
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: isMine ? Colors.white : navy,
                  fontSize: 12.5,
                  height: 1.35,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              message.time,
              style: const TextStyle(
                color: mutedText,
                fontSize: 9.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatInputBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const ChatInputBar({
    super.key,
    required this.controller,
    required this.onSend,
  });

  static const Color navy = Color(0xFF003C56);
  static const Color mutedText = Color(0xFF71787E);
  static const Color borderColor = Color(0xFFE6E9EF);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(18, 8, 18, 14),
      child: Row(
        children: [
          Material(
            color: Colors.white,
            shape: const CircleBorder(),
            child: InkWell(
              onTap: () {},
              customBorder: const CircleBorder(),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: borderColor),
                ),
                child: const Icon(Icons.add_rounded, color: navy, size: 24),
              ),
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: borderColor),
              ),
              child: TextField(
                controller: controller,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => onSend(),
                style: const TextStyle(
                  color: navy,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
                decoration: const InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: TextStyle(
                    color: mutedText,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),

          const SizedBox(width: 10),

          Material(
            color: navy,
            shape: const CircleBorder(),
            child: InkWell(
              onTap: onSend,
              customBorder: const CircleBorder(),
              child: const SizedBox(
                width: 46,
                height: 46,
                child: Icon(Icons.send_rounded, color: Colors.white, size: 21),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final String time;
  final bool isMine;

  const ChatMessage({
    required this.text,
    required this.time,
    required this.isMine,
  });
}
