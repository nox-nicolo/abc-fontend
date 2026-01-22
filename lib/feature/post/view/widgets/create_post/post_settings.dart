// lib/feature/profile/view/post/post_settings_page.dart
import 'package:africa_beuty/feature/post/view_model/post_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';

class PostSettingsPage extends ConsumerWidget {
  const PostSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final settingsAsync = ref.watch(postSettingsViewModelProvider);

    print(settingsAsync);

    final notifier = ref.read(postSettingsViewModelProvider.notifier);
    
    final textTheme = Theme.of(context).textTheme;

    return settingsAsync.when(
      data: (settings) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,

            children: [

              SizedBox(
                width: double.infinity,
                child: Text(
                  "Post Settings", 
                  style: textTheme.headlineSmall, 
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 24),

              Text("Privacy", style: textTheme.titleMedium),

              const SizedBox(height: 8),

              DropdownButtonFormField<String>(
                value: settings.visibility,
                // decoration: _inputDecoration("Visibility"),
                items: ['Public', 'Friends', 'Private'].map((value) {
                  return DropdownMenuItem(value: value, child: Text(value));
                }).toList(),
                onChanged: (value) {
                  if (value != null) notifier.setVisibility(value);
                },
              ),
              
              const SizedBox(height: 24),

              Text("Engagement", style: textTheme.titleLarge),

              const SizedBox(height: 8),

              _buildSwitch(
                "Show Likes Count", 
                Bootstrap.eye_fill, 
                settings.showLikes, notifier.toggleLikes
              ),

              _buildSwitch(
                "Enable Comments", 
                Bootstrap.chat_dots_fill, 
                settings.enableComments, notifier.toggleComments
                ),

              _buildSwitch(
                "Allow Sharing", 
                Bootstrap.share_fill, 
                settings.allowSharing, notifier.toggleSharing
              ),

              const SizedBox(height: 24),

              Text("Info", style: textTheme.titleLarge),

              const SizedBox(height: 8),

              _buildSwitch(
                "Show Location", 
                Bootstrap.geo_alt_fill, 
                settings.showLocation, 
                notifier.toggleLocation
              ),

              _buildSwitch(
                "Pinned", 
                Bootstrap.pin, 
                settings.pinned, 
                notifier.togglePinned
              ),

              const SizedBox(height: 24),

              Text("Advanced Settings", style: textTheme.titleLarge),

              const SizedBox(height: 8),

              Text("Age Restriction", style: textTheme.titleMedium),
              
              DropdownButtonFormField<String>(
                value: settings.ageRestriction,
                // decoration: _inputDecoration("Age Restriction"),
                items: ['Everyone', '13+', '18+'].map((value) {
                  return DropdownMenuItem(value: value, child: Text(value));
                }).toList(),
                onChanged: (value) {
                  if (value != null) notifier.setAgeRestriction(value);
                },
              ),

              const SizedBox(height: 16),
              _buildSwitch(
                "Disable Reactions",
                Bootstrap.emoji_smile,
                settings.disableReactions,
                notifier.toggleReactions,
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, st) => Center(child: Text("Error: $err")),
    );
  }

  // InputDecoration _inputDecoration(String label) {
  //   return InputDecoration(
  //     labelText: label,
  //     border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
  //     contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  //   );
  // }

  Widget _buildSwitch(String title, IconData icon, bool value, Function(bool) onChanged) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon),
      title: Text(title),
      trailing: Switch(value: value, onChanged: onChanged),
    );
  }
}
