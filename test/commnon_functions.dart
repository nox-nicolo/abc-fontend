
// Count String Format

String _formatCount(int count) {
  if (count >= 1000000) {
    return '${(count / 1000000).toStringAsFixed(1)}M posts';
  } else if (count >= 1000) {
    return '${(count / 1000).toStringAsFixed(1)}K posts';
  }
  return '$count posts';
}

