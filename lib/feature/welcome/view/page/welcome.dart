import 'package:africa_beuty/feature/auth/repositories/local_storage_service.dart';
import 'package:africa_beuty/feature/welcome/view/widget/aim.dart';
import 'package:africa_beuty/feature/welcome/view/widget/show.dart';
import 'package:africa_beuty/feature/welcome/view/widget/solve.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final PageController _controller = PageController();
  bool isLastPage = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _finishWelcomeFlow() async {
    await LocalStorageService.setFirstTime(false);

    if (!mounted) return;

    Navigator.pushReplacementNamed(context, '/select_account');
  }

  Future<void> _skipToLastPage() async {
    await LocalStorageService.setFirstTime(false);

    if (!mounted) return;

    Navigator.pushReplacementNamed(context, '/select_account');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                isLastPage = index == 2;
              });
            },
            children: const [
              ScreenPageOne(),
              ScreenPageTwo(),
              ScreenPageThree(),
            ],
          ),

          Positioned(
            top: 50,
            right: 20,
            child: !isLastPage
                ? TextButton(
                    onPressed: _skipToLastPage,
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),

          Positioned(
            bottom: 60,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SmoothPageIndicator(
                  controller: _controller,
                  count: 3,
                  effect: ExpandingDotsEffect(
                    dotHeight: 8,
                    dotWidth: 8,
                    expansionFactor: 4,
                    spacing: 8,
                    dotColor: Theme.of(context).colorScheme.onSurfaceVariant,
                    activeDotColor: Theme.of(context).colorScheme.primary,
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (isLastPage) {
                      await _finishWelcomeFlow();
                    } else {
                      await _controller.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
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
          ),
        ],
      ),
    );
  }
}