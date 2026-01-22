import 'package:flutter/material.dart';

class PostActionButtons extends StatelessWidget {
  final VoidCallback onCameraPressed;
  final VoidCallback onGalleryPressed;
  final VoidCallback onHashTagPressed;
  final VoidCallback onTagPressed;
  final int imageCount;
  final int maxImages;
  final int taggedPeopleCount; // New parameter for tagged people count

  const PostActionButtons({
    super.key,
    required this.onCameraPressed,
    required this.onGalleryPressed,
    required this.onHashTagPressed,
    required this.onTagPressed,
    required this.imageCount,
    required this.maxImages,
    this.taggedPeopleCount = 0, // Default to 0
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Row(
      children: [
        // Camera Button
        _ActionButton(
          icon: Icons.camera_alt_outlined,
          onPressed: imageCount < maxImages ? onCameraPressed : null,
          theme: theme,
          isDisabled: imageCount >= maxImages,
        ),
        const SizedBox(width: 12),
        
        // Gallery Button
        _ActionButton(
          icon: Icons.photo_library_outlined,
          onPressed: imageCount < maxImages ? onGalleryPressed : null,
          theme: theme,
          isDisabled: imageCount >= maxImages,
        ),
        const SizedBox(width: 12),
        
        // Hashtag Button
        _ActionButton(
          icon: Icons.tag,
          onPressed: onHashTagPressed,
          theme: theme,
        ),
        const SizedBox(width: 12),
        
        // Tag People Button with Count Badge
        _TagPeopleButton(
          onPressed: onTagPressed,
          taggedCount: taggedPeopleCount,
          theme: theme,
        ),
        
        const Spacer(),
        
        // Image Counter
        if (imageCount > 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$imageCount/$maxImages',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
          ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final ThemeData theme;
  final bool isDisabled;

  const _ActionButton({
    required this.icon,
    required this.onPressed,
    required this.theme,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDisabled 
              ? theme.colorScheme.surface.withOpacity(0.5)
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isDisabled 
                ? theme.colorScheme.outline.withOpacity(0.3)
                : theme.colorScheme.outline.withOpacity(0.5),
          ),
        ),
        child: Icon(
          icon,
          size: 20,
          color: isDisabled 
              ? theme.colorScheme.onSurface.withOpacity(0.3)
              : theme.colorScheme.onSurface.withOpacity(0.7),
        ),
      ),
    );
  }
}

class _TagPeopleButton extends StatelessWidget {
  final VoidCallback onPressed;
  final int taggedCount;
  final ThemeData theme;

  const _TagPeopleButton({
    required this.onPressed,
    required this.taggedCount,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: taggedCount > 0 
              ? theme.colorScheme.primaryContainer.withOpacity(0.7)
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: taggedCount > 0 
                ? theme.colorScheme.primary.withOpacity(0.5)
                : theme.colorScheme.outline.withOpacity(0.5),
          ),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(
              Icons.group_outlined,
              size: 20,
              color: taggedCount > 0 
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface.withOpacity(0.7),
            ),
            
            // Badge showing count
            if (taggedCount > 0)
              Positioned(
                right: -6,
                top: -6,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: theme.colorScheme.surface,
                      width: 1,
                    ),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    taggedCount.toString(),
                    style: TextStyle(
                      color: theme.colorScheme.onPrimary,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
