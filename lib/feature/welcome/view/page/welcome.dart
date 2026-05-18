import 'package:africa_beuty/feature/auth/repositories/local_storage_service.dart';
import 'package:africa_beuty/feature/welcome/view/widget/aim.dart';
import 'package:africa_beuty/feature/welcome/view/widget/permissions.dart';
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
  static const _pageCount = 4;
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
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                isLastPage = index == _pageCount - 1;
              });
            },
            children: const [
              ScreenPageOne(),
              ScreenPageTwo(),
              ScreenPageThree(),
              WelcomePermissionsPage(),
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
            bottom: 34,
            left: 16,
            right: 16,
            child: SafeArea(
              top: false,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: scheme.surface.withValues(alpha: 0.92),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: scheme.outlineVariant),
                ),
                child: Row(
                  children: [
                    SmoothPageIndicator(
                      controller: _controller,
                      count: _pageCount,
                      effect: ExpandingDotsEffect(
                        dotHeight: 8,
                        dotWidth: 8,
                        expansionFactor: 4,
                        spacing: 8,
                        dotColor: scheme.outlineVariant,
                        activeDotColor: scheme.primary,
                      ),
                    ),
                    const Spacer(),
                    FilledButton.icon(
                      onPressed: () async {
                        if (isLastPage) {
                          await _finishWelcomeFlow();
                        } else {
                          await _controller.nextPage(
                            duration: const Duration(milliseconds: 420),
                            curve: Curves.easeOutCubic,
                          );
                        }
                      },
                      icon: Icon(
                        isLastPage
                            ? Icons.check_rounded
                            : Icons.arrow_forward_rounded,
                      ),
                      label: Text(isLastPage ? 'Continue' : 'Next'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
