
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class BookingNowGlowButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final double height;

  const BookingNowGlowButton({
    super.key,
    required this.onPressed,
    this.text = 'Booking Now',
    this.height = 54,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          // This creates the "Border" look without filling the inside
          border: Border.all(
            color: scheme.primary.withOpacity(0.5),
            width: 2,
          ),
        ),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(999),
          child: Center(
            child: Text(
              text,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: scheme.onSurface,
                  ),
            ),
          ),
        ),
      )
      // 1. Add the Glow (Shadow)
      .animate(onPlay: (controller) => controller.repeat(reverse: true))
      .custom(
        duration: 1500.ms,
        builder: (context, value, child) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              boxShadow: [
                BoxShadow(
                  color: scheme.primary.withOpacity(value * 0.6), // Pulsing opacity
                  blurRadius: 15 * value, // Pulsing blur
                  spreadRadius: 1 * value,
                  blurStyle: BlurStyle.outer, // CRITICAL: This keeps the inside clean
                ),
              ],
            ),
            child: child,
          );
        },
      ),
    );
  }
}