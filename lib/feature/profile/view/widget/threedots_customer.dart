import 'package:africa_beuty/feature/profile/view/page/following_page.dart';
import 'package:africa_beuty/feature/booking/view/pages/customer_booking.dart';
import 'package:africa_beuty/feature/saved/view/page/saved_page.dart';
import 'package:flutter/material.dart';
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
      padding: EdgeInsets.all(16),
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
          const SizedBox(height: 10),
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
            title: Text('Appointments'),
          ),
          const SizedBox(height: 10),
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
            title: Text('Saved'),
          ),
          ListTile(
            leading: Icon(
              FontAwesome.share_nodes_solid,
              color: theme.colorScheme.secondary,
            ),
            title: Text('Share Profile'),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
