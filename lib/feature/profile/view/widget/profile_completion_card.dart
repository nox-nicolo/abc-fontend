import 'package:africa_beuty/feature/profile/model/profile_completion.dart';
import 'package:africa_beuty/feature/profile/repositories/profile_completion.dart';
import 'package:flutter/material.dart';

class ProfileCompletionCard extends StatefulWidget {
  const ProfileCompletionCard({super.key});

  @override
  State<ProfileCompletionCard> createState() => _ProfileCompletionCardState();
}

class _ProfileCompletionCardState extends State<ProfileCompletionCard> {
  final _repo = ProfileCompletionRepository();
  late Future<ProfileCompletionModel?> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<ProfileCompletionModel?> _load() async {
    final result = await _repo.getCompletion();
    return result.match((_) => null, (completion) => completion);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ProfileCompletionModel?>(
      future: _future,
      builder: (context, snapshot) {
        final completion = snapshot.data;
        if (snapshot.connectionState != ConnectionState.done) {
          return const _CompletionSkeleton();
        }
        if (completion == null) return const SizedBox.shrink();
        return _CompletionCard(completion: completion);
      },
    );
  }
}

class _CompletionCard extends StatelessWidget {
  const _CompletionCard({required this.completion});

  final ProfileCompletionModel completion;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final nextItems = completion.items
        .where((item) => !item.completed)
        .take(3)
        .toList();
    final done = completion.score >= 100;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.48),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 58,
                height: 58,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CircularProgressIndicator(
                      value: completion.score.clamp(0, 100) / 100,
                      strokeWidth: 6,
                      backgroundColor: scheme.surface,
                    ),
                    Center(
                      child: Text(
                        '${completion.score}%',
                        style: theme.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      completion.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      done
                          ? 'All profile readiness checks are complete.'
                          : '${completion.completed}/${completion.total} complete',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      completion.subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (done)
            _CheckRow(
              title: 'Profile is fully set up',
              subtitle: 'Keep it fresh as your beauty journey grows.',
              completed: true,
            )
          else
            ...nextItems.map(
              (item) => Padding(
                padding: const EdgeInsets.only(top: 8),
                child: _CheckRow(
                  title: item.title,
                  subtitle: item.subtitle,
                  completed: item.completed,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CheckRow extends StatelessWidget {
  const _CheckRow({
    required this.title,
    required this.subtitle,
    required this.completed,
  });

  final String title;
  final String subtitle;
  final bool completed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          completed ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
          color: completed ? scheme.primary : scheme.onSurfaceVariant,
          size: 20,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CompletionSkeleton extends StatelessWidget {
  const _CompletionSkeleton();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      height: 110,
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.32),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
