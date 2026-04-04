import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:africa_beuty/feature/profile/view_model/salon.dart';
import 'package:africa_beuty/feature/profile/view_model/settings/profile_cover.dart';

class ContactsLocationPage extends ConsumerStatefulWidget {
  const ContactsLocationPage({super.key});

  @override
  ConsumerState<ContactsLocationPage> createState() => _ContactsLocationPageState();
}

class _ContactsLocationPageState extends ConsumerState<ContactsLocationPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  late final TextEditingController _phone1Controller;
  late final TextEditingController _phone2Controller;
  late final TextEditingController _phone3Controller;
  late final TextEditingController _emailController;
  late final TextEditingController _websiteController;
  
  // Location Controllers
  late final TextEditingController _countryController;
  late final TextEditingController _cityController;
  late final TextEditingController _streetController;
  late final TextEditingController _addressController;

  double? _latitude;
  double? _longitude;
  bool _fetchingLocation = false;

  @override
  void initState() {
    super.initState();
    
    // 1. Get existing data from the salon profile provider
    final salon = ref.read(salonProfileViewModelProvider).value;

    // 2. Filter contacts by type (assuming your model has type: 'phone', 'email', etc.)
    final phones = salon?.contacts.where((c) => c.type.toLowerCase() == 'phone').map((e) => e.value).toList() ?? [];
    final email = salon?.contacts.where((c) => c.type.toLowerCase() == 'email').map((e) => e.value).firstOrNull ?? '';
    final website = salon?.contacts.where((c) => c.type.toLowerCase() == 'website').map((e) => e.value).firstOrNull ?? '';

    // 3. Initialize Controllers with data from Database
    _phone1Controller = TextEditingController(text: phones.isNotEmpty ? phones[0] : "");
    _phone2Controller = TextEditingController(text: phones.length > 1 ? phones[1] : "");
    _phone3Controller = TextEditingController(text: phones.length > 2 ? phones[2] : "");
    _emailController = TextEditingController(text: email);
    _websiteController = TextEditingController(text: website);
    
    _countryController = TextEditingController(text: salon?.location?.country ?? "");
    _cityController = TextEditingController(text: salon?.location?.city ?? "");
    _streetController = TextEditingController(text: salon?.location?.street ?? "");
    _addressController = TextEditingController(text: salon?.location?.region ?? "");
    _latitude = salon?.location?.latitude;
    _longitude = salon?.location?.longitude;
  }

  @override
  void dispose() {
    _phone1Controller.dispose();
    _phone2Controller.dispose();
    _phone3Controller.dispose();
    _emailController.dispose();
    _websiteController.dispose();
    _countryController.dispose();
    _cityController.dispose();
    _streetController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _fetchLocation() async {
    setState(() => _fetchingLocation = true);
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) throw 'Location services are disabled.';

      LocationPermission perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
        if (perm == LocationPermission.denied) throw 'Location permission denied.';
      }
      if (perm == LocationPermission.deniedForever) {
        throw 'Location permission permanently denied. Enable it in settings.';
      }

      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.medium),
      );
      setState(() {
        _latitude = pos.latitude;
        _longitude = pos.longitude;
      });

      // Reverse-geocode to fill address fields
      try {
        final placemarks = await placemarkFromCoordinates(pos.latitude, pos.longitude);
        if (placemarks.isNotEmpty && mounted) {
          final p = placemarks.first;
          setState(() {
            if ((p.country ?? '').isNotEmpty) _countryController.text = p.country!;
            if ((p.locality ?? '').isNotEmpty) _cityController.text = p.locality!;
            if ((p.street ?? '').isNotEmpty) _streetController.text = p.street!;
            final region = [p.subLocality, p.administrativeArea]
                .where((s) => s != null && s.isNotEmpty)
                .join(', ');
            if (region.isNotEmpty) _addressController.text = region;
          });
        }
      } catch (_) {
        // Reverse geocoding failed silently — coordinates are still saved
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
      }
    } finally {
      setState(() => _fetchingLocation = false);
    }
  }

  Future<void> _saveForm() async {
    if (_formKey.currentState!.validate()) {
      // Prepare the phone numbers list (filtering out empty ones)
      final List<String> phoneNumbers = [
        _phone1Controller.text.trim(),
        _phone2Controller.text.trim(),
        _phone3Controller.text.trim(),
      ].where((p) => p.isNotEmpty).toList();

      // Call the View Model
      await ref.read(salonUpdateViewModelProvider.notifier).updateContactLocation(
        phoneNumbers: phoneNumbers,
        email: _emailController.text.trim(),
        website: _websiteController.text.trim(),
        country: _countryController.text.trim(),
        city: _cityController.text.trim(),
        street: _streetController.text.trim(),
        address: _addressController.text.trim(),
        latitude: _latitude,
        longitude: _longitude,
      );

      // Success feedback
      final state = ref.read(salonUpdateViewModelProvider);
      if (state is AsyncData && mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Contacts and Location updated!'), backgroundColor: Colors.green),
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
        title: const Text('Contact & Location'),
        actions: [
          updateState.isLoading
              ? const Center(child: Padding(padding: EdgeInsets.all(16), child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))))
              : TextButton(
                  onPressed: _saveForm,
                  child: const Text('Save', style: TextStyle(fontWeight: FontWeight.bold)),
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
              _buildSectionTitle(theme, "Communication"),
              _buildInputField(
                label: "Phone Number 1",
                controller: _phone1Controller,
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
                theme: theme,
              ),
              const SizedBox(height: 16),
              _buildInputField(
                label: "Phone Number 2",
                controller: _phone2Controller,
                icon: Icons.phone_android,
                keyboardType: TextInputType.phone,
                theme: theme,
              ),
              const SizedBox(height: 16),
              _buildInputField(
                label: "Phone Number 3",
                controller: _phone3Controller,
                icon: Icons.phone_iphone,
                keyboardType: TextInputType.phone,
                theme: theme,
              ),
              const SizedBox(height: 16),
              _buildInputField(
                label: "Email Address",
                controller: _emailController,
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                theme: theme,
                validator: (value) {
                  if (value != null && value.isNotEmpty && !value.contains('@')) {
                    return "Enter a valid email";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildInputField(
                label: "Website URL",
                controller: _websiteController,
                icon: Icons.language,
                keyboardType: TextInputType.url,
                theme: theme,
                hint: "https://mysalon.com",
              ),
              
              const SizedBox(height: 32),
              _buildSectionTitle(theme, "Location Details"),
              
              _buildInputField(
                label: "Country",
                controller: _countryController,
                icon: Icons.public,
                theme: theme,
              ),
              const SizedBox(height: 16),
              _buildInputField(
                label: "City",
                controller: _cityController,
                icon: Icons.location_city,
                theme: theme,
              ),
              const SizedBox(height: 16),
              _buildInputField(
                label: "Street",
                controller: _streetController,
                icon: Icons.streetview,
                theme: theme,
              ),
              const SizedBox(height: 16),
              _buildInputField(
                label: "Physical Address / Region",
                controller: _addressController,
                icon: Icons.map_outlined,
                theme: theme,
                maxLines: 2,
              ),
              
              const SizedBox(height: 24),

              // GPS coordinates picker
              _buildSectionTitle(theme, "GPS Coordinates"),
              OutlinedButton.icon(
                onPressed: _fetchingLocation ? null : _fetchLocation,
                icon: _fetchingLocation
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.my_location),
                label: Text(
                  _latitude != null
                      ? 'Lat ${_latitude!.toStringAsFixed(5)}, Lng ${_longitude!.toStringAsFixed(5)}'
                      : 'Get my current location',
                ),
              ),
              if (_latitude != null)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    'Tap again to update coordinates.',
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: theme.colorScheme.primary),
                  ),
                ),

              const SizedBox(height: 32),
              _buildInfoNote(theme),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(ThemeData theme, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title.toUpperCase(),
        style: theme.textTheme.titleSmall?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildInfoNote(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "All fields are optional. Leave blank to remove existing information.",
              style: theme.textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required ThemeData theme,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    String hint = "Optional",
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label,
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          style: const TextStyle(fontSize: 15),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 20),
            hintText: hint,
            isDense: true,
            filled: true,
            fillColor: theme.colorScheme.surfaceVariant.withOpacity(0.2),
            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: theme.colorScheme.outlineVariant),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: theme.colorScheme.outlineVariant.withOpacity(0.5)),
            ),
          ),
        ),
      ],
    );
  }
}