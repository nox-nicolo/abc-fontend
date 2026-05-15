import 'package:africa_beuty/core/providers/user_provider.dart';
import 'package:africa_beuty/core/widgets/loader.dart';
import 'package:africa_beuty/feature/profile/view/widget/customer_profile.dart';
import 'package:africa_beuty/feature/profile/view/widget/salon_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final role = user?.role.trim().toLowerCase();

    if (role == null || role.isEmpty) {
      return const Scaffold(body: Loader());
    }

    final bool isCustomer = role == 'customer' || role == 'user';
    final bool isSalon =
        role == 'service' ||
        role == 'salon' ||
        role == 'salon_owner' ||
        role == 'owner';

    return Scaffold(
      body: isCustomer
          ? const CustomerProfileSliverWidget()
          : isSalon
          ? const SalonProfileSliverWidget()
          : Center(child: Text('Unsupported profile type: $role')),
    );
  }
}
