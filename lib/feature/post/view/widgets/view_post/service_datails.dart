
/* ---------------------------------------------------
   SERVICE DETAILS
--------------------------------------------------- */

import 'package:flutter/material.dart';

class LuxuryServiceDetails extends StatelessWidget {
  final String serviceName;
  final String? price;
  final String? duration;
  final List<String>? benefits;
  final List<String>? products;

  const LuxuryServiceDetails({
    super.key,
    required this.serviceName,
    this.price,
    this.duration,
    this.benefits,
    this.products,
  });

  bool get _hasBenefits => benefits != null && benefits!.isNotEmpty;
  bool get _hasProducts => products != null && products!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: LinearGradient(
            colors: [
              scheme.surfaceContainerLowest,
              scheme.surfaceContainerHigh.withOpacity(0.9),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: scheme.primary.withOpacity(0.12),
              blurRadius: 30,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// SERVICE TITLE
              Text(
                serviceName,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.4,
                ),
              ),

              const SizedBox(height: 14),

              /// PRICE & TIME (Soft Pills)
              if (price != null || duration != null)
                Wrap(
                  spacing: 10,
                  runSpacing: 8,
                  children: [
                    if (price != null)
                      _SoftPill(
                        label: price!,
                        emphasis: true,
                      ),
                    if (duration != null)
                      _SoftPill(
                        label: duration!,
                      ),
                  ],
                ),

              if (_hasBenefits) const SizedBox(height: 22),

              /// BENEFITS – DESIRE-BASED
              if (_hasBenefits) ...[
                Text(
                  'Why women love this service',
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                ...benefits!.map(
                  (b) => _BenefitLine(text: b),
                ),
              ],

              if (_hasProducts) const SizedBox(height: 22),

              /// PRODUCTS – LUXURY WHISPER
              if (_hasProducts) ...[
                Text(
                  'Premium products used',
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: products!
                      .map((p) => _ProductTag(label: p))
                      .toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/* ---------------------------------------------------
   COMPONENTS
--------------------------------------------------- */

class _SoftPill extends StatelessWidget {
  final String label;
  final bool emphasis;

  const _SoftPill({
    required this.label,
    this.emphasis = false,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: emphasis
            ? scheme.primary.withOpacity(0.15)
            : scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: emphasis
                  ? scheme.primary
                  : scheme.onSurfaceVariant,
            ),
      ),
    );
  }
}

class _BenefitLine extends StatelessWidget {
  final String text;

  const _BenefitLine({required this.text});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            height: 6,
            width: 6,
            decoration: BoxDecoration(
              color: scheme.primary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    height: 1.4,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductTag extends StatelessWidget {
  final String label;

  const _ProductTag({required this.label});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: scheme.primary.withOpacity(0.4),
        ),
        color: scheme.surfaceContainerLowest,
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
