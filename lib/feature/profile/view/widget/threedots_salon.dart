import 'package:flutter/material.dart';

class ThreedotsSalon extends StatefulWidget {
  const ThreedotsSalon({super.key});

  @override
  State<ThreedotsSalon> createState() => _ThreedotsSalonState();
}

class _ThreedotsSalonState extends State<ThreedotsSalon> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.post_add_rounded, color: Colors.blue.shade400,),
            title: Text('Content Management'),
            subtitle: Text('Add, Edit, Delete'),
          ),
          const SizedBox(height: 10,), 
          ListTile(
            leading: Icon(Icons.edit, color: Colors.blue.shade400,),
            title: Text('Service Management'),
            subtitle: Text('Create service, custom service'),
          ),
          ListTile(
            leading: Icon(Icons.sell_rounded, color: Colors.blue.shade400,),
            title: Text('Marketing & Promotion'),
            subtitle: Text('Create promotion, Setting loyalt programs'),
          ),
          const SizedBox(height: 10,), 
          ListTile(
            leading: Icon(Icons.calendar_today_rounded, color: Colors.blue.shade400,),
            title: Text('Appointment Management'),
            subtitle: Text('Schedule appointment'),
          ),
          ListTile(
            leading: Icon(Icons.monetization_on, color: Colors.blue.shade400,),
            title: Text('Payments'),
            subtitle: Text('Make payment, Programa'),
          ),
          const SizedBox(height: 10,), 
          ListTile(
            leading: Icon(Icons.analytics_outlined, color: Colors.blue.shade400,),
            title: Text('Report & Analytics'),
            subtitle: Text('Summary, Trends'),
          ),
          ListTile(
            leading: Icon(Icons.mediation, color: Colors.blue.shade400,),
            title: Text('Social & Availability'),
            subtitle: Text('Sync Social Account, Set Working time'),
          ),
          const SizedBox(height: 10,), 
          ListTile(
            leading: Icon(Icons.bookmark_border, color: Colors.blue.shade400,),
            title: Text('Saved'),
          ),
        ],
      ),
    );
  }
}