import 'package:africa_beuty/core/providers/user_provider.dart';
import 'package:africa_beuty/feature/profile/view/widget/customer_profile.dart';
import 'package:africa_beuty/feature/profile/view/widget/salon_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final bool isCustomer = user?.role == 'customer';
    return Scaffold(
      body: isCustomer
          ? const CustomerProfileSliverWidget()
          : const SalonProfileSliverWidget(),
    );
  }
}