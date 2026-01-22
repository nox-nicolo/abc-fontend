import 'package:africa_beuty/feature/welcome/view/widget/aim.dart';
import 'package:africa_beuty/feature/welcome/view/widget/show.dart';
import 'package:africa_beuty/feature/welcome/view/widget/solve.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final _controller = PageController();
  bool isLastPage = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. PAGE VIEW (The Background Images)
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                isLastPage = (index == 2); // Set true if on the 3rd page
              });
            },
            children: const [
              ScreenPageOne(),
              ScreenPageTwo(),
              ScreenPageThree(),
            ],
          ),

          // 2. SKIP BUTTON (Top Right)
          Positioned(
            top: 50,
            right: 20,
            child: (isLastPage == false) ? TextButton(
              onPressed: () async {
                  // If they skip, they are also no longer a first-time user
                  final box = await Hive.openBox('settings');
                  await box.put('isFirstTime', false);
                  
                  _controller.jumpToPage(2);
                },
              child: const Text(
                'Skip',
                style: TextStyle(
                  color: Colors.pink,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ) :
            const SizedBox.shrink(),
          ),

          // 3. BOTTOM UI (Indicator + Next Button)
          Positioned(
            bottom: 60,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // SMOOTH PAGE INDICATOR
                SmoothPageIndicator(
                  controller: _controller,
                  count: 3,
                  effect: const ExpandingDotsEffect(
                    dotHeight: 8,
                    dotWidth: 8,
                    expansionFactor: 4,
                    spacing: 8,
                    dotColor: Colors.purple,
                    activeDotColor: Colors.pink,
                  ),
                ),

                // NEXT / GET STARTED BUTTON
                ElevatedButton(
                  onPressed: () async { // 1. Added async here
                    if (isLastPage) {
                      // 2. SAVE to Hive that user has seen onboarding
                      final box = await Hive.openBox('settings');
                      await box.put('isFirstTime', false);

                      // 3. Navigate to the next screen
                      if (context.mounted) {
                        Navigator.pushReplacementNamed(context, '/select_account');
                      }
                    } else {
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                  ),
                  child: Text(
                    isLastPage ? 'Get Started' : 'Next',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}