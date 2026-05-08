import 'package:flutter/material.dart';

class ScreenPageOne extends StatelessWidget {
  const ScreenPageOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 1. The Full-Screen Background Image
        Positioned.fill(
          child: Image.asset(
            'assets/images/onboarding/style_discovery.jpg', // Replace with your image path
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),

        // 2. The Elegant Gradient Overlay
        // This adds a "shadow" at the bottom so the white text is easy to read
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.6, 1.0], // Starts the darkening at 60% of the screen
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.8),
                ],
              ),
            ),
          ),
        ),

        // 3. The Introducing Text
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 60),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'AFRICA BEAUTY',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    letterSpacing: 4,
                    fontWeight: FontWeight.w300,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black87,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Your Beauty, Our Priority.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
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
                const SizedBox(height: 20),
                Text(
                  'Discover top-rated stylists and book your next transformation in seconds.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 100), // Space for the dots and button
              ],
            ),
          ),
        ),
      ],
    );
  }
}