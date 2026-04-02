import 'package:africa_beuty/feature/profile/view/widget/three_dots/service/salon_service.dart';
import 'package:africa_beuty/feature/profile/view/widget/three_dots/stylist/stylist_management.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class ThreedotsSalon extends StatefulWidget {
  const ThreedotsSalon({super.key});

  @override
  State<ThreedotsSalon> createState() => _ThreedotsSalonState();
}

class _ThreedotsSalonState extends State<ThreedotsSalon> {
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            onTap: () {
              // Navigate to the stylist management page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SalonStylistsPage()),
              );
            },
            leading: Icon(Icons.face_2_rounded, color: theme.colorScheme.secondary),
            title: Text('Stylists Management'),
            subtitle: Text('Add, Edit, Delete'),
          ),
          const SizedBox(height: 10,), 
          ListTile(
            onTap: () {
              // Navigate to the service management page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SelectServicePage()),
              );
            },
            leading: Icon(Icons.edit, color: theme.colorScheme.secondary),
            title: Text('Service Management'),
            subtitle: Text('Create service, custom service'),
          ),
          ListTile(
            leading: Icon(Icons.sell_rounded, color: theme.colorScheme.secondary),
            title: Text('Marketing & Promotion'),
            subtitle: Text('Create promotion, Setting loyalt programs'),
          ),
          const SizedBox(height: 10,), 
          ListTile(
            leading: Icon(Icons.calendar_today_rounded, color: theme.colorScheme.secondary),
            title: Text('Appointment Management'),
            subtitle: Text('Schedule appointment'),
          ),
          ListTile(
            leading: Icon(Icons.monetization_on, color: theme.colorScheme.secondary),
            title: Text('Payments'),
            subtitle: Text('Make payment, Programa'),
          ),
          const SizedBox(height: 10,), 
          ListTile(
            leading: Icon(Icons.analytics_outlined, color: theme.colorScheme.secondary),
            title: Text('Report & Analytics'),
            subtitle: Text('Summary, Trends'),
          ),
          ListTile(
            leading: Icon(Icons.mediation, color: theme.colorScheme.secondary),
            title: Text('Social & Availability'),
            subtitle: Text('Sync Social Account, Set Working time'),
          ),
          const SizedBox(height: 10,), 
          ListTile(
            leading: Icon(Icons.bookmark_border, color: theme.colorScheme.secondary),
            title: Text('Saved'),
          ),
        ],
      ),
    );
  }
}