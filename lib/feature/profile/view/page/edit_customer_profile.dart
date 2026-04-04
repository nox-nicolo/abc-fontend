import 'package:africa_beuty/feature/profile/view_model/customer_profile.dart';
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
    final profile =
        ref.read(myCustomerProfileViewModelProvider).value;
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(err ?? 'Failed to update profile')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        centerTitle: true,
        actions: [
          _saving
              ? const Padding(
                  padding: EdgeInsets.all(14),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : TextButton(
                  onPressed: _save,
                  child: const Text('Save'),
                ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _field(
              controller: _name,
              label: 'Name',
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Name is required' : null,
            ),
            const SizedBox(height: 16),
            _field(
              controller: _bio,
              label: 'Bio',
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            _field(controller: _city, label: 'City'),
            const SizedBox(height: 16),
            _field(controller: _country, label: 'Country'),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _genders.contains(_gender) ? _gender : null,
              decoration: const InputDecoration(
                labelText: 'Gender',
                border: OutlineInputBorder(),
              ),
              items: _genders
                  .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                  .toList(),
              onChanged: (v) => setState(() => _gender = v),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
