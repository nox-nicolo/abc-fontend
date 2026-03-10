import 'dart:convert';

/* ───────────────────────── ROOT MODEL ───────────────────────── */

class SalonServiceConfigModel {
  const SalonServiceConfigModel({
    required this.serviceId,
    required this.serviceName,
    required this.serviceImage,
    required this.subServiceId,
    required this.subServiceName,
    required this.subServiceImage,
    required this.isConfigured,
    this.config,
  });

  final String serviceId;
  final String serviceName;
  final String serviceImage;

  final String subServiceId;
  final String subServiceName;
  final String subServiceImage;

  final bool isConfigured;
  final SalonServiceConfigDetailsModel? config;

  // --------------------------------------------------
  // COPY
  // --------------------------------------------------
  SalonServiceConfigModel copyWith({
    String? serviceId,
    String? serviceName,
    String? serviceImage,
    String? subServiceId,
    String? subServiceName,
    String? subServiceImage,
    bool? isConfigured,
    SalonServiceConfigDetailsModel? config,
  }) {
    return SalonServiceConfigModel(
      serviceId: serviceId ?? this.serviceId,
      serviceName: serviceName ?? this.serviceName,
      serviceImage: serviceImage ?? this.serviceImage,
      subServiceId: subServiceId ?? this.subServiceId,
      subServiceName: subServiceName ?? this.subServiceName,
      subServiceImage: subServiceImage ?? this.subServiceImage,
      isConfigured: isConfigured ?? this.isConfigured,
      config: config ?? this.config,
    );
  }

  // --------------------------------------------------
  // SERIALIZATION
  // --------------------------------------------------
  Map<String, dynamic> toMap() {
    return {
      'service_id': serviceId,
      'service_name': serviceName,
      'service_image': serviceImage,
      'sub_service_id': subServiceId,
      'sub_service_name': subServiceName,
      'sub_service_image': subServiceImage,
      'is_configured': isConfigured,
      'config': config?.toMap(),
    };
  }

  factory SalonServiceConfigModel.fromMap(Map<String, dynamic> map) {
    return SalonServiceConfigModel(
      serviceId: map['service_id'] ?? '',
      serviceName: map['service_name'] ?? '',
      serviceImage: map['service_image'] ?? '',
      subServiceId: map['sub_service_id'] ?? '',
      subServiceName: map['sub_service_name'] ?? '',
      subServiceImage: map['sub_service_image'] ?? '',
      isConfigured: map['is_configured'] ?? false,
      config: map['config'] != null
          ? SalonServiceConfigDetailsModel.fromMap(
              map['config'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SalonServiceConfigModel.fromJson(String source) =>
      SalonServiceConfigModel.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );

  @override
  String toString() {
    return 'SalonServiceConfigModel(serviceId: $serviceId, subServiceId: $subServiceId, isConfigured: $isConfigured)';
  }

  @override
  bool operator ==(covariant SalonServiceConfigModel other) {
    if (identical(this, other)) return true;

    return other.serviceId == serviceId &&
        other.subServiceId == subServiceId &&
        other.isConfigured == isConfigured;
  }

  @override
  int get hashCode {
    return serviceId.hashCode ^
        subServiceId.hashCode ^
        isConfigured.hashCode;
  }
}


class SalonServiceConfigDetailsModel {
  const SalonServiceConfigDetailsModel({
    required this.salonServicePriceId,
    required this.priceMin,
    required this.priceMax,
    required this.currency,
    required this.durationMinutes,
    required this.status,
    required this.stylistIds,
    required this.benefits,
    required this.products,
  });

  final String salonServicePriceId;
  final int priceMin;
  final int priceMax;
  final String currency;
  final int durationMinutes;
  final String status;

  final List<String> stylistIds;
  final List<ServiceBenefitModel> benefits;
  final List<ServiceProductModel> products;

  // --------------------------------------------------
  // SERIALIZATION
  // --------------------------------------------------
  Map<String, dynamic> toMap() {
    return {
      'salon_service_price_id': salonServicePriceId,
      'price_min': priceMin,
      'price_max': priceMax,
      'currency': currency,
      'duration_minutes': durationMinutes,
      'status': status,
      'stylist_ids': stylistIds,
      'benefits': benefits.map((e) => e.toMap()).toList(),
      'products': products.map((e) => e.toMap()).toList(),
    };
  }

  factory SalonServiceConfigDetailsModel.fromMap(Map<String, dynamic> map) {
    return SalonServiceConfigDetailsModel(
      salonServicePriceId: map['salon_service_price_id'] ?? '',
      priceMin: map['price_min'] ?? 0,
      priceMax: map['price_max'] ?? 0,
      currency: map['currency'] ?? '',
      durationMinutes: map['duration_minutes'] ?? 0,
      status: map['status'] ?? '',
      stylistIds: List<String>.from(map['stylist_ids'] ?? const []),
      benefits: (map['benefits'] as List? ?? [])
          .map((e) => ServiceBenefitModel.fromMap(e))
          .toList(),
      products: (map['products'] as List? ?? [])
          .map((e) => ServiceProductModel.fromMap(e))
          .toList(),
    );
  }
}


class ServiceBenefitModel {
  const ServiceBenefitModel({
    required this.benefit,
    required this.position,
  });

  final String benefit;
  final int position;

  Map<String, dynamic> toMap() {
    return {
      'benefit': benefit,
      'position': position,
    };
  }

  factory ServiceBenefitModel.fromMap(Map<String, dynamic> map) {
    return ServiceBenefitModel(
      benefit: map['benefit'] ?? '',
      position: map['position'] ?? 0,
    );
  }
}


class ServiceProductModel {
  const ServiceProductModel({
    required this.productName,
    required this.brand,
  });

  final String productName;
  final String brand;

  Map<String, dynamic> toMap() {
    return {
      'product_name': productName,
      'brand': brand,
    };
  }

  factory ServiceProductModel.fromMap(Map<String, dynamic> map) {
    return ServiceProductModel(
      productName: map['product_name'] ?? '',
      brand: map['brand'] ?? '',
    );
  }
}
