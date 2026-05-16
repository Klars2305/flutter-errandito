import 'package:flutter/material.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  String selectedFilter = 'All';
  String searchQuery = '';

  final TextEditingController searchController = TextEditingController();

  static const Color background = Color(0xFFF8F9FD);

  late List<MessageItem> messages;

  @override
  void initState() {
    super.initState();

    messages = const [
      MessageItem(
        name: 'Ella Cruz',
        role: 'Requester',
        task: 'Courier Parcel Pickup',
        time: '10:42 PM',
        preview: 'Can you send a photo once you arrive at JRS?',
        image: 'assets/images/helper_female.png',
        status: 'In Progress',
        unreadCount: 2,
        isUnread: true,
      ),
      MessageItem(
        name: 'Mia Santos',
        role: 'Requester',
        task: 'Meal Pickup',
        time: '4 hours ago',
        preview: 'Please check if the drinks are included.',
        image: 'assets/images/helper.png',
        status: 'Pending',
        unreadCount: 1,
        isUnread: true,
      ),
      MessageItem(
        name: 'John Reyes',
        role: 'Requester',
        task: 'Print Project Files',
        time: '5 hours ago',
        preview: 'The file is already sent. Please keep the receipt.',
        image: 'assets/images/steward.png',
        status: 'Accepted',
        unreadCount: 0,
        isUnread: false,
      ),
      MessageItem(
        name: 'Ana Corpuz',
        role: 'Requester',
        task: 'Laundry Pickup',
        time: 'Yesterday',
        preview: 'Thank you. I received the laundry.',
        image: 'assets/images/helper_female.png',
        status: 'Completed',
        unreadCount: 0,
        isUnread: false,
      ),
      MessageItem(
        name: 'Ralph Dela Cruz',
        role: 'Requester',
        task: 'School Supplies',
        time: '23/05/2024',
        preview: 'The notebook and pens are correct.',
        image: 'assets/images/profile.png',
        status: 'Completed',
        unreadCount: 0,
        isUnread: false,
      ),
    ];
  }

  int get totalUnread {
    return messages.fold<int>(0, (sum, message) => sum + message.unreadCount);
  }

  List<MessageItem> get filteredMessages {
    final String query = searchQuery.trim().toLowerCase();

    return messages.where((message) {
      final bool matchesFilter =
          selectedFilter == 'All' ||
          (selectedFilter == 'Unread' && message.isUnread) ||
          (selectedFilter == 'Active' && message.status != 'Completed');

      final bool matchesSearch =
          query.isEmpty ||
          message.name.toLowerCase().contains(query) ||
          message.role.toLowerCase().contains(query) ||
          message.task.toLowerCase().contains(query) ||
          message.preview.toLowerCase().contains(query) ||
          message.status.toLowerCase().contains(query);

      return matchesFilter && matchesSearch;
    }).toList();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void clearSearch() {
    searchController.clear();

    setState(() {
      searchQuery = '';
    });
  }

  void openConversation(MessageItem item) {
    final int index = messages.indexOf(item);

    if (index != -1) {
      setState(() {
        messages[index] = item.copyWith(isUnread: false, unreadCount: 0);
      });
    }

    Navigator.pushNamed(
      context,
      '/coordination',
      arguments: {
        'name': item.name,
        'role': item.role,
        'task': item.task,
        'image': item.image,
        'status': item.status,
      },
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
            SingleChildScrollView(
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
                      MessagesHeader(
                        unreadCount: totalUnread,
                        onBackTap: () {
                          Navigator.pushNamed(context, '/home-dashboard');
                        },
                      ),

                      const SizedBox(height: 18),

                      MessageSearchBar(
                        controller: searchController,
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value;
                          });
                        },
                        onClear: clearSearch,
                      ),

                      const SizedBox(height: 14),

                      MessageFilterChips(
                        selectedFilter: selectedFilter,
                        onChanged: (filter) {
                          setState(() {
                            selectedFilter = filter;
                          });
                        },
                      ),

                      const SizedBox(height: 20),

                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Errand Conversations',
                              style: TextStyle(
                                color: Color(0xFF003C56),
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.2,
                              ),
                            ),
                          ),
                          Text(
                            '${filteredMessages.length} chats',
                            style: const TextStyle(
                              color: Color(0xFF71787E),
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      MessageList(
                        messages: filteredMessages,
                        onOpenConversation: openConversation,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const Align(
              alignment: Alignment.bottomCenter,
              child: RequesterBottomNav(active: 'messages'),
            ),
          ],
        ),
      ),
    );
  }
}

class MessagesHeader extends StatelessWidget {
  final int unreadCount;
  final VoidCallback onBackTap;

