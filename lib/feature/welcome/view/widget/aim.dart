import 'package:flutter/material.dart';

class ScreenPageTwo extends StatelessWidget {
  const ScreenPageTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 1. The Background Image 
        // Tip: Use an image of a girl looking at her hair in a mirror or checking her phone
        Positioned.fill(
          child: Image.asset(
            'assets/images/onboarding/booking_now.jpg', 
            fit: BoxFit.cover,
          ),
        ),

        // 2. Darker Gradient Overlay
        // We use a slightly stronger overlay here to keep the focus on the problem/solution text
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.5, 1.0],
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.9),
                ],
              ),
            ),
          ),
        ),

        // 3. The Content
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 60),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start, // Align left for a change in rhythm
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.pink.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'THE CHALLENGE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.black87,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Tired of Long Queues & Ghost Stylists?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black87,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  'Finding a reliable stylist shouldn’t be a full-time job. We eliminate the wait and the uncertainty of walk-ins.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 110), // Space for indicator
              ],
            ),
          ),
        ),
      ],
    );
  }
}