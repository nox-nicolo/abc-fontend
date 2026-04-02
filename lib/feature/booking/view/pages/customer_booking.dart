// import 'package:flutter/material.dart';

// class CustomerBookingPage extends StatefulWidget {
//   const CustomerBookingPage({super.key});

//   @override
//   State<CustomerBookingPage> createState() => _CustomerBookingPageState();
// }

// class   _CustomerBookingPageState extends State<CustomerBookingPage> {
  
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('My Bookings'),
//       ),
//       body: const Center(
//         child: Text('Customer Booking Page'),
//       ),
//     );
//   }
// } 

import 'package:flutter/material.dart';

class CustomerBookingPage extends StatelessWidget {
  const CustomerBookingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
      ),
      body: const Center(
        child: Text('Customer Booking Page'),
      ),
    );
  }
}