  const MessagesHeader({
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
              'Messages',
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
                onTap: () {
                  onChanged(filter);
                },
                borderRadius: BorderRadius.circular(999),
                child: Container(
                  height: 36,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: isActive
                          ? const Color(0xFF003C56)
                          : const Color(0xFFE6E9EF),
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

class MessageList extends StatelessWidget {
  final List<MessageItem> messages;
  final ValueChanged<MessageItem> onOpenConversation;

  const MessageList({
    super.key,
    required this.messages,
    required this.onOpenConversation,
  });

  @override
  Widget build(BuildContext context) {
    if (messages.isEmpty) {
      return const EmptyMessagesState();
    }

    return Column(
      children: messages
          .map(
            (message) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: MessageTile(
                item: message,
                onTap: () {
                  onOpenConversation(message);
                },
              ),
            ),
          )
          .toList(),
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
        border: Border.all(color: Color(0xFFE6E9EF)),
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
            'Try another search or filter.',
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

class MessageTile extends StatelessWidget {
  final MessageItem item;
  final VoidCallback onTap;

  const MessageTile({super.key, required this.item, required this.onTap});

  static const Color navy = Color(0xFF003C56);
  static const Color teal = Color(0xFF005477);
  static const Color mutedText = Color(0xFF71787E);
  static const Color borderColor = Color(0xFFE6E9EF);

  @override
  Widget build(BuildContext context) {
    final bool unread = item.isUnread && item.unreadCount > 0;

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
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset(
                              item.image,
                              width: 54,
                              height: 54,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 54,
                                  height: 54,
                                  color: navy.withOpacity(0.10),
                                  child: const Icon(
                                    Icons.person_rounded,
                                    color: navy,
                                  ),
                                );
                              },
                            ),
                          ),
                          if (item.status != 'Completed')
                            Positioned(
                              right: -1,
                              bottom: -1,
                              child: Container(
                                width: 13,
                                height: 13,
                                decoration: BoxDecoration(
                                  color: teal,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
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
                                    item.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: navy,
                                      fontSize: 14,
                                      fontWeight: unread
                                          ? FontWeight.w900
                                          : FontWeight.w800,
                                    ),
                                  ),
                                ),
                                Text(
                                  item.time,
                                  style: TextStyle(
                                    color: unread ? teal : mutedText,
                                    fontSize: 9.5,
                                    fontWeight: unread
                                        ? FontWeight.w900
                                        : FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 3),

                            Text(
                              item.task,
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
                                    item.preview,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: unread ? navy : mutedText,
                                      fontSize: 11.2,
                                      fontWeight: unread
                                          ? FontWeight.w800
                                          : FontWeight.w500,
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 8),

                                if (unread)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: teal,
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    child: Text(
                                      '${item.unreadCount}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  )
                                else
                                  const Icon(
                                    Icons.done_all_rounded,
                                    color: teal,
                                    size: 15,
                                  ),
                              ],
                            ),

                            if (unread) ...[
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
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

class MessageItem {
  final String name;
  final String role;
  final String task;
  final String time;
  final String preview;
  final String image;
  final String status;
  final int unreadCount;
  final bool isUnread;

  const MessageItem({
    required this.name,
    required this.role,
    required this.task,
    required this.time,
    required this.preview,
    required this.image,
    required this.status,
    required this.unreadCount,
    required this.isUnread,
  });

  MessageItem copyWith({
    String? name,
    String? role,
    String? task,
    String? time,
    String? preview,
    String? image,
    String? status,
    int? unreadCount,
    bool? isUnread,
  }) {
    return MessageItem(
      name: name ?? this.name,
      role: role ?? this.role,
      task: task ?? this.task,
      time: time ?? this.time,
      preview: preview ?? this.preview,
      image: image ?? this.image,
      status: status ?? this.status,
      unreadCount: unreadCount ?? this.unreadCount,
      isUnread: isUnread ?? this.isUnread,
    );
  }
}

class RequesterBottomNav extends StatelessWidget {
  final String active;

  const RequesterBottomNav({super.key, required this.active});

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
              child: NavItem(
                icon: Icons.home_outlined,
                activeIcon: Icons.home_rounded,
                label: 'Home',
                isActive: active == 'home',
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/home');
                },
              ),
            ),
            Expanded(
              child: NavItem(
                icon: Icons.grid_view_rounded,
                activeIcon: Icons.grid_view_rounded,
                label: 'Services',
                isActive: active == 'services',
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/servicehub');
                },
              ),
            ),
            Expanded(
              child: NavItem(
                icon: Icons.chat_bubble_outline_rounded,
                activeIcon: Icons.chat_bubble_rounded,
                label: 'Messages',
                isActive: active == 'messages',
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/messages');
                },
              ),
            ),
            Expanded(
              child: NavItem(
                icon: Icons.assignment_outlined,
                activeIcon: Icons.assignment_rounded,
                label: 'Activity',
                isActive: active == 'activity',
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/activity');
                },
              ),
            ),
            Expanded(
              child: NavItem(
                icon: Icons.person_outline_rounded,
                activeIcon: Icons.person_rounded,
                label: 'Profile',
                isActive: active == 'profile',
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/profile');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const NavItem({
    super.key,
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  static const Color navy = Color(0xFF003C56);
  static const Color inactive = Color(0xFF94A3B8);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        height: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: isActive ? navy : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: isActive ? Colors.white : inactive,
              size: 21,
            ),
            const SizedBox(height: 5),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: isActive ? Colors.white : inactive,
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
