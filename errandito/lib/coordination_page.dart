import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'services/errand_service.dart';

class CoordinationPage extends StatefulWidget {
  final bool isRunner;

  const CoordinationPage({super.key, this.isRunner = true});

  @override
  State<CoordinationPage> createState() => _CoordinationPageState();
}

class _CoordinationPageState extends State<CoordinationPage> {
  String selectedFilter = 'All';
  String searchQuery = '';

  final TextEditingController searchController = TextEditingController();

  static const Color background = Color(0xFFF8F9FD);

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void clearSearch() {
    searchController.clear();
    setState(() => searchQuery = '');
  }

  void goBackNormally() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacementNamed(context, '/runner-home');
    }
  }

  List<QueryDocumentSnapshot<Map<String, dynamic>>> _filterDocs(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
  ) {
    final currentUserId = ErrandService.currentUserId;
    final query = searchQuery.trim().toLowerCase();

    final filtered = docs.where((doc) {
      final data = doc.data();
      final serviceType = (data['serviceType'] ?? data['title'] ?? '').toString();
      final requesterName = (data['requesterName'] ?? '').toString();
      final runnerName = (data['runnerName'] ?? '').toString();
      final lastMessage = (data['lastMessage'] ?? '').toString();
      final status = (data['status'] ?? '').toString();

      final unreadBy = data['unreadBy'];
      final isUnread = unreadBy is Map &&
          currentUserId != null &&
          unreadBy[currentUserId] == true;

      final isActive = status != 'completed';
      final matchesFilter = selectedFilter == 'All' ||
          (selectedFilter == 'Unread' && isUnread) ||
          (selectedFilter == 'Active' && isActive);

      final searchableText = [
        serviceType,
        requesterName,
        runnerName,
        lastMessage,
        status,
      ].join(' ').toLowerCase();

      final matchesSearch = query.isEmpty || searchableText.contains(query);
      return matchesFilter && matchesSearch;
    }).toList();

    filtered.sort((a, b) {
      final aTime = a.data()['lastMessageAt'];
      final bTime = b.data()['lastMessageAt'];
      if (aTime is Timestamp && bTime is Timestamp) {
        return bTime.compareTo(aTime);
      }
      if (aTime is Timestamp) return -1;
      if (bTime is Timestamp) return 1;

      final aCreated = a.data()['createdAt'];
      final bCreated = b.data()['createdAt'];
      if (aCreated is Timestamp && bCreated is Timestamp) {
        return bCreated.compareTo(aCreated);
      }
      return 0;
    });

    return filtered;
  }

  int _totalUnread(List<QueryDocumentSnapshot<Map<String, dynamic>>> docs) {
    final currentUserId = ErrandService.currentUserId;
    if (currentUserId == null) return 0;

    return docs.where((doc) {
      final unreadBy = doc.data()['unreadBy'];
      return unreadBy is Map && unreadBy[currentUserId] == true;
    }).length;
  }

  Future<void> openConversation(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) async {
    await ErrandService.markConversationRead(doc.id);
    if (!mounted) return;

    Navigator.pushNamed(
      context,
      '/execution-messaging',
      arguments: doc.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool narrowScreen = screenWidth <= 390;
    final double horizontalPadding = narrowScreen ? 18 : 22;

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Stack(
          children: [
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: ErrandService.conversationsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF003C56)),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        'Unable to load conversations:\n${snapshot.error}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFF71787E),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                }

                final allDocs = snapshot.data?.docs ?? [];
                final filteredDocs = _filterDocs(allDocs);
                final unreadCount = _totalUnread(allDocs);

                return SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    16,
                    horizontalPadding,
                    112,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 430),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CoordinationHeader(
                            unreadCount: unreadCount,
                            onBackTap: goBackNormally,
                          ),
                          const SizedBox(height: 18),
                          MessageSearchBar(
                            controller: searchController,
                            onChanged: (value) {
                              setState(() => searchQuery = value);
                            },
                            onClear: clearSearch,
                          ),
                          const SizedBox(height: 14),
                          MessageFilterChips(
                            selectedFilter: selectedFilter,
                            onChanged: (filter) {
                              setState(() => selectedFilter = filter);
                            },
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              const Expanded(
                                child: Text(
                                  'Runner Conversations',
                                  style: TextStyle(
                                    color: Color(0xFF003C56),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                              ),
                              Text(
                                '${filteredDocs.length} chats',
                                style: const TextStyle(
                                  color: Color(0xFF71787E),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          RealtimeMessageList(
                            docs: filteredDocs,
                            onOpenConversation: openConversation,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            const Align(
              alignment: Alignment.bottomCenter,
              child: RunnerBottomNav(active: 'messages'),
            ),
          ],
        ),
      ),
    );
  }
}

class RealtimeMessageList extends StatelessWidget {
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> docs;
  final ValueChanged<QueryDocumentSnapshot<Map<String, dynamic>>> onOpenConversation;

  const RealtimeMessageList({
    super.key,
    required this.docs,
    required this.onOpenConversation,
  });

  @override
  Widget build(BuildContext context) {
    if (docs.isEmpty) return const EmptyMessagesState();

    return Column(
      children: docs.map((doc) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: RealtimeMessageTile(
            doc: doc,
            onTap: () => onOpenConversation(doc),
          ),
        );
      }).toList(),
    );
  }
}

