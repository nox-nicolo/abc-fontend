import 'package:africa_beuty/feature/profile/view_model/salon.dart';
import 'package:africa_beuty/feature/profile/view_model/settings/profile_cover.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileDetailsPage extends ConsumerStatefulWidget {
  const ProfileDetailsPage({super.key});

  @override
  ConsumerState<ProfileDetailsPage> createState() => _ProfileDetailsPageState();
}

class _ProfileDetailsPageState extends ConsumerState<ProfileDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _salonNameController;
  late TextEditingController _sloganController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    // Get initial data from your existing SalonProfileViewModel
    final salon = ref.read(salonProfileViewModelProvider).value;
    
    _salonNameController = TextEditingController(text: salon?.title ?? "");
    _sloganController = TextEditingController(text: salon?.slogan ?? "");
    _descriptionController = TextEditingController(text: salon?.description ?? "");
  }

  @override
  void dispose() {
    _salonNameController.dispose();
    _sloganController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      await ref.read(salonUpdateViewModelProvider.notifier).updateSalonDetails(
            title: _salonNameController.text.trim(),
            slogan: _sloganController.text.trim(),
            description: _descriptionController.text.trim(),
          );

      final state = ref.read(salonUpdateViewModelProvider);
      if (state.hasValue && !state.hasError && mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final updateState = ref.watch(salonUpdateViewModelProvider);

    // Listen for errors
    ref.listen<AsyncValue>(salonUpdateViewModelProvider, (prev, next) {
      if (next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error.toString()), backgroundColor: Colors.red),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Details'),
        actions: [
          if (updateState.isLoading)
            const Center(child: Padding(padding: EdgeInsets.all(16), child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))))
          else
            TextButton(
              onPressed: _saveForm,
              child: Text('Save', style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInputField(
                label: "Salon Name",
                controller: _salonNameController,
                icon: Icons.storefront,
                theme: theme,
                validator: (value) => value!.isEmpty ? "Enter salon name" : null,
              ),
              const SizedBox(height: 24),
              _buildInputField(
                label: "Slogan",
                controller: _sloganController,
                icon: Icons.auto_awesome_outlined,
                theme: theme,
              ),
              const SizedBox(height: 24),
              _buildInputField(
                label: "Description",
                controller: _descriptionController,
                icon: Icons.description_outlined,
                theme: theme,
                maxLines: 4,
                validator: (value) => value!.isEmpty ? "Enter description" : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required ThemeData theme,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Label
        Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8), // Small offset for better alignment
            child: Text(
              label,
              style: theme.textTheme.titleSmall?.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.w500,
                letterSpacing: 1,
              ).copyWith(fontSize: 12),
            ),
          ),
        const SizedBox(height: 8),
        // Input Field
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            prefixIcon: Icon(icon),
            filled: true,
            fillColor: theme.colorScheme.surfaceVariant.withOpacity(0.2),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: theme.colorScheme.outlineVariant),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: theme.colorScheme.outlineVariant),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
