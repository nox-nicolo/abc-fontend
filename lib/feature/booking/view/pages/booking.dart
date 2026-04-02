
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
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    switch (_role) {
      case 'customer':
        return const CustomerBookingPage();

      case 'service':
        return const SalonBookingPage();

      default:
        return const Scaffold(
          body: Center(
            child: Text('Unknown user role'),
          ),
        );
    }
  }
}