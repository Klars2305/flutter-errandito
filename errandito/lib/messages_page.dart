import 'package:flutter/material.dart';

class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});

  static const Color background = Color(0xFFF8F9FD);
  static const Color navy = Color(0xFF003C56);
  static const Color darkText = Color(0xFF191C1E);
  static const Color bodyText = Color(0xFF40484E);
  static const Color mutedText = Color(0xFF71787E);
  static const Color lightPanel = Color(0xFFF2F3F7);

  static const List<MessageItem> ongoing = [
    MessageItem(
      name: 'Jojie Rodriguez',
      time: '14:22',
      text: "I've just arrived at the florist...",
      image: 'assets/images/helper.png',
      badge: 'IN-PROGRESS',
      active: true,
    ),
    MessageItem(
      name: 'Aaliyah Marial',
      time: '12:05',
      text: 'Sent a photo of the grocery...',
      image: 'assets/images/helper_female.png',
      badge: 'PENDING APPROVAL',
      active: false,
    ),
  ];

  static const List<String> past = [
    'Christian Misal',
    'Jerlyn Corpuz',
    'Patrick Acedo',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: Stack(
        children: [
          Column(
            children: [
              SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Messages',
                      style: TextStyle(
                        color: navy,
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 140),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 430),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 17,
                            ),
                            decoration: BoxDecoration(
                              color: lightPanel,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Text(
                              'Search conversations...',
                              style: TextStyle(
                                color: mutedText,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),

                          const SizedBox(height: 22),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: const [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'ACTIVE NOW',
                                    style: TextStyle(
                                      color: navy,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'Ongoing Errands',
                                    style: TextStyle(
                                      color: darkText,
                                      fontSize: 28,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '2 Active',
                                style: TextStyle(
                                  color: navy,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          Column(
                            children: ongoing.map((item) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 14),
                                child: MessageCard(item: item),
                              );
                            }).toList(),
                          ),

                          const SizedBox(height: 8),

                          const Text(
                            'Past Conversations',
                            style: TextStyle(
                              color: darkText,
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                            ),
                          ),

                          const SizedBox(height: 12),

                          Column(
                            children: past.map((name) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: PastConversationItem(name: name),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const Align(
            alignment: Alignment.bottomCenter,
            child: RequesterBottomNav(active: 'messages'),
          ),
        ],
      ),
    );
  }
}

class MessageCard extends StatelessWidget {
  final MessageItem item;

  const MessageCard({
    super.key,
    required this.item,
  });

  static const Color navy = Color(0xFF003C56);
  static const Color bodyText = Color(0xFF40484E);
  static const Color mutedText = Color(0xFF71787E);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(32),
      child: InkWell(
        borderRadius: BorderRadius.circular(32),
        onTap: () {
          Navigator.pushNamed(context, '/coordination');
        },
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: SizedBox(
                  width: 64,
                  height: 64,
                  child: Image.asset(
                    item.image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: const Color(0xFFD6E5EC),
                        child: const Icon(
                          Icons.person,
                          color: navy,
                          size: 34,
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            item.name,
                            style: const TextStyle(
                              color: Color(0xFF191C1E),
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        Text(
                          item.time,
                          style: const TextStyle(
                            color: mutedText,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.text,
                      style: TextStyle(
                        color: item.active ? navy : bodyText,
                        fontSize: 14,
                        fontWeight:
                            item.active ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: item.active
                            ? const Color(0xFFC7E7FF)
                            : const Color(0xFFD6E5EC),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        item.badge,
                        style: TextStyle(
                          color: item.active
                              ? const Color(0xFF001E2E)
                              : const Color(0xFF58676D),
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PastConversationItem extends StatelessWidget {
  final String name;

  const PastConversationItem({
    super.key,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F3F7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: const TextStyle(
              color: Color(0xFF40484E),
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Text(
            'Completed',
            style: TextStyle(
              color: Color(0xFF95D3C3),
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class MessageItem {
  final String name;
  final String time;
  final String text;
  final String image;
  final String badge;
  final bool active;

  const MessageItem({
    required this.name,
    required this.time,
    required this.text,
    required this.image,
    required this.badge,
    required this.active,
  });
}

class RequesterBottomNav extends StatelessWidget {
  final String active;

  const RequesterBottomNav({
    super.key,
    required this.active,
  });

  static const Color navy = Color(0xFF003C56);
  static const Color inactive = Color(0xFF94A3B8);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 97,
      padding: const EdgeInsets.fromLTRB(8, 14, 8, 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.80),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF191C1E).withOpacity(0.04),
            blurRadius: 24,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: NavItem(
              icon: Icons.home_outlined,
              label: 'Home',
              isActive: active == 'home',
              onTap: () {
                Navigator.pushNamed(context, '/home-dashboard');
              },
            ),
          ),
          Expanded(
            child: NavItem(
              icon: Icons.grid_view_outlined,
              label: 'Services',
              isActive: active == 'services',
              onTap: () {
                Navigator.pushNamed(context, '/servicehub');
              },
            ),
          ),
          Expanded(
            child: NavItem(
              icon: Icons.chat_bubble_outline,
              label: 'Messages',
              isActive: active == 'messages',
              onTap: () {},
            ),
          ),
          Expanded(
            child: NavItem(
              icon: Icons.receipt_long_outlined,
              label: 'Activity',
              isActive: active == 'activity',
              onTap: () {
                Navigator.pushNamed(context, '/activity');
              },
            ),
          ),
          Expanded(
            child: NavItem(
              icon: Icons.person_outline,
              label: 'Profile',
              isActive: active == 'profile',
              onTap: () {
                Navigator.pushNamed(context, '/profile');
              },
            ),
          ),
        ],
      ),
    );
  }
}

class NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const NavItem({
    super.key,
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  static const Color navy = Color(0xFF003C56);
  static const Color inactive = Color(0xFF94A3B8);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Material(
        color: isActive ? navy : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 10,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: isActive ? Colors.white : inactive,
                  size: 22,
                ),
                const SizedBox(height: 6),
                Text(
                  label,
                  style: TextStyle(
                    color: isActive ? Colors.white : inactive,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
