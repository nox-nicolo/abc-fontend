import 'package:africa_beuty/feature/profile/view/widget/setting_customer.dart';
import 'package:africa_beuty/feature/profile/view/widget/setting_salon.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class SettingAccount extends StatefulWidget {
  const SettingAccount(
    {
      super.key, 
      required this.isCustomer,
      }
    );

  final bool isCustomer;

  @override
  State<SettingAccount> createState() => _SettingAccountState();
}

class _SettingAccountState extends State<SettingAccount> {
  late bool _isCustomer;

  @override 
  void initState() {
    super.initState();

    _isCustomer = widget.isCustomer;
  }

  // show modal for setting account
  void _settingModal() {
    showModalBottomSheet(
      useSafeArea: true,
      showDragHandle: true,
      isScrollControlled: true,
      context: context, 
      builder: (context) {
        return const SalonSetting();
      }
    );
  }

    // customer show modal for setting account
    void _customerSettingModal() {
    showModalBottomSheet(
      useSafeArea: true,
      showDragHandle: true,
      isScrollControlled: true,
      context: context, 
      builder: (context) {
        return const CustomerSettings();
      }
    );
  }
  

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        _isCustomer ? _customerSettingModal() : _settingModal();
      },
      icon: Icon(
        Bootstrap.gear_fill, 
        size: 16,
        color: Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }
}
