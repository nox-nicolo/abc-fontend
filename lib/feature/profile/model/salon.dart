// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:flutter/foundation.dart';

class SalonProfileModel {
  final String id;
  final String username;
  final String title;
  final String slogan;
  final String description;
  final String displayAds;
  final double profileCompletion;
  final String profilePicture;
  final LocationModel? location;
  final List<ContactModel> contacts;
  final List<WorkingHourModel> workingHours;
  final List<GalleryModel> gallery;
  final int followers;
  final double rated;

  SalonProfileModel({
    required this.id,
    required this.username,
    required this.title,
    required this.slogan,
    required this.description,
    required this.displayAds,
    required this.profileCompletion,
    required this.profilePicture,
    this.location,
    required this.contacts,
    required this.workingHours,
    required this.gallery,
    required this.followers,
    required this.rated,
  });

  SalonProfileModel copyWith({
    String? id,
    String? username,
    String? title,
    String? slogan,
    String? description,
    String? displayAds,
    double? profileCompletion,
    String? profilePicture,
    LocationModel? location,
    List<ContactModel>? contacts,
    List<WorkingHourModel>? workingHours,
    List<GalleryModel>? gallery,
    int? followers,
    double? rated,
  }) {
    return SalonProfileModel(
      id: id ?? this.id,
      username: username ?? this.username,
      title: title ?? this.title,
      slogan: slogan ?? this.slogan,
      description: description ?? this.description,
      displayAds: displayAds ?? this.displayAds,
      profileCompletion: profileCompletion ?? this.profileCompletion,
      profilePicture: profilePicture ?? this.profilePicture,
      location: location ?? this.location,
      contacts: contacts ?? this.contacts,
      workingHours: workingHours ?? this.workingHours,
      gallery: gallery ?? this.gallery,
      followers: followers ?? this.followers,
      rated: rated ?? this.rated,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'username': username,
      'title': title,
      'slogan': slogan,
      'description': description,
      'displayAds': displayAds,
      'profileCompletion': profileCompletion,
      'profilePicture': profilePicture,
      'location': location?.toMap(),
      'contacts': contacts.map((x) => x.toMap()).toList(),
      'workingHours': workingHours.map((x) => x.toMap()).toList(),
      'gallery': gallery.map((x) => x.toMap()).toList(),
      'followers': followers,
      'rated': rated,
    };
  }

  factory SalonProfileModel.fromMap(Map<String, dynamic> map) {
    return SalonProfileModel(
      id: map['id']?.toString() ?? '',
      username: map['username']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      slogan: map['slogan']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      displayAds: map['displayAds']?.toString() ?? '',
      profileCompletion: (map['profileCompletion'] as num?)?.toDouble() ?? 0.0,
      profilePicture: map['profilePicture']?.toString() ?? '',
      location: map['location'] != null ? LocationModel.fromMap(map['location'] as Map<String, dynamic>) : null,
      contacts: map['contacts'] is List 
          ? List<ContactModel>.from((map['contacts'] as List).map((x) => ContactModel.fromMap(x as Map<String, dynamic>)))
          : [],
      workingHours: map['workingHours'] is List 
          ? List<WorkingHourModel>.from((map['workingHours'] as List).map((x) => WorkingHourModel.fromMap(x as Map<String, dynamic>)))
          : [],
      gallery: map['gallery'] is List 
          ? List<GalleryModel>.from((map['gallery'] as List).map((x) => GalleryModel.fromMap(x as Map<String, dynamic>)))
          : [],
      followers: (map['followers'] as num?)?.toInt() ?? 0,
      rated: (map['rated'] as num?)?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory SalonProfileModel.fromJson(String source) => SalonProfileModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'SalonProfileModel(id: $id, title: $title, contacts: ${contacts.length}, gallery: ${gallery.length})';

  @override
  bool operator ==(covariant SalonProfileModel other) {
    if (identical(this, other)) return true;
    return other.id == id &&
      other.username == username &&
      other.title == title &&
      other.slogan == slogan &&
      other.description == description &&
      other.displayAds == displayAds &&
      other.profileCompletion == profileCompletion &&
      other.profilePicture == profilePicture &&
      other.location == location &&
      listEquals(other.contacts, contacts) &&
      listEquals(other.workingHours, workingHours) &&
      listEquals(other.gallery, gallery) &&
      other.followers == followers &&
      other.rated == rated;
  }

  @override
  int get hashCode => id.hashCode ^ username.hashCode ^ title.hashCode ^ slogan.hashCode ^ description.hashCode ^ displayAds.hashCode ^ profileCompletion.hashCode ^ profilePicture.hashCode ^ location.hashCode ^ contacts.hashCode ^ workingHours.hashCode ^ gallery.hashCode ^ followers.hashCode ^ rated.hashCode;
}

// --- Sub-Models in the same style ---

class LocationModel {
  final String country;
  final String city;
  final String street;
  final String region;
  final double latitude;
  final double longitude;

  LocationModel({required this.country, required this.city, required this.street, required this.region, required this.latitude, required this.longitude});

  Map<String, dynamic> toMap() => {'country': country, 'city': city, 'street': street, 'region': region, 'latitude': latitude, 'longitude': longitude};

  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      country: map['country']?.toString() ?? '',
      city: map['city']?.toString() ?? '',
      street: map['street']?.toString() ?? '',
      region: map['region']?.toString() ?? '',
      latitude: (map['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (map['longitude'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class ContactModel {
  final String id;
  final String type;
  final String value;
  final bool isPrimary;

  ContactModel({required this.id, required this.type, required this.value, required this.isPrimary});

  Map<String, dynamic> toMap() => {'id': id, 'type': type, 'value': value, 'is_primary': isPrimary};

  factory ContactModel.fromMap(Map<String, dynamic> map) {
    return ContactModel(
      id: map['id']?.toString() ?? '',
      type: map['type']?.toString() ?? '',
      value: map['value']?.toString() ?? '',
      isPrimary: map['is_primary'] ?? false,
    );
  }
}

class WorkingHourModel {
  final int dayOfWeek;
  final bool isOpen;
  final String openTime;
  final String closeTime;

  WorkingHourModel({required this.dayOfWeek, required this.isOpen, required this.openTime, required this.closeTime});

  Map<String, dynamic> toMap() => {'day_of_week': dayOfWeek, 'is_open': isOpen, 'open_time': openTime, 'close_time': closeTime};

  factory WorkingHourModel.fromMap(Map<String, dynamic> map) {
    return WorkingHourModel(
      dayOfWeek: (map['day_of_week'] as num?)?.toInt() ?? 0,
      isOpen: map['is_open'] ?? false,
      openTime: map['open_time']?.toString() ?? '',
      closeTime: map['close_time']?.toString() ?? '',
    );
  }
}

class GalleryModel {
  final String id;
  final String imageUrl;

  GalleryModel({required this.id, required this.imageUrl});

  Map<String, dynamic> toMap() => {'id': id, 'image_url': imageUrl};

  factory GalleryModel.fromMap(Map<String, dynamic> map) {
    return GalleryModel(
      id: map['id']?.toString() ?? '',
      imageUrl: map['image_url']?.toString() ?? '',
    );
  }
}