import 'package:africa_beuty/feature/profile/view/widget/customer_profile.dart';
import 'package:africa_beuty/feature/profile/view/widget/salon_profile.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final bool _isCustomer = false;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isCustomer ? 

        const CustomerProfileSliverWidget()
      
      : 
      
        const SalonProfileSliverWidget()

      ,
    );
  }
}