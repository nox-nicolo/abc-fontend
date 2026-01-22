// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PostSettings {
  final String visibility;
  final bool showLikes;
  final bool enableComments;
  final bool allowSharing;
  final bool showLocation;
  final bool pinned;
  final String ageRestriction;
  final bool disableReactions;

  const PostSettings({
    this.visibility = 'Public',
    this.showLikes = true,
    this.enableComments = true,
    this.allowSharing = true,
    this.showLocation = false,
    this.pinned = false,
    this.ageRestriction = 'Everyone',
    this.disableReactions = false,
  });

  PostSettings copyWith({
    String? visibility,
    bool? showLikes,
    bool? enableComments,
    bool? allowSharing,
    bool? showLocation,
    bool? pinned,
    String? ageRestriction,
    bool? disableReactions,
  }) {
    return PostSettings(
      visibility: visibility ??   this.visibility,
      showLikes: showLikes ?? this.showLikes,
      enableComments: enableComments ?? this.enableComments,
      allowSharing: allowSharing ?? this.allowSharing,
      showLocation: showLocation ?? this.showLocation,
      pinned: pinned ?? this.pinned,
      ageRestriction: ageRestriction ?? this.ageRestriction,
      disableReactions: disableReactions ?? this.disableReactions,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'visibility': visibility,
      'showLikes': showLikes,
      'enableComments': enableComments,
      'allowSharing': allowSharing,
      'showLocation': showLocation,
      'pinned': pinned,
      'ageRestriction': ageRestriction,
      'disableReactions': disableReactions,
    };
  }

  factory PostSettings.fromMap(Map<String, dynamic> map) {
    return PostSettings(
      visibility: map['visibility'] as String,
      showLikes: map['showLikes'] as bool,
      enableComments: map['enableComments'] as bool,
      allowSharing: map['allowSharing'] as bool,
      showLocation: map['showLocation'] as bool,
      pinned: map['pinned'] as bool,
      ageRestriction: map['ageRestriction'] as String,
      disableReactions: map['disableReactions'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory PostSettings.fromJson(String source) => PostSettings.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PostSettings(visibility: $visibility, showLikes: $showLikes, enableComments: $enableComments, allowSharing: $allowSharing, showLocation: $showLocation, pinned: $pinned, ageRestriction: $ageRestriction, disableReactions: $disableReactions)';
  }

  @override
  bool operator ==(covariant PostSettings other) {
    if (identical(this, other)) return true;
  
    return 
      other.visibility == visibility &&
      other.showLikes == showLikes &&
      other.enableComments == enableComments &&
      other.allowSharing == allowSharing &&
      other.showLocation == showLocation &&
      other.pinned == pinned &&
      other.ageRestriction == ageRestriction &&
      other.disableReactions == disableReactions;
  }

  @override
  int get hashCode {
    return visibility.hashCode ^
      showLikes.hashCode ^
      enableComments.hashCode ^
      allowSharing.hashCode ^
      showLocation.hashCode ^
      pinned.hashCode ^
      ageRestriction.hashCode ^
      disableReactions.hashCode;
  }
}
