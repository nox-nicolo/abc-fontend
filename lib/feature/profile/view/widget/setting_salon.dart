import 'package:africa_beuty/feature/profile/view/widget/settings/edit_salon_profile.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class SalonSetting extends StatefulWidget {
  const SalonSetting({super.key});

  @override
  State<SalonSetting> createState() => _SalonSettingState();
}

class _SalonSettingState extends State<SalonSetting> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(bottom: 16),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16,),
              Center(
                child: Text(
                  'Settings', 
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ), 
              const SizedBox(height: 16,), 
              ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SalonProfileInformationPage()));
                },
                leading: Icon(Icons.edit, color: theme.colorScheme.secondary,),
                title: Text('Edit'),
                subtitle: Text('username, phone number ...'),
              ),
              const SizedBox(height: 10,), 
              ListTile(
                leading: Icon(FontAwesome.lock_solid, color: theme.colorScheme.secondary,),
                title: Text('Privacy'),
                subtitle: Text('user data'),
              ),
              const SizedBox(height: 10,), 
              ListTile(
                leading: Icon(FontAwesome.person_falling_solid, color: theme.colorScheme.secondary,),
                title: Text('Appointment'),
                subtitle: Text('Remeinder, Communication'),
              ), 
              const SizedBox(height: 10,), 
              ListTile(
                leading: Icon(FontAwesome.shield_solid, color: theme.colorScheme.secondary,),
                title: Text('Security'),
                subtitle: Text('Two-factor authentication, Change password'),
              ), 
              ListTile(
                leading: Icon(FontAwesome.money_bill_solid, color: theme.colorScheme.secondary,),
                title: Text('Payments'),
                subtitle: Text('default payment, Add/manage payments'),
              ), 
              const SizedBox(height: 10,), 
              ListTile(
                leading: Icon(FontAwesome.circle_check_solid, color: theme.colorScheme.secondary,),
                title: Text('Storage and Data'),
                subtitle: Text('Network usage, Storage'),
              ), 
              const SizedBox(height: 10,), 
              ListTile(
                leading: Icon(FontAwesome.bell_solid, color: theme.colorScheme.secondary,),
                title: Text('Notification'),
                subtitle: Text('Notification preferences'),
              ), 
              const SizedBox(height: 10,), 
              ListTile(
                leading: Icon(FontAwesome.key_solid, color: theme.colorScheme.secondary,),
                title: Text('Account'),
                subtitle: Text('Delete, Manage contents'),
              ), 
              const SizedBox(height: 10,), 
              ListTile(
                leading: Icon(FontAwesome.earth_africa_solid, color: theme.colorScheme.secondary,),
                title: Text('Language'),
                subtitle: Text('English, Device language'),
              )
            ],
          ),
      ),
    );
  }
}