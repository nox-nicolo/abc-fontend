import 'dart:io';

import 'package:africa_beuty/feature/profile/model/profile_trust.dart';
import 'package:africa_beuty/feature/profile/repositories/profile_trust.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileTrustCard extends StatefulWidget {
  const ProfileTrustCard({super.key, required this.role});

  final String role;

  @override
  State<ProfileTrustCard> createState() => _ProfileTrustCardState();
}

class _ProfileTrustCardState extends State<ProfileTrustCard> {
  final _repo = ProfileTrustRepository();
  late Future<ProfileTrustModel?> _future;
  bool _uploading = false;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<ProfileTrustModel?> _load() async {
    final result = await _repo.getTrustStatus();
    return result.match((_) => null, (trust) => trust);
  }

  Future<void> _uploadDocument() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    setState(() => _uploading = true);
    final result = await _repo.uploadBusinessDocument(File(picked.path));
    if (!mounted) return;
    setState(() => _uploading = false);

    result.match((failure) => _showMessage(failure.message), (_) {
      _showMessage('Business document uploaded for review');
      setState(() => _future = _load());
    });
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ProfileTrustModel?>(
      future: _future,
      builder: (context, snapshot) {
        final trust = snapshot.data;
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(height: 124);
        }
        if (trust == null) return const SizedBox.shrink();
        return _TrustSurface(
          trust: trust,
          canUploadDocument:
              widget.role.trim().toLowerCase() != 'customer' &&
              widget.role.trim().toLowerCase() != 'user',
          uploading: _uploading,
          onUploadDocument: _uploadDocument,
        );
      },
    );
  }
}

class _TrustSurface extends StatelessWidget {
  const _TrustSurface({
    required this.trust,
    required this.canUploadDocument,
    required this.uploading,
    required this.onUploadDocument,
  });

  final ProfileTrustModel trust;
  final bool canUploadDocument;
  final bool uploading;
  final VoidCallback onUploadDocument;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final badgeColor = trust.safetyBadge
        ? scheme.primary
        : scheme.onSurfaceVariant;

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
              Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: badgeColor.withValues(alpha: 0.12),
                    child: Icon(
                      trust.safetyBadge
                          ? Icons.verified_user_rounded
                          : Icons.verified_user_outlined,
                      color: badgeColor,
                      size: 19,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Trust Layer',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          'Review status: ${_statusLabel(trust.profileReviewStatus)}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (trust.safetyBadge)
                    Icon(Icons.shield_rounded, color: scheme.primary),
                ],
              ),
              const SizedBox(height: 12),
              for (final item in trust.indicators)
                _TrustIndicatorRow(indicator: item),
              if (canUploadDocument && !trust.businessDocumentUploaded) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: uploading ? null : onUploadDocument,
                    icon: uploading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.upload_file_rounded),
                    label: Text(uploading ? 'Uploading...' : 'Upload document'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _statusLabel(String value) {
    final normalized = value.replaceAll('_', ' ');
    if (normalized.isEmpty) return 'Not submitted';
    return normalized[0].toUpperCase() + normalized.substring(1);
  }
}

class _TrustIndicatorRow extends StatelessWidget {
  const _TrustIndicatorRow({required this.indicator});

  final TrustIndicatorModel indicator;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final color = indicator.isMet ? scheme.primary : scheme.onSurfaceVariant;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            indicator.isMet
                ? Icons.check_circle_rounded
                : Icons.radio_button_unchecked_rounded,
            color: color,
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  indicator.label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (indicator.detail.isNotEmpty)
                  Text(
                    indicator.detail,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
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
