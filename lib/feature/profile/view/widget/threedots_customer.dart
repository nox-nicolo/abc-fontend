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
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Text(
              'Menu', 
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ), 
          const SizedBox(height: 16,),
          ListTile(
            leading: Icon(FontAwesome.face_smile_beam_solid, color: Colors.orange.shade400,),
            title: Text('Following'),
          ),
          const SizedBox(height: 10,), 
          ListTile(
            leading: Icon(FontAwesome.calendar_check_solid, color: Colors.orange.shade400,),
            title: Text('Appointments'),
          ),
          const SizedBox(height: 10,), 
          ListTile(
            leading: Icon(Bootstrap.bookmark_fill, color: Colors.orange.shade400,),
            title: Text('Saved'),
          ),
          ListTile(
            leading: Icon(FontAwesome.share_nodes_solid, color: Colors.orange.shade400,),
            title: Text('Share Profile'),
          ),
          const SizedBox(height: 10,), 
        ],
      ),
    );
  }
}