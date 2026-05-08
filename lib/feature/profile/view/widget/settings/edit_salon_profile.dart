import 'package:africa_beuty/feature/profile/model/salon.dart';
import 'package:africa_beuty/feature/profile/view/widget/settings/salon_contacts.dart';
import 'package:africa_beuty/feature/profile/view/widget/settings/salon_gallery.dart';
import 'package:africa_beuty/feature/profile/view/widget/settings/salon_prof_cover_photo.dart';
import 'package:africa_beuty/feature/profile/view/widget/settings/salon_details.dart';
import 'package:africa_beuty/feature/profile/view/widget/settings/salon_working_hours.dart';
import 'package:africa_beuty/feature/profile/view_model/salon.dart'; // Import your view model
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SalonProfileInformationPage extends ConsumerWidget {
  const SalonProfileInformationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final salonState = ref.watch(salonProfileViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Salon Information")),
      body: salonState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (salon) => SingleChildScrollView(
          child: Column(
            children: [
              _CoverProfileSection(salon: salon),
              const SizedBox(height: 64),
              _ProfileSection(salon: salon),
              const SizedBox(height: 24),
              _ContactLocationSection(salon: salon),
              const SizedBox(height: 24),
              _WorkingHoursSection(salon: salon),
              const SizedBox(height: 24),
              _GallerySection(salon: salon),
            ],
          ),
        ),
      ),
    );
  }
}

/* -------------------------------------------------------------------------- */
/* COVER & PROFILE                               */
/* -------------------------------------------------------------------------- */

class _CoverProfileSection extends StatelessWidget {
  final SalonProfileModel salon;
  const _CoverProfileSection({required this.salon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // ───────────────── Dynamic Cover Image ─────────────────
        SizedBox(
          height: screenHeight * 0.35,
          width: double.infinity,
          child: salon.displayAds.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: salon.displayAds,
                  fit: BoxFit.cover,
                  placeholder: (_, _) => Container(color: colorScheme.surfaceContainerHighest),
                  errorWidget: (_, _, _) => Container(color: Colors.brown.shade400),
                )
              : Container(color: Colors.brown.shade400),
        ),

        Positioned(
          top: MediaQuery.of(context).padding.top + 8,
          right: 8,
          child: IconButton(
            icon: const Icon(Icons.edit),
            color: Colors.white,
            style: IconButton.styleFrom(backgroundColor: Colors.black26),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileCoverPhoto())),
          ),
        ),

        // ───────────────── Dynamic Profile Picture ─────────────────
        Positioned(
          bottom: -56,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: colorScheme.surface, width: 4),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 12)],
              ),
              child: CircleAvatar(
                radius: 60,
                backgroundColor: colorScheme.surfaceContainerHighest,
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: salon.profilePicture,
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                    errorWidget: (_, _, _) => const Icon(Icons.person, size: 48),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/* -------------------------------------------------------------------------- */
/* PROFILE DETAILS                               */
/* -------------------------------------------------------------------------- */

class _ProfileSection extends StatelessWidget {
  final SalonProfileModel salon;
  const _ProfileSection({required this.salon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SettingsHeader(
          name: 'Profile',
          icon: Icons.edit_rounded,
          onEdit: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileDetailsPage())),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              DisplayText(title: 'Owner Name', text: salon.title, icon: Icons.person_rounded),
              const SizedBox(height: 8),
              DisplayText(title: 'Salon Username', text: '@${salon.username}', icon: Icons.alternate_email),
              const SizedBox(height: 8),
              DisplayText(title: 'Slogan', text: salon.slogan.isEmpty ? 'No slogan set' : salon.slogan, icon: Icons.format_quote_rounded),
              const SizedBox(height: 8),
              DisplayText(title: 'Description', text: salon.description, icon: Icons.description_rounded),
            ],
          ),
        )
      ],
    );
  }
}

/* -------------------------------------------------------------------------- */
/* WORKING HOURS (SMART)                            */
/* -------------------------------------------------------------------------- */

class _WorkingHoursSection extends StatelessWidget {
  final SalonProfileModel salon;
  const _WorkingHoursSection({required this.salon});

  @override
  Widget build(BuildContext context) {

    // Helper to format "10:00:00" -> "10:00"
    String formatTime(String time) {
      if (time.isEmpty) return '';
      final parts = time.split(':');
      if (parts.length >= 2) return '${parts[0]}:${parts[1]}';
      return time;
    }

    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    // Helper for Day Names
    final List<String> weekDays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

    return Column(
      children: [
        SettingsHeader(
          name: 'Working Hours',
          icon: Icons.edit_rounded,
          onEdit: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WorkingHoursPage())),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: primaryColor.withOpacity(0.2)),
            ),
            child: Column(
              children: salon.workingHours.map((hour) {
                return Column(
                  children: [
                    _HourRow(
                      day: weekDays[hour.dayOfWeek],
                      value: hour.isOpen ? '${formatTime(hour.openTime)} - ${formatTime(hour.closeTime)}' : 'Closed',
                      isClosed: !hour.isOpen,
                    ),
                    if (hour.dayOfWeek != 6) const Divider(height: 16, thickness: 0.2),
                  ],
                );
              }).toList(),
            ),
          ),
        )
      ],
    );
  }
}


