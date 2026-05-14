import 'package:africa_beuty/feature/profile/model/customer_profile.dart';
import 'package:africa_beuty/feature/profile/view_model/customer_profile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditCustomerProfilePage extends ConsumerStatefulWidget {
  const EditCustomerProfilePage({super.key});

  @override
  ConsumerState<EditCustomerProfilePage> createState() =>
      _EditCustomerProfilePageState();
}

class _EditCustomerProfilePageState
    extends ConsumerState<EditCustomerProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _bio;
  late final TextEditingController _city;
  late final TextEditingController _country;
  String? _gender;
  bool _saving = false;

  static const _genders = ['male', 'female', 'prefer not to say'];

  @override
  void initState() {
    super.initState();
    final profile = ref.read(myCustomerProfileViewModelProvider).value;
    _name = TextEditingController(text: profile?.name ?? '');
    _bio = TextEditingController(text: profile?.bio ?? '');
    _city = TextEditingController(text: profile?.city ?? '');
    _country = TextEditingController(text: profile?.country ?? '');
    _gender = profile?.gender;
  }

  @override
  void dispose() {
    _name.dispose();
    _bio.dispose();
    _city.dispose();
    _country.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    setState(() => _saving = true);

    final ok = await ref
        .read(myCustomerProfileViewModelProvider.notifier)
        .update(
          name: _name.text.trim(),
          bio: _bio.text.trim(),
          city: _city.text.trim(),
          country: _country.text.trim(),
          gender: _gender,
        );

    if (!mounted) return;
    setState(() => _saving = false);

    if (ok) {
      Navigator.pop(context);
    } else {
      final err = ref
          .read(myCustomerProfileViewModelProvider)
          .error
          ?.toString();
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text(err ?? 'Failed to update profile')),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(myCustomerProfileViewModelProvider).value;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        title: const Text('Edit account'),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          TextButton(
            onPressed: _saving ? null : _save,
            child: Text(_saving ? 'Saving' : 'Save'),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(20, 10, 20, 16),
        child: SizedBox(
          height: 54,
          child: FilledButton.icon(
            onPressed: _saving ? null : _save,
            icon: _saving
                ? SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: scheme.onPrimary,
                    ),
                  )
                : const Icon(Icons.check_rounded),
            label: Text(_saving ? 'Saving changes' : 'Save changes'),
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          children: [
            _ProfilePreview(profile: profile),
            const SizedBox(height: 28),
            _SectionHeader(
              title: 'Personal details',
              subtitle: 'Keep your profile clear and easy for salons to know.',
            ),
            const SizedBox(height: 14),
            _field(
              controller: _name,
              label: 'Full name',
              icon: Icons.badge_outlined,
              textInputAction: TextInputAction.next,
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Name is required' : null,
            ),
            const SizedBox(height: 14),
            _field(
              controller: _bio,
              label: 'Bio',
              icon: Icons.auto_awesome_outlined,
              hintText: 'A short note about your style preferences',
              maxLines: 4,
              textInputAction: TextInputAction.newline,
            ),
            const SizedBox(height: 24),
            _SectionHeader(
              title: 'Location',
              subtitle: 'This helps personalize salons and services near you.',
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _field(
                    controller: _city,
                    label: 'City',
                    icon: Icons.location_city_outlined,
                    textInputAction: TextInputAction.next,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _field(
                    controller: _country,
                    label: 'Country',
                    icon: Icons.public_outlined,
                    textInputAction: TextInputAction.done,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _SectionHeader(
              title: 'Gender',
              subtitle: 'Optional, and only used to refine your experience.',
            ),
            const SizedBox(height: 14),
            _GenderSelector(
              value: _genders.contains(_gender) ? _gender : null,
              options: _genders,
              onChanged: (value) => setState(() => _gender = value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    String? hintText,
    TextInputAction? textInputAction,
    String? Function(String?)? validator,
  }) {
    final scheme = Theme.of(context).colorScheme;

    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: scheme.surfaceContainerHighest.withValues(alpha: 0.72),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: scheme.primary, width: 1.5),
        ),
      ),
    );
  }
}

class _ProfilePreview extends StatelessWidget {
  const _ProfilePreview({required this.profile});

  final CustomerProfileModel? profile;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final username = profile?.username.trim();
    final location = [
      profile?.city?.trim(),
      profile?.country?.trim(),
    ].where((part) => part != null && part.isNotEmpty).join(', ');

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: scheme.primaryContainer.withValues(alpha: 0.42),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: scheme.primary.withValues(alpha: 0.12)),
      ),
      child: Row(
        children: [
          _Avatar(imageUrl: profile?.profilePicture),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile?.name.isNotEmpty == true
                      ? profile!.name
                      : 'Your profile',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                if (username != null && username.isNotEmpty)
                  Text(
                    '@$username',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                if (location.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.place_outlined,
                        size: 16,
                        color: scheme.primary,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          location,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: scheme.onSurfaceVariant),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: 74,
      height: 74,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: scheme.surface, width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipOval(
        child: imageUrl != null && imageUrl!.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: imageUrl!,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => _fallback(),
              )
            : _fallback(),
      ),
    );
  }

  Widget _fallback() {
    return Image.asset('assets/images/dp.jpg', fit: BoxFit.cover);
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
        ),
      ],
    );
  }
}

class _GenderSelector extends StatelessWidget {
  const _GenderSelector({
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final String? value;
  final List<String> options;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        for (final option in options)
          ChoiceChip(
            selected: value == option,
            label: Text(_labelFor(option)),
            avatar: value == option
                ? Icon(Icons.check_rounded, size: 18, color: scheme.onPrimary)
                : null,
            onSelected: (selected) => onChanged(selected ? option : null),
            selectedColor: scheme.primary,
            backgroundColor: scheme.surfaceContainerHighest.withValues(
              alpha: 0.72,
            ),
            labelStyle: TextStyle(
              color: value == option ? scheme.onPrimary : scheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
            side: BorderSide(
              color: value == option ? scheme.primary : scheme.outlineVariant,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
      ],
    );
  }

  String _labelFor(String option) {
    if (option == 'prefer not to say') return 'Prefer not to say';
    return option[0].toUpperCase() + option.substring(1);
  }
}
