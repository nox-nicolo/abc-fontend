
import 'package:africa_beuty/feature/booking/view/pages/customer_booking.dart';
import 'package:africa_beuty/feature/booking/view/pages/salon_booking.dart';
import 'package:flutter/material.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final bool _isCustomer = false;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isCustomer ? 

        const CustomerBookingPage()
      
      : 
      
        const SalonBookingPage()

      ,
    );
  }
}