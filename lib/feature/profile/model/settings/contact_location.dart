import 'dart:convert';

class ContactLocationUpdate {
  final List<String> phoneNumbers;
  final String email;
  final String website;
  final String country;
  final String city;
  final String street;
  final String address;
  final double latitude;
  final double longitude;

  ContactLocationUpdate({
    required this.phoneNumbers,
    required this.email,
    required this.website,
    required this.country,
    required this.city,
    required this.street,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toMap() {
    return {
      'phone_numbers': phoneNumbers,
      'email': email,
      'website': website,
      'country': country,
      'city': city,
      'street': street,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory ContactLocationUpdate.fromMap(Map<String, dynamic> map) {
    return ContactLocationUpdate(
      phoneNumbers: List<String>.from(map['phone_numbers'] ?? []),
      email: map['email'] ?? '',
      website: map['website'] ?? '',
      country: map['country'] ?? '',
      city: map['city'] ?? '',
      street: map['street'] ?? '',
      address: map['address'] ?? '',
      latitude: (map['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (map['longitude'] as num?)?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());
}