import 'package:africa_beuty/feature/profile/view/page/following_page.dart';
import 'package:africa_beuty/feature/booking/view/pages/customer_booking.dart';
import 'package:africa_beuty/feature/chat/view/page/chats_page.dart';
import 'package:africa_beuty/feature/saved/view/page/saved_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:icons_plus/icons_plus.dart';

class ThreedotsCustomer extends StatefulWidget {
  const ThreedotsCustomer({super.key});

  @override
  State<ThreedotsCustomer> createState() => _ThreedotsCustomerState();
}

class _ThreedotsCustomerState extends State<ThreedotsCustomer> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Text('Menu', style: Theme.of(context).textTheme.titleLarge),
          ),
          const SizedBox(height: 16),
          ListTile(
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FollowingPage()),
              );
            },
            leading: Icon(
              FontAwesome.face_smile_beam_solid,
              color: theme.colorScheme.secondary,
            ),
            title: const Text('Following'),
            subtitle: const Text('Salons you follow'),
          ),
          const Divider(height: 1),
          ListTile(
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CustomerBookingPage()),
              );
            },
            leading: Icon(
              FontAwesome.calendar_check_solid,
              color: theme.colorScheme.secondary,
            ),
            title: const Text('Bookings'),
            subtitle: const Text('Upcoming, requested, and completed visits'),
          ),
          const Divider(height: 1),
          ListTile(
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SavedPage()),
              );
            },
            leading: Icon(
              Bootstrap.bookmark_fill,
              color: theme.colorScheme.secondary,
            ),
            title: const Text('Saved'),
            subtitle: const Text('Saved salons, services, and styles'),
          ),
          const Divider(height: 1),
          ListTile(
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ChatsPage()),
              );
            },
            leading: Icon(
              FontAwesome.comment_dots_solid,
              color: theme.colorScheme.secondary,
            ),
            title: const Text('Chats'),
            subtitle: const Text('Messages with salons'),
          ),
          const Divider(height: 1),
          ListTile(
            onTap: () async {
              await Clipboard.setData(
                const ClipboardData(text: 'African Beauty profile'),
              );
              if (!context.mounted) return;
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile link copied')),
              );
            },
            leading: Icon(
              FontAwesome.share_nodes_solid,
              color: theme.colorScheme.secondary,
            ),
            title: const Text('Share profile'),
            subtitle: const Text('Copy your profile link'),
          ),
        ],
      ),
    );
  }
}
