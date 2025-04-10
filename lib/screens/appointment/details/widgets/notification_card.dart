import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../models/notification_data.dart';
import 'common_card.dart';
import 'icon_box.dart';

class NotificationCard extends StatelessWidget {
  final NotificationData notificationData;

  const NotificationCard({super.key, required this.notificationData});

  @override
  Widget build(BuildContext context) {
    return CommonCard(
      title: 'Notifica',
      icon: LucideIcons.bell,
      content: Row(
        children: [
          IconBox(icon: LucideIcons.bellRing),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              notificationData.getNotificationText(),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
