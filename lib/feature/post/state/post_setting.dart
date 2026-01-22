class PostSettingsState {
  final String visibility;
  final bool showLikes;
  final bool enableComments;
  final bool allowSharing;
  final bool showLocation;
  final bool pinned;
  final String ageRestriction;
  final bool disableReactions;

  const PostSettingsState({
    this.visibility = "Public",
    this.showLikes = true,
    this.enableComments = true,
    this.allowSharing = true,
    this.showLocation = false,
    this.pinned = false,
    this.ageRestriction = "Everyone",
    this.disableReactions = false,
  });

  Map<String, dynamic> toJson() {
    return {
      "visibility": visibility,
      "showLikes": showLikes,
      "enableComments": enableComments,
      "allowSharing": allowSharing,
      "showLocation": showLocation,
      "pinned": pinned,
      "ageRestriction": ageRestriction,
      "disableReactions": disableReactions,
    };
  }

  PostSettingsState copyWith({
    String? visibility,
    bool? showLikes,
    bool? enableComments,
    bool? allowSharing,
    bool? showLocation,
    bool? pinned,
    String? ageRestriction,
    bool? disableReactions,
  }) {
    return PostSettingsState(
      visibility: visibility ?? this.visibility,
      showLikes: showLikes ?? this.showLikes,
      enableComments: enableComments ?? this.enableComments,
      allowSharing: allowSharing ?? this.allowSharing,
      showLocation: showLocation ?? this.showLocation,
      pinned: pinned ?? this.pinned,
      ageRestriction: ageRestriction ?? this.ageRestriction,
      disableReactions: disableReactions ?? this.disableReactions,
    );
  }
}
