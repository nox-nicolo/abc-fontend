import 'package:africa_beuty/feature/auth/model/me_model.dart';
import 'package:africa_beuty/feature/auth/repositories/local_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

enum ProfileShareType { customer, salon }

class ProfileShareSheet extends StatelessWidget {
  const ProfileShareSheet._({required this.type});

  final ProfileShareType type;

  static Future<void> show(
    BuildContext context, {
    required ProfileShareType type,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      showDragHandle: true,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
      ),
      builder: (_) => ProfileShareSheet._(type: type),
    );
  }

  bool get _isSalon => type == ProfileShareType.salon;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<MeModel?>(
      future: LocalStorageService.getUserData(),
      builder: (context, snapshot) {
        final profile = _ShareProfile.fromUser(snapshot.data, type);
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.82,
          minChildSize: 0.42,
          maxChildSize: 0.94,
          builder: (context, controller) {
            return ListView(
              controller: controller,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              children: [
                _Header(profile: profile),
                const SizedBox(height: 18),
                _PreviewCard(profile: profile),
                const SizedBox(height: 14),
                _QrPanel(profile: profile),
                const SizedBox(height: 14),
                _LinkPanel(profile: profile),
                const SizedBox(height: 14),
                _ActionButtons(profile: profile),
                const SizedBox(height: 10),
                Text(
                  _isSalon
                      ? 'Salon links open the public salon profile, so customers can view services and request bookings.'
                      : 'Customer links open your public profile preview, based on your privacy and share settings.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _ShareProfile {
  _ShareProfile({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.handle,
    required this.deepLink,
    required this.shareText,
    required this.avatarUrl,
    required this.icon,
  });

  final ProfileShareType type;
  final String title;
  final String subtitle;
  final String handle;
  final String deepLink;
  final String shareText;
  final String avatarUrl;
  final IconData icon;

  factory _ShareProfile.fromUser(MeModel? user, ProfileShareType type) {
    final username = user?.username.trim() ?? '';
    final fallbackId = user?.id.trim() ?? '';
    final slug = username.isNotEmpty
        ? username
        : fallbackId.isNotEmpty
        ? fallbackId
        : 'profile';
    final handle = username.isNotEmpty ? '@$username' : slug;
    final isSalon = type == ProfileShareType.salon;
    final path = isSalon ? 's' : 'u';
    final deepLink =
        'https://africanbeauty.app/$path/${Uri.encodeComponent(slug)}';
    final title = isSalon ? 'Salon profile' : 'Customer profile';
    final subtitle = isSalon
        ? 'Share services, gallery, contact details, and booking access.'
        : 'Share your African Beauty customer profile with a clean link.';

    return _ShareProfile(
      type: type,
      title: title,
      subtitle: subtitle,
      handle: handle,
      deepLink: deepLink,
      shareText: isSalon
          ? 'View my salon on African Beauty: $deepLink'
          : 'View my African Beauty profile: $deepLink',
      avatarUrl: user?.profilePicture.trim() ?? '',
      icon: isSalon ? Icons.storefront_rounded : Icons.person_rounded,
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.profile});

  final _ShareProfile profile;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: scheme.primary.withValues(alpha: 0.12),
          ),
          child: Icon(Icons.ios_share_rounded, color: scheme.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Share ${profile.title.toLowerCase()}',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Preview, deep link, QR code, and native share sheet',
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

class _PreviewCard extends StatelessWidget {
  const _PreviewCard({required this.profile});

  final _ShareProfile profile;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Row(
        children: [
          _Avatar(profile: profile),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.handle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  profile.subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Icon(Icons.verified_rounded, color: scheme.primary, size: 22),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.profile});

  final _ShareProfile profile;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return CircleAvatar(
      radius: 30,
      backgroundColor: scheme.secondary.withValues(alpha: 0.13),
      backgroundImage: profile.avatarUrl.isEmpty
          ? null
          : NetworkImage(profile.avatarUrl),
      child: profile.avatarUrl.isEmpty
          ? Icon(profile.icon, color: scheme.secondary)
          : null,
    );
  }
}

class _QrPanel extends StatelessWidget {
  const _QrPanel({required this.profile});

  final _ShareProfile profile;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: QrImageView(
              data: profile.deepLink,
              size: 184,
              backgroundColor: Colors.white,
              eyeStyle: const QrEyeStyle(
                eyeShape: QrEyeShape.square,
                color: Colors.black,
              ),
              dataModuleStyle: const QrDataModuleStyle(
                dataModuleShape: QrDataModuleShape.square,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Scan to open profile',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            profile.deepLink,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _LinkPanel extends StatelessWidget {
  const _LinkPanel({required this.profile});

  final _ShareProfile profile;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.link_rounded, color: scheme.secondary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              profile.deepLink,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: () => _copy(context, profile.deepLink, 'Link copied'),
            child: const Text('Copy'),
          ),
        ],
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({required this.profile});

  final _ShareProfile profile;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: FilledButton.icon(
            onPressed: () async {
              await SharePlus.instance.share(
                ShareParams(
                  text: profile.shareText,
                  subject: 'African Beauty ${profile.title}',
                ),
              );
            },
            icon: const Icon(Icons.ios_share_rounded),
            label: const Text('Share'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _copy(context, profile.handle, 'Handle copied'),
            icon: const Icon(Icons.alternate_email_rounded),
            label: const Text('Handle'),
          ),
        ),
      ],
    );
  }
}

Future<void> _copy(BuildContext context, String text, String message) async {
  await Clipboard.setData(ClipboardData(text: text));
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
