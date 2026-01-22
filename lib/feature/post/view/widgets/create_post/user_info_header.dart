
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class UserInfoHeader extends StatelessWidget {
  final String username;
  final String? profileImagePath;
  final VoidCallback? onSettingPressed;

  const UserInfoHeader({
    super.key,
    required this.username,
    this.profileImagePath,
    this.onSettingPressed
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: Theme.of(context).colorScheme.onSecondaryFixedVariant,
            child: ClipOval(
              child: profileImagePath != null && profileImagePath!.isNotEmpty
                  ? Image.network(
                      profileImagePath!,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      // Loading indicator while fetching image
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child; // Image loaded
                        return Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                    (loadingProgress.expectedTotalBytes ?? 1)
                                  : null, // indeterminate if total bytes unknown
                            ),
                          ),
                        );
                      },
                      // Error fallback
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.person, color: Theme.of(context).colorScheme.primary, size: 25);
                      },
                    )
                  : Icon(Icons.person, color: Theme.of(context).colorScheme.primary, size: 25),
            ),
          ),


          const SizedBox(width: 18),
          // User username
          Text(
            username,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          Spacer(), 
          IconButton(
            onPressed: onSettingPressed, 
            icon: 
              Icon(
                Bootstrap.gear_fill, 
                size: 18,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
        ],
      ),
    );
  }
}
