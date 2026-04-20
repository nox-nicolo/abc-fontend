import 'package:flutter/material.dart';

class SelectAccount extends StatelessWidget {
  const SelectAccount({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),

              // ── Header ──────────────────────────────────────
              Text(
                'How will you\nuse Africa Beauty?',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      height: 1.2,
                    ),
              ),
              const SizedBox(height: 10),
              Text(
                'Choose your account type to get started.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
              ),

              const SizedBox(height: 40),

              // ── Customer card ────────────────────────────────
              _AccountCard(
                icon: Icons.person_outline_rounded,
                title: 'Customer',
                subtitle:
                    'Discover salons, book services\nand track your appointments.',
                onTap: () => Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/signup',
                  (route) => false,
                  arguments: {'isCustomer': true},
                ),
              ),

              const SizedBox(height: 16),

              // ── Salon owner card ─────────────────────────────
              _AccountCard(
                icon: Icons.storefront_outlined,
                title: 'Salon Owner',
                subtitle:
                    'Manage your salon, set services\nand receive bookings.',
                onTap: () => Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/signup',
                  (route) => false,
                  arguments: {'isCustomer': false},
                ),
                highlighted: true,
              ),

              const Spacer(),

              // ── Sign in link ─────────────────────────────────
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/signin'),
                  child: RichText(
                    text: TextSpan(
                      text: 'Already have an account?  ',
                      style: Theme.of(context).textTheme.bodyMedium,
                      children: [
                        TextSpan(
                          text: 'Sign in',
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: scheme.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _AccountCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool highlighted;

  const _AccountCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final bg = highlighted ? scheme.primaryContainer : scheme.surfaceContainerHighest;
    final fg = highlighted ? scheme.onPrimaryContainer : scheme.onSurface;
    final iconBg = highlighted ? scheme.primary : scheme.surfaceContainerLow;
    final iconFg = highlighted ? scheme.onPrimary : scheme.onSurfaceVariant;

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: iconFg, size: 26),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: fg,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: fg.withValues(alpha: 0.7),
                            height: 1.4,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.arrow_forward_ios_rounded,
                  size: 16, color: fg.withValues(alpha: 0.5)),
            ],
          ),
        ),
      ),
    );
  }
}
