import 'package:flutter/material.dart';

// ==========================================
// --- Constants & Theme Colors ---
// (Matching previously established style)
// ==========================================
const Color kPrimaryBlack = Color(0xFF1A1A1A);
const Color kSecondaryGrey = Color(0xFF828282);
const Color kLightGreyBg = Color(0xFFF5F5F5);
const Color kYellowColor = Color(0xFFEED202);
const Color kBgWhite = Colors.white;
const Color kBorderGrey = Color(0xFFE0E0E0);

// Accent colors for different notification types
const Color kAccentGreen = Color(0xFF27AE60); // Payments
const Color kAccentBlue = Color(0xFF2F80ED); // Bookings
const Color kAccentRed = Color(0xFFEB5757); // Alerts

// ==========================================
// --- Data Models ---
// ==========================================

enum NotificationType { booking, payment, security, info }

class NotificationModel {
  final String id;
  final String title;
  final String body;
  final String timeAgo; // Using string for simplicity in this demo
  final NotificationType type;
  bool isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.timeAgo,
    required this.type,
    this.isRead = false,
  });
}

// ==========================================
// --- Main Screen Widget ---
// ==========================================

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // Dummy Data matching app context
  List<NotificationModel> notifications = [
    NotificationModel(
      id: '1',
      title: "Booking Confirmed!",
      body:
          "Your stay at Room 12 Kings Hotel for 7th May has been confirmed successfully.",
      timeAgo: "2m ago",
      type: NotificationType.booking,
      isRead: false,
    ),
    NotificationModel(
      id: '2',
      title: "Savings Deposit Successful",
      body:
          "You have successfully deposited ₦40,000.00 into your savings account.",
      timeAgo: "1h ago",
      type: NotificationType.payment,
      isRead: false,
    ),
    NotificationModel(
      id: '3',
      title: "Security Alert",
      body: "A new device logged into your account from Lagos. Was this you?",
      timeAgo: "Yesterday",
      type: NotificationType.security,
      isRead: true,
    ),
    NotificationModel(
      id: '4',
      title: "New Features Available",
      body: "Check out the new investment plans now available on the platform.",
      timeAgo: "2 days ago",
      type: NotificationType.info,
      isRead: true,
    ),
    NotificationModel(
      id: '5',
      title: "Booking Reminder",
      body: "Your check-in at Kings Hotel is tomorrow at 2:00 PM.",
      timeAgo: "2 days ago",
      type: NotificationType.booking,
      isRead: true,
    ),
  ];

  void _markAllAsRead() {
    setState(() {
      for (var note in notifications) {
        note.isRead = true;
      }
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("All marked as read")));
  }

  void _handleNotificationTap(int index) {
    setState(() {
      // Mark specific item as read on tap
      notifications[index].isRead = true;
    });
    // Navigate to relevant screen based on type...
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgWhite,
      appBar: AppBar(
        backgroundColor: kBgWhite,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kPrimaryBlack),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "Notifications",
          style: TextStyle(color: kPrimaryBlack, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          if (notifications.any((n) => !n.isRead))
            TextButton(
              onPressed: _markAllAsRead,
              child: const Text(
                "Mark all read",
                style: TextStyle(
                  color: kYellowColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      body: notifications.isEmpty
          ? const _EmptyNotificationState()
          : ListView.separated(
              itemCount: notifications.length,
              separatorBuilder: (context, index) => Divider(
                color: kBorderGrey.withValues(alpha: 0.5),
                height: 1,
                indent: 80, // Offset divider to align with text content
              ),
              itemBuilder: (context, index) {
                return _NotificationTile(
                  notification: notifications[index],
                  onTap: () => _handleNotificationTap(index),
                );
              },
            ),
    );
  }
}

// ==========================================
// --- Helper Widgets ---
// ==========================================

class _NotificationTile extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;

  const _NotificationTile({required this.notification, required this.onTap});

  // Helper to get colors and icons based on type
  Map<String, dynamic> _getTypeDetails(NotificationType type) {
    switch (type) {
      case NotificationType.booking:
        return {'color': kAccentBlue, 'icon': Icons.hotel_rounded};
      case NotificationType.payment:
        return {
          'color': kAccentGreen,
          'icon': Icons.account_balance_wallet_rounded,
        };
      case NotificationType.security:
        return {'color': kAccentRed, 'icon': Icons.shield_rounded};
      case NotificationType.info:
        return {'color': kSecondaryGrey, 'icon': Icons.info_outline_rounded};
    }
  }

  @override
  Widget build(BuildContext context) {
    final typeDetails = _getTypeDetails(notification.type);
    final Color typeColor = typeDetails['color'];
    final IconData typeIcon = typeDetails['icon'];

    // Subtle background change if unread, though modern UI often keeps it white
    // and uses font weight/dots instead. Sticking to white for cleanest look.
    final bgColor = kBgWhite;

    return InkWell(
      onTap: onTap,
      child: Container(
        color: bgColor,
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Icon Indicator
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: typeColor.withValues(
                  alpha: 0.1,
                ), // Light pastel background
                shape: BoxShape.circle,
              ),
              child: Icon(typeIcon, color: typeColor, size: 24),
            ),
            const SizedBox(width: 16),

            // 2. Text Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Title
                      Expanded(
                        child: Text(
                          notification.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            color: kPrimaryBlack,
                            // Bolder title if unread
                            fontWeight: notification.isRead
                                ? FontWeight.w500
                                : FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Timestamp
                      Text(
                        notification.timeAgo,
                        style: const TextStyle(
                          fontSize: 12,
                          color: kSecondaryGrey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  // Body
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification.body,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            color: notification.isRead
                                ? kSecondaryGrey
                                : kPrimaryBlack.withValues(alpha: 0.8),
                            height: 1.4,
                          ),
                        ),
                      ),
                      // Unread Indicator Dot placed to the right of body
                      if (!notification.isRead)
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: kYellowColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyNotificationState extends StatelessWidget {
  const _EmptyNotificationState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: kLightGreyBg,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_none_rounded,
              size: 60,
              color: kSecondaryGrey,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "No Notifications Yet",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: kPrimaryBlack,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "We will let you know when important\nthings happen.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: kSecondaryGrey),
          ),
        ],
      ),
    );
  }
}
