import 'dart:io';
import 'dart:ui';

class ImageEditData {
  final File image;
  final double aspectRatio;
  final String type;
  // final Rect? cropRect; // Optional: crop area within the image
  // final bool isCropped;
  // final int rotation;
  // final bool flipX;
  // final bool flipY;

  const ImageEditData({
    required this.image,
    required this.aspectRatio,
    required this.type,
    // this.cropRect,
    // this.isCropped = false,
    // this.rotation = 0, // 0, 90, 180, 270 degrees
    // this.flipX = false,
    // this.flipY = false,
  });

  ImageEditData copyWith({
    File? image,
    double? aspectRatio,
    String? type,
    Rect? cropRect,
    bool? isCropped,
    int? rotation,
    bool? flipX,
    bool? flipY,
  }) {
    return ImageEditData(
      image: image ?? this.image,
      aspectRatio: aspectRatio ?? this.aspectRatio,
      type: type ?? this.type,
      // cropRect: cropRect ?? this.cropRect,
      // isCropped: isCropped ?? this.isCropped,
      // rotation: rotation ?? this.rotation,
      // flipX: flipX ?? this.flipX,
      // flipY: flipY ?? this.flipY,
    );
  }

  @override
  String toString() {
    return 'ImageEditData(image: ${image.path}, aspectRatio: $aspectRatio, type: $type)';  //  , cropRect: $cropRect, isCropped: $isCropped, rotation: $rotation, flipX: $flipX, flipY: $flipY
  }

  /// Converts the object to a JSON-serializable Map.
  /// This method is crucial for ensuring the 'media' list is populated with data.
  Map<String, dynamic> toJson() {
    return {
      // 1. Serialize the File by its path (required for later uploading)
      'path': image.path, 
      'aspectRatio': aspectRatio,
      'type': type,
      // 'isCropped': isCropped,
      // 'rotation': rotation,
      // 'flipX': flipX,
      // 'flipY': flipY,
      
      // 2. Serialize the Rect object into a Map of its coordinates
      // 'cropRect': cropRect != null ? {
      //   'left': cropRect!.left,
      //   'top': cropRect!.top,
      //   'right': cropRect!.right,
      //   'bottom': cropRect!.bottom,
      // } : null, // Send null if no crop is applied
    };
  }
}

// Updated aspect ratios with your exact specifications: 5:4, 16:9, 1:1, 4:5, 2:3, 9:16, and free
class AspectRatioOption {
  final String label;
  final double ratio;
  final String description;

  const AspectRatioOption({
    required this.label,
    required this.ratio,
    required this.description,
  });

  static const List<AspectRatioOption> predefinedRatios = [
    AspectRatioOption(label: '5:4', ratio: 5/4, description: 'Classic'),      // 1.25
    AspectRatioOption(label: '16:9', ratio: 16/9, description: 'Widescreen'), // 1.78
    AspectRatioOption(label: '1:1', ratio: 1.0, description: 'Square'),       // 1.0
    AspectRatioOption(label: '4:5', ratio: 4/5, description: 'Portrait'),     // 0.8
    AspectRatioOption(label: '2:3', ratio: 2/3, description: 'Photo'),        // 0.67
    AspectRatioOption(label: '9:16', ratio: 9/16, description: 'Story'),      // 0.56
    AspectRatioOption(label: 'Free', ratio: -1, description: 'Original'),     // Free crop
  ];
}
