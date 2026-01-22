import 'package:flutter/material.dart';

class ScreenPageThree extends StatelessWidget {
  const ScreenPageThree({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 1. The "Success" Image
        // Tip: Use a bright, happy image of a girl with a stunning hairstyle
        Positioned.fill(
          child: Image.asset(
            'assets/images/onboarding/pro_stylist.jpg', 
            fit: BoxFit.cover,
          ),
        ),

        // 2. The Solution Gradient
        // We can use a touch of your brand color (Pink/Purple) in the gradient here
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.pink.withOpacity(0.2), // Subtle brand tint
                  Colors.black.withOpacity(0.9),
                ],
                stops: const [0.5, 0.8, 1.0],
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
              crossAxisAlignment: CrossAxisAlignment.center, // Back to Center for the final impact
              children: [
                // Solution Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.white30),
                  ),
                  child: const Text(
                    'THE SOLUTION',
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
                const SizedBox(height: 24),
                const Text(
                  'Your Personal Beauty Assistant.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
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
                const SizedBox(height: 16),
                Text(
                  'Instant booking, verified reviews, and top-tier stylists right at your fingertips. Welcome to a stress-free glow up.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 120), // Extra space for the "Get Started" button
              ],
            ),
          ),
        ),
      ],
    );
  }
}