class _HourRow extends StatelessWidget {
  final String day;
  final String value;
  final bool isClosed;

  const _HourRow({
    required this.day, 
    required this.value, 
    this.isClosed = false
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          day,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: isClosed ? Colors.redAccent : primaryColor,
          ),
        ),
      ],
    );
  }
}


/* -------------------------------------------------------------------------- */
/* GALLERY SECTION                              */
/* -------------------------------------------------------------------------- */

class _GallerySection extends StatelessWidget {
  final SalonProfileModel salon;
  const _GallerySection({required this.salon});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsHeader(
          name: 'Gallery',
          icon: Icons.edit_rounded,
          onEdit: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GalleryPage())),
        ),
        SizedBox(
          height: 160,
          child: salon.gallery.isEmpty ?  
            SizedBox(
              child: Center(
                child: Text(
                  'Add Gallery',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSecondary
                  ),
                ),
              ),
            )
          :
            ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: salon.gallery.length,
              itemBuilder: (context, index) {
                return
                Container(
                  width: 140,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(salon.gallery[index].imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
        const SizedBox(height: 20),
      ],
    );
  }
}

/* -------------------------------------------------------------------------- */
/* CONTACT & LOCATION SECTION                          */
/* -------------------------------------------------------------------------- */

class _ContactLocationSection extends StatelessWidget {
  final SalonProfileModel salon;
  const _ContactLocationSection({required this.salon});

  @override
  Widget build(BuildContext context) {
    // 1. Extract the main phone number (first one found)
    final mainPhone = salon.contacts
        .where((c) => c.type.toLowerCase() == 'phone')
        .map((e) => e.value)
        .firstOrNull ?? 'No phone number set';

    // 2. Extract the business email
    final email = salon.contacts
        .where((c) => c.type.toLowerCase() == 'email')
        .map((e) => e.value)
        .firstOrNull ?? 'No email set';

    // 3. Combine Country, City, and Street into a single address string
    final location = salon.location;
    final fullAddress = location != null 
        ? "${location.street}, ${location.city}, ${location.country}"
        : 'No address set';

    return Column(
      children: [
        SettingsHeader(
          name: 'Contact & Location', 
          icon: Icons.edit_rounded, 
          onEdit: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const ContactsLocationPage(),
              ),
            );
          },
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Use the dynamic phone number
              DisplayText(
                title: 'Phone Number', 
                text: mainPhone, 
                icon: Icons.phone_android_rounded,
              ),
              const SizedBox(height: 12),
              
              // Use the dynamic email
              DisplayText(
                title: 'Business Email', 
                text: email, 
                icon: Icons.email_outlined,
              ),
              const SizedBox(height: 12),
              
              // Use the combined address string
              DisplayText(
                title: 'Address', 
                text: fullAddress, 
                icon: Icons.location_on_outlined,
              ),
              const SizedBox(height: 24),

              // Text(
              //   'Live Location',
              //   style: Theme.of(context).textTheme.titleSmall?.copyWith(
              //     color: Theme.of(context).colorScheme.primary,
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
              // const SizedBox(height: 8),
              
              // Container(
              //   height: 200,
              //   width: double.infinity,
              //   clipBehavior: Clip.antiAlias,
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(16),
              //     border: Border.all(
              //       color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
              //     ),
              //   ),
              //   child: const _MapPlaceholder(), 
              // ),
              const SizedBox(height: 20),
            ],
          ),
        )
      ],
    );
  }
}

class _MapPlaceholder extends StatelessWidget {
  const _MapPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: const Text('Map Preview'),
    );
  }
}

// ------------------------------------------------------------------
// Reusable Widgets
// ------------------------------------------------------------------
class SettingsHeader extends StatelessWidget {
  final String name;
  final IconData icon;
  final VoidCallback onEdit;

  const SettingsHeader({
    required this.name,
    required this.icon,
    required this.onEdit,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(
        left: 20,
        right: 16,
        top: 24,
        bottom: 12,
      ),
      child: Row(
        children: [
          // ───────────── Title ─────────────
          Expanded(
            child: Text(
              name,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
                letterSpacing: -1,
                fontSize: 20,
              ),
            ),
          ),

          // ───────────── Edit Action ─────────────
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest
                  .withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: onEdit,
              icon: Icon(
                icon,
                size: 18,
                color: theme.colorScheme.primary,
              ),
              tooltip: 'Edit',
            ),
          ),
        ],
      ),
    );
  }
}


class DisplayText extends StatelessWidget {
  final String title;
  final String text;
  final IconData? icon;

  const DisplayText({
    super.key, 
    required this.title, 
    required this.text, 
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Title Section
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8), // Small offset for better alignment
            child: Text(
              title,
              style: theme.textTheme.titleSmall?.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.w500,
                letterSpacing: 1,
              ).copyWith(fontSize: 12),
            ),
          ),

          // 2. The Expanding "Button" Container
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: primaryColor.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start, // Icon stays at the top if text wraps
              children: [
                if (icon != null) ...[
                  Icon(icon, color: primaryColor, size: 20),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Text(
                    text,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: primaryColor.withOpacity(0.9), // Slightly softer than title
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                    ),
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