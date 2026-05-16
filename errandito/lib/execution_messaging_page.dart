import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'services/errand_service.dart';

class ExecutionMessagingPage extends StatefulWidget {
  const ExecutionMessagingPage({super.key});

  static const Color background = Color(0xFFF8F9FD);
  static const Color navy = Color(0xFF003C56);
  static const Color teal = Color(0xFF005477);
  static const Color bodyText = Color(0xFF40484E);
  static const Color mutedText = Color(0xFF71787E);
  static const Color borderColor = Color(0xFFE6E9EF);

  @override
  State<ExecutionMessagingPage> createState() => _ExecutionMessagingPageState();
}

class _ExecutionMessagingPageState extends State<ExecutionMessagingPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String? _errandId;
  bool _readRouteArguments = false;
  bool _isSending = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_readRouteArguments) return;
    _readRouteArguments = true;

    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is String && args.isNotEmpty) {
      _errandId = args;
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final errandId = _errandId;
    final text = _messageController.text.trim();

    if (_isSending || errandId == null || errandId.isEmpty || text.isEmpty) {
      return;
    }

    setState(() => _isSending = true);

    try {
      await ErrandService.sendMessage(errandId: errandId, text: text);
      _messageController.clear();

      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send message: $e')),
      );
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final errandId = _errandId;

    return Scaffold(
      backgroundColor: ExecutionMessagingPage.background,
      appBar: AppBar(
        backgroundColor: ExecutionMessagingPage.navy,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Live Chat',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      body: errandId == null || errandId.isEmpty
          ? const _NoErrandSelected()
          : StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: ErrandService.errandStream(errandId),
              builder: (context, errandSnapshot) {
                final errandData = errandSnapshot.data?.data() ?? {};
                final status = (errandData['status'] ?? '').toString();
                final serviceType =
                    (errandData['serviceType'] ?? errandData['title'] ?? 'Errand')
                        .toString();
                final runnerName =
                    (errandData['runnerName'] ?? 'Runner not assigned').toString();
                final requesterName =
                    (errandData['requesterName'] ?? 'Requester').toString();
                final canSend = status != 'completed';

                return Column(
                  children: [
                    _ChatHeader(
                      serviceType: serviceType,
                      status: status.isEmpty ? 'active' : status,
                      requesterName: requesterName,
                      runnerName: runnerName,
                    ),
                    Expanded(
                      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: ErrandService.messagesStream(errandId),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: ExecutionMessagingPage.navy,
                              ),
                            );
                          }

                          if (snapshot.hasError) {
                            return _ChatMessageState(
                              icon: Icons.error_outline_rounded,
                              title: 'Unable to load messages',
                              message: snapshot.error.toString(),
                            );
                          }

                          final docs = snapshot.data?.docs ?? [];
                          if (docs.isEmpty) {
                            return const _ChatMessageState(
                              icon: Icons.chat_bubble_outline_rounded,
                              title: 'No messages yet',
                              message: 'Start the conversation for this errand.',
                            );
                          }

                          return ListView.builder(
                            controller: _scrollController,
                            reverse: true,
                            padding: const EdgeInsets.fromLTRB(14, 16, 14, 16),
                            itemCount: docs.length,
                            itemBuilder: (context, index) {
                              return _MessageBubble(message: docs[index].data());
                            },
                          );
                        },
                      ),
                    ),
                    _MessageInputBar(
                      controller: _messageController,
                      isSending: _isSending,
                      canSend: canSend,
                      onSend: _sendMessage,
                    ),
                  ],
                );
              },
            ),
    );
  }
}

class _NoErrandSelected extends StatelessWidget {
  const _NoErrandSelected();

  @override
  Widget build(BuildContext context) {
    return const _ChatMessageState(
      icon: Icons.assignment_late_outlined,
      title: 'No active errand selected',
      message:
          'Open chat from an accepted task or live tracking page so the app can pass the errand ID.',
    );
  }
}

class _ChatHeader extends StatelessWidget {
  final String serviceType;
  final String status;
  final String requesterName;
  final String runnerName;

  const _ChatHeader({
    required this.serviceType,
    required this.status,
    required this.requesterName,
    required this.runnerName,
  });

  static const Color navy = ExecutionMessagingPage.navy;
  static const Color teal = ExecutionMessagingPage.teal;
  static const Color mutedText = ExecutionMessagingPage.mutedText;

  String get statusLabel {
    switch (status) {
      case 'accepted':
        return 'Accepted';
      case 'in_progress':
        return 'In Progress';
      case 'on_the_way':
        return 'On the Way';
      case 'completed':
        return 'Completed';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.black.withValues(alpha: 0.06)),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: navy.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.support_agent_rounded, color: navy),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  serviceType,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: navy,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '$requesterName • $runnerName',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: mutedText,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: teal.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              statusLabel,
              style: const TextStyle(
                color: teal,
                fontSize: 11,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final Map<String, dynamic> message;

  const _MessageBubble({required this.message});

  static const Color navy = ExecutionMessagingPage.navy;
  static const Color teal = ExecutionMessagingPage.teal;
  static const Color bodyText = ExecutionMessagingPage.bodyText;

  @override
  Widget build(BuildContext context) {
    final senderId = (message['senderId'] ?? '').toString();
    final senderName = (message['senderName'] ?? 'User').toString();
    final text = (message['text'] ?? '').toString();
    final isMe = senderId == ErrandService.currentUserId;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 310),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(
          color: isMe ? navy : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(isMe ? 18 : 4),
            bottomRight: Radius.circular(isMe ? 4 : 18),
          ),
          border: isMe
              ? null
              : Border.all(color: ExecutionMessagingPage.borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 14,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              isMe ? 'You' : senderName,
              style: TextStyle(
                color: isMe ? Colors.white70 : teal,
                fontSize: 11,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              text,
              style: TextStyle(
                color: isMe ? Colors.white : bodyText,
                fontSize: 14,
                height: 1.35,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatMessageState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  const _ChatMessageState({
    required this.icon,
    required this.title,
    required this.message,
  });

  static const Color navy = ExecutionMessagingPage.navy;
  static const Color mutedText = ExecutionMessagingPage.mutedText;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(26),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: navy, size: 42),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: navy,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: mutedText,
                fontSize: 13,
                height: 1.35,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageInputBar extends StatelessWidget {
  final TextEditingController controller;
  final bool isSending;
  final bool canSend;
  final VoidCallback onSend;

  const _MessageInputBar({
    required this.controller,
    required this.isSending,
    required this.canSend,
    required this.onSend,
  });

  static const Color navy = ExecutionMessagingPage.navy;
  static const Color mutedText = ExecutionMessagingPage.mutedText;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 18,
              offset: const Offset(0, -8),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                enabled: canSend,
                minLines: 1,
                maxLines: 4,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) {
                  if (!isSending && canSend) onSend();
                },
                decoration: InputDecoration(
                  hintText: canSend
                      ? 'Type a message...'
                      : 'This task is completed. Chat is read-only.',
                  hintStyle: const TextStyle(color: mutedText, fontSize: 14),
                  filled: true,
                  fillColor: const Color(0xFFF2F3F7),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: isSending || !canSend ? null : onSend,
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isSending || !canSend ? Colors.grey.shade400 : navy,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: isSending
                    ? const Padding(
                        padding: EdgeInsets.all(14),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.send_rounded, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