class RealtimeMessageTile extends StatelessWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> doc;
  final VoidCallback onTap;

  const RealtimeMessageTile({
    super.key,
    required this.doc,
    required this.onTap,
  });

  static const Color navy = Color(0xFF003C56);
  static const Color teal = Color(0xFF005477);
  static const Color mutedText = Color(0xFF71787E);
  static const Color borderColor = Color(0xFFE6E9EF);

  String _otherPersonName(Map<String, dynamic> data) {
    final currentUserId = ErrandService.currentUserId;
    final requesterId = (data['requesterId'] ?? '').toString();
    final requesterName = (data['requesterName'] ?? 'Requester').toString();
    final runnerId = (data['runnerId'] ?? '').toString();
    final runnerName = (data['runnerName'] ?? '').toString();

    if (currentUserId == runnerId) return requesterName;
    if (currentUserId == requesterId) {
      return runnerName.isEmpty || runnerName == 'null'
          ? 'Waiting for runner'
          : runnerName;
    }
    return requesterName.isNotEmpty ? requesterName : runnerName;
  }

  String _role(Map<String, dynamic> data) {
    final currentUserId = ErrandService.currentUserId;
    final runnerId = (data['runnerId'] ?? '').toString();
    if (currentUserId == runnerId) return 'Requester';
    return 'Runner';
  }

  String _timeText(Map<String, dynamic> data) {
    final lastMessageAt = data['lastMessageAt'];
    final createdAt = data['createdAt'];
    Timestamp? timestamp;
    if (lastMessageAt is Timestamp) {
      timestamp = lastMessageAt;
    } else if (createdAt is Timestamp) {
      timestamp = createdAt;
    }
    if (timestamp == null) return '';

    final date = timestamp.toDate();
    final now = DateTime.now();
    final difference = now.difference(date);
    if (difference.inMinutes < 1) return 'Now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    if (difference.inDays == 1) return 'Yesterday';
    if (difference.inDays < 7) return '${difference.inDays}d ago';
    return '${date.month}/${date.day}/${date.year}';
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'pending_payment':
        return 'Pending';
      case 'posted':
      case 'paid':
      case 'booked':
      case 'booked_paid':
        return 'Pending';
      case 'accepted':
        return 'Accepted';
      case 'in_progress':
        return 'In Progress';
      case 'on_the_way':
        return 'On the Way';
      case 'completed':
        return 'Completed';
      default:
        return status.isEmpty ? 'Active' : status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = doc.data();
    final currentUserId = ErrandService.currentUserId;
    final unreadBy = data['unreadBy'];
    final unread = unreadBy is Map &&
        currentUserId != null &&
        unreadBy[currentUserId] == true;

    final name = _otherPersonName(data);
    final role = _role(data);
    final task = (data['serviceType'] ?? data['title'] ?? 'Errand').toString();
    final preview = (data['lastMessage'] ?? '').toString().trim().isEmpty
        ? 'No messages yet. Tap to start chatting.'
        : data['lastMessage'].toString();
    final status = _statusLabel((data['status'] ?? '').toString());
    final time = _timeText(data);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: unread ? teal.withOpacity(0.42) : borderColor,
              width: unread ? 1.4 : 1,
            ),
            boxShadow: [
              if (unread)
                BoxShadow(
                  color: teal.withOpacity(0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
            ],
          ),
          child: Row(
            children: [
              if (unread)
                Container(
                  width: 5,
                  height: 84,
                  decoration: const BoxDecoration(
                    color: teal,
                    borderRadius: BorderRadius.horizontal(
                      left: Radius.circular(18),
                    ),
                  ),
                ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(11),
                  child: Row(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: 54,
                            height: 54,
                            decoration: BoxDecoration(
                              color: navy.withOpacity(0.10),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(Icons.person_rounded, color: navy),
                          ),
                          if (status != 'Completed')
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
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: navy,
                                      fontSize: 14,
                                      fontWeight: unread ? FontWeight.w900 : FontWeight.w800,
                                    ),
                                  ),
                                ),
                                Text(
                                  time,
                                  style: TextStyle(
                                    color: unread ? teal : mutedText,
                                    fontSize: 9.5,
                                    fontWeight: unread ? FontWeight.w900 : FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 3),
                            Text(
                              '$role • $task',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: teal,
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    preview,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: unread ? navy : mutedText,
                                      fontSize: 11.2,
                                      fontWeight: unread ? FontWeight.w800 : FontWeight.w500,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                if (unread)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: teal,
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    child: const Text(
                                      '1',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  )
                                else
                                  const Icon(Icons.done_all_rounded, color: teal, size: 15),
                              ],
                            ),
                            if (unread) ...[
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: teal.withOpacity(0.10),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: const Text(
                                  'UNREAD',
                                  style: TextStyle(
                                    color: teal,
                                    fontSize: 8.5,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CoordinationHeader extends StatelessWidget {
  final int unreadCount;
  final VoidCallback onBackTap;

  const CoordinationHeader({
    super.key,
    required this.unreadCount,
    required this.onBackTap,
  });

  static const Color navy = Color(0xFF003C56);
  static const Color teal = Color(0xFF005477);
  static const Color borderColor = Color(0xFFE6E9EF);

  @override
  Widget build(BuildContext context) {
    return Row(
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
        const Expanded(
          child: Center(
            child: Text(
              'Coordination',
              style: TextStyle(
                color: navy,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
        Container(
          width: 42,
          height: 42,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: unreadCount > 0 ? teal : Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: unreadCount > 0 ? teal : borderColor),
          ),
          child: Text(
            '$unreadCount',
            style: TextStyle(
              color: unreadCount > 0 ? Colors.white : navy,
              fontSize: 12,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}

class MessageSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const MessageSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  static const Color navy = Color(0xFF003C56);
  static const Color mutedText = Color(0xFF71787E);
  static const Color borderColor = Color(0xFFE6E9EF);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.only(left: 14, right: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          const Icon(Icons.search_rounded, color: mutedText, size: 21),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              textInputAction: TextInputAction.search,
              style: const TextStyle(
                color: navy,
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
              ),
              decoration: const InputDecoration(
                hintText: 'Search conversations...',
                hintStyle: TextStyle(
                  color: mutedText,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                ),
                border: InputBorder.none,
                isCollapsed: true,
              ),
            ),
          ),
          if (controller.text.isNotEmpty)
            IconButton(
              onPressed: onClear,
              icon: const Icon(Icons.close_rounded, color: mutedText, size: 19),
            ),
        ],
      ),
    );
  }
}

class MessageFilterChips extends StatelessWidget {
  final String selectedFilter;
  final ValueChanged<String> onChanged;

  const MessageFilterChips({
    super.key,
    required this.selectedFilter,
    required this.onChanged,
  });

  static const List<String> filters = ['All', 'Unread', 'Active'];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: filters.map((filter) {
        final bool isActive = selectedFilter == filter;

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Material(
              color: isActive ? const Color(0xFF003C56) : Colors.white,
              borderRadius: BorderRadius.circular(999),
              child: InkWell(
                onTap: () => onChanged(filter),
                borderRadius: BorderRadius.circular(999),
                child: Container(
                  height: 36,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: isActive ? const Color(0xFF003C56) : const Color(0xFFE6E9EF),
                    ),
                  ),
                  child: Text(
                    filter,
                    style: TextStyle(
                      color: isActive ? Colors.white : const Color(0xFF71787E),
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class EmptyMessagesState extends StatelessWidget {
  const EmptyMessagesState({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE6E9EF)),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.chat_bubble_outline_rounded,
            color: Color(0xFF003C56),
            size: 34,
          ),
          SizedBox(height: 10),
          Text(
            'No conversations found',
            style: TextStyle(
              color: Color(0xFF003C56),
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Accepted errands and requester chats will appear here.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF71787E),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class RunnerBottomNav extends StatelessWidget {
  final String active;

  const RunnerBottomNav({super.key, required this.active});

  static const Color navy = Color(0xFF003C56);
  static const Color inactive = Color(0xFF94A3B8);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(18, 0, 18, 14),
      child: Container(
        height: 76,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.96),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: RunnerNavItem(
                icon: Icons.search_outlined,
                activeIcon: Icons.search_rounded,
                label: 'Gigs',
                isActive: active == 'gigs',
                onTap: () => Navigator.pushReplacementNamed(context, '/gig-finder'),
              ),
            ),
            Expanded(
              child: RunnerNavItem(
                icon: Icons.receipt_long_outlined,
                activeIcon: Icons.receipt_long_rounded,
                label: 'Tasks',
                isActive: active == 'tasks',
                onTap: () => Navigator.pushReplacementNamed(context, '/execution-status'),
              ),
            ),
            Expanded(
              child: RunnerNavItem(
                icon: Icons.chat_bubble_outline_rounded,
                activeIcon: Icons.chat_bubble_rounded,
                label: 'Messages',
                isActive: active == 'messages' || active == 'runner-messages',
                onTap: () => Navigator.pushReplacementNamed(context, '/runner-messages'),
              ),
            ),
            Expanded(
              child: RunnerNavItem(
                icon: Icons.person_outline_rounded,
                activeIcon: Icons.person_rounded,
                label: 'Profile',
                isActive: active == 'profile',
                onTap: () => Navigator.pushReplacementNamed(context, '/runner-profile'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RunnerNavItem extends StatefulWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const RunnerNavItem({
    super.key,
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<RunnerNavItem> createState() => _RunnerNavItemState();
}

class _RunnerNavItemState extends State<RunnerNavItem> {
  bool hovered = false;
  static const Color navy = Color(0xFF003C56);
  static const Color inactive = Color(0xFF94A3B8);

  @override
  Widget build(BuildContext context) {
    final bool activeOrHover = widget.isActive || hovered;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => hovered = true),
      onExit: (_) => setState(() => hovered = false),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          height: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: widget.isActive
                ? navy
                : hovered
                    ? const Color(0xFFEAF3F6)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                activeOrHover ? widget.activeIcon : widget.icon,
                color: widget.isActive ? Colors.white : (hovered ? navy : inactive),
                size: 21,
              ),
              const SizedBox(height: 5),
              Text(
                widget.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: widget.isActive ? Colors.white : (hovered ? navy : inactive),
                  fontSize: 10,
                  fontWeight: activeOrHover ? FontWeight.w800 : FontWeight.w600,
                  height: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

