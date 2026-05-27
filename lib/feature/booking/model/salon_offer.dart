// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:africa_beuty/core/utils/image_url.dart';

class SalonOfferModel {
  final String salonServicePriceId;

  final String salonId;
  final String salonName;
  final String salonCity;
  final String salonImage;

  final String subServiceId;
  final String subServiceName;

  final double price;
  final String currency;
  final int durationMinutes;

  final double? rated;

  const SalonOfferModel({
    required this.salonServicePriceId,
    required this.salonId,
    required this.salonName,
    required this.salonCity,
    required this.salonImage,
    required this.subServiceId,
    required this.subServiceName,
    required this.price,
    required this.currency,
    required this.durationMinutes,
    this.rated,
  });

  factory SalonOfferModel.fromMap(Map<String, dynamic> map) {
    return SalonOfferModel(
      salonServicePriceId: map['salon_service_price_id']?.toString() ?? '',

      salonId: map['salon_id']?.toString() ?? '',
      salonName: _textOrEmpty(map['salon_name']),
      salonCity: _textOrEmpty(map['salon_city']),
      salonImage: imageUrlOrEmpty(
        map['salon_image'] ??
            map['profile_picture'] ??
            map['profile_picture_url'] ??
            map['avatar'] ??
            map['image_url'],
      ),

      subServiceId: map['sub_service_id']?.toString() ?? '',
      subServiceName: map['sub_service_name']?.toString() ?? '',

      price: (map['price'] as num?)?.toDouble() ?? 0,
      currency: map['currency']?.toString() ?? '',
      durationMinutes: (map['duration_minutes'] as num?)?.toInt() ?? 0,

      rated: (map['rated'] as num?)?.toDouble(),
    );
  }

  static List<SalonOfferModel> listFromJson(List list) {
    return list.map((e) => SalonOfferModel.fromMap(e)).toList();
  }
}

String _textOrEmpty(Object? value) {
  if (value == null) return '';
  final text = value.toString().trim();
  if (text.isEmpty || text.toLowerCase() == 'not set') return '';
  return text;
}
