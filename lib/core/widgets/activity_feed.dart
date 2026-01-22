import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class ActivityFeed extends StatefulWidget {
  const ActivityFeed({super.key});

  @override
  State<ActivityFeed> createState() => _ActivityFeedState();
}

class _ActivityFeedState extends State<ActivityFeed> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 12, 
        foregroundImage: AssetImage('assets/images/dp.jpg'),
      ),
      title: Text(
        'what happening to the account, what happening to the account, what happening to the account what happening to the account, what happening to the account', 
        style: Theme.of(context).textTheme.titleSmall,
      ),
      trailing: Icon(
        Bootstrap.heart_fill, 
        size: 16,
        color: Colors.red.shade500,
      ),
    );
  }
}