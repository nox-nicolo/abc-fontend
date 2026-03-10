// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

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
  final int followers; // Mapped from SalonFollower
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
      'SalonFollower': followers, // Backend key
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
      
      // Fixed: Casting nested map
      location: map['location'] != null 
        ? LocationModel.fromMap(Map<String, dynamic>.from(map['location'] as Map)) 
        : null,

      // Fixed: Cleaning nested lists for Hive compatibility
      contacts: map['contacts'] is List 
          ? (map['contacts'] as List).map((x) => 
              ContactModel.fromMap(Map<String, dynamic>.from(x as Map))).toList()
          : [],

      workingHours: map['workingHours'] is List 
          ? (map['workingHours'] as List).map((x) => 
              WorkingHourModel.fromMap(Map<String, dynamic>.from(x as Map))).toList()
          : [],

      gallery: map['gallery'] is List 
          ? (map['gallery'] as List).map((x) => 
              GalleryModel.fromMap(Map<String, dynamic>.from(x as Map))).toList()
          : [],
          
      // Fixed: Backend sends "SalonFollower"
      followers: (map['SalonFollower'] as num?)?.toInt() ?? 0,
      rated: (map['rated'] as num?)?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());
  factory SalonProfileModel.fromJson(String source) => SalonProfileModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

// --- Sub-Models aligned with Backend Keys ---

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
      isPrimary: map['is_primary'] ?? false, // Backend uses snake_case
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
      dayOfWeek: (map['day_of_week'] as num?)?.toInt() ?? 0, // Backend uses snake_case
      isOpen: map['is_open'] ?? false,                      // Backend uses snake_case
      openTime: map['open_time']?.toString() ?? '',         // Backend uses snake_case
      closeTime: map['close_time']?.toString() ?? '',       // Backend uses snake_case
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
      imageUrl: map['image_url']?.toString() ?? '', // Backend uses image_url
    );
  }
}