import 'package:africa_beuty/feature/profile/model/profile_insights.dart';
import 'package:africa_beuty/feature/profile/repositories/profile_insights.dart';
import 'package:flutter/material.dart';

class ProfileInsightsCard extends StatefulWidget {
  const ProfileInsightsCard({super.key, required this.role});

  final String role;

  @override
  State<ProfileInsightsCard> createState() => _ProfileInsightsCardState();
}

class _ProfileInsightsCardState extends State<ProfileInsightsCard> {
  late Future<ProfileInsightsModel?> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<ProfileInsightsModel?> _load() async {
    final result = await ProfileInsightsRepository().getInsights();
    return result.match((_) => null, (insights) => insights);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ProfileInsightsModel?>(
      future: _future,
      builder: (context, snapshot) {
        final insights = snapshot.data;
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(height: 112);
        }
        if (insights == null) return const SizedBox.shrink();

        final role = widget.role.trim().toLowerCase();
        if (role == 'customer' || role == 'user') {
          final customer = insights.customer;
          if (customer == null) return const SizedBox.shrink();
          return _CustomerInsightsSurface(insights: customer);
        }

        final salon = insights.salon;
        if (salon == null) return const SizedBox.shrink();
        return _SalonInsightsSurface(insights: salon);
      },
    );
  }
}

class _CustomerInsightsSurface extends StatelessWidget {
  const _CustomerInsightsSurface({required this.insights});

  final CustomerInsightsModel insights;

  @override
  Widget build(BuildContext context) {
    final recent = insights.recentBookingCategories.isEmpty
        ? 'No bookings yet'
        : insights.recentBookingCategories
              .take(2)
              .map((item) => item.name)
              .where((name) => name.isNotEmpty)
              .join(', ');

    return _InsightsSurface(
      title: 'Profile Insights',
      children: [
        _InsightMetric(
          icon: Icons.bookmark_rounded,
          value: '${insights.savedStylesCount}',
          label: 'Saved styles',
        ),
        _InsightMetric(
          icon: Icons.favorite_rounded,
          value: '${insights.followedSalonsCount}',
          label: 'Followed salons',
        ),
        _InsightMetric(
          icon: Icons.history_rounded,
          value: recent.isEmpty ? 'None' : recent,
          label: 'Recent bookings',
        ),
      ],
    );
  }
}

class _SalonInsightsSurface extends StatelessWidget {
  const _SalonInsightsSurface({required this.insights});

  final SalonInsightsModel insights;

  @override
  Widget build(BuildContext context) {
    return _InsightsSurface(
      title: 'Profile Insights',
      children: [
        _InsightMetric(
          icon: Icons.visibility_rounded,
          value: '${insights.profileViews}',
          label: 'Profile views',
        ),
        _InsightMetric(
          icon: Icons.touch_app_rounded,
          value: '${insights.serviceTaps}',
          label: 'Service taps',
        ),
        _InsightMetric(
          icon: Icons.percent_rounded,
          value: '${insights.bookingConversionRate.toStringAsFixed(1)}%',
          label: 'Conversion',
        ),
        _InsightMetric(
          icon: Icons.repeat_rounded,
          value: '${insights.returningCustomers}',
          label: 'Returning customers',
        ),
        _InsightMetric(
          icon: Icons.trending_up_rounded,
          value: insights.followerGrowth.delta >= 0
              ? '+${insights.followerGrowth.delta}'
              : '${insights.followerGrowth.delta}',
          label: 'Follower growth',
        ),
      ],
    );
  }
}

class _InsightsSurface extends StatelessWidget {
  const _InsightsSurface({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHighest.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: scheme.outlineVariant),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
              LayoutBuilder(
                builder: (context, constraints) {
                  final itemWidth = constraints.maxWidth > 520
                      ? (constraints.maxWidth - 16) / 3
                      : (constraints.maxWidth - 8) / 2;
                  return Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final child in children)
                        SizedBox(width: itemWidth, child: child),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InsightMetric extends StatelessWidget {
  const _InsightMetric({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      height: 82,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: scheme.primary),
          const Spacer(),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelSmall?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
