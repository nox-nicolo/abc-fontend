class PostMediaState {
  final String path;
  final double aspectRatio;
  final String type;

  const PostMediaState({
    required this.path,
    required this.aspectRatio,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      "path": path,
      "aspectRatio": aspectRatio,
      "type": type,
    };
  }
}
