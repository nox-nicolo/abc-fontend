import 'package:africa_beuty/core/widgets/app_state.dart';
import 'package:africa_beuty/feature/auth/repositories/local_storage_service.dart';
import 'package:africa_beuty/feature/booking/view/pages/customer_booking.dart';
import 'package:africa_beuty/feature/booking/view/pages/salon_booking.dart';
import 'package:flutter/material.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  String? _role;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadUserRole();
  }

  Future<void> _loadUserRole() async {
    final user = await LocalStorageService.getuserData();

    setState(() {
      _role = user?.role; // depends on your MeModel
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: AppLoadingState());
    }

    switch (_role) {
      case 'customer':
        return const CustomerBookingPage();

      case 'service':
        return const SalonBookingPage();

      default:
        return const Scaffold(
          body: AppEmptyState(
            icon: Icons.account_circle_outlined,
            title: 'Account type unavailable',
            message: 'Please sign in again to continue.',
          ),
        );
    }
  }
}
