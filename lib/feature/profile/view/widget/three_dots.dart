import 'package:africa_beuty/feature/profile/view/widget/threedots_customer.dart';
import 'package:africa_beuty/feature/profile/view/widget/threedots_salon.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class ThreeDotsOptions extends StatefulWidget {
  const ThreeDotsOptions(
    {
      super.key, 
      required this.isCustomer, 
    }
  );

  final bool isCustomer;

  @override
  State<ThreeDotsOptions> createState() => _ThreeDotsOptionsState();
}

class _ThreeDotsOptionsState extends State<ThreeDotsOptions> {
  late bool _isCustomer;

  @override 
  void initState() {
    super.initState();

    _isCustomer = widget.isCustomer;
  }

  // implementation of three dots function
  void _threeDotsModal() {
    showModalBottomSheet(
      useSafeArea: true,
      showDragHandle: true,
      isScrollControlled: true,
      context: context, 
      builder: (context) {
        return const ThreedotsSalon();
      }
    );
  }

  void _customerThreeDotsModal() {
    showModalBottomSheet(
      useSafeArea: true,
      showDragHandle: true,
      isScrollControlled: true,
      context: context, 
      builder: (context) {
        return const ThreedotsCustomer();
      }
    );
  }
  

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        _isCustomer ? _customerThreeDotsModal() :_threeDotsModal();
      },
      icon: Icon(
        Bootstrap.three_dots_vertical, 
        size: 16,
        color: Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }
}