import 'package:africa_beuty/core/network/network_status_controller.dart';
import 'package:flutter/material.dart';

class NetworkStatusBanner extends StatelessWidget {
  const NetworkStatusBanner({super.key, required this.child, this.controller});

  final Widget child;
  final NetworkStatusController? controller;

  @override
  Widget build(BuildContext context) {
    final statusController = controller ?? NetworkStatusController.instance;

    return AnimatedBuilder(
      animation: statusController,
      builder: (context, _) {
        final showBanner =
            statusController.isOffline ||
            statusController.isChecking ||
            statusController.isRecovered;

        return Stack(
          children: [
            child,
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                bottom: false,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: showBanner
                      ? _NetworkBannerContent(
                          key: ValueKey(statusController.state),
                          controller: statusController,
                        )
                      : const SizedBox.shrink(),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _NetworkBannerContent extends StatelessWidget {
  const _NetworkBannerContent({super.key, required this.controller});

  final NetworkStatusController controller;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isRecovered = controller.isRecovered;
    final isChecking = controller.isChecking;
    final backgroundColor = isRecovered
        ? const Color(0xFF2E7D32)
        : colorScheme.error;

    return Material(
      elevation: 6,
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Icon(
              isRecovered ? Icons.wifi : Icons.wifi_off,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                isRecovered
                    ? 'Back online'
                    : isChecking
                    ? 'Checking connection...'
                    : 'You are offline',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (!isRecovered)
              TextButton(
                onPressed: isChecking ? null : controller.retry,
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  disabledForegroundColor: Colors.white70,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  minimumSize: const Size(48, 36),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: isChecking
                    ? const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Retry'),
              ),
          ],
        ),
      ),
    );
  }
}
