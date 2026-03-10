class SalonServiceConfigRequestModel {
  final String serviceId;
  final String subServiceId;

  final int priceMin;
  final int priceMax;
  final String currency;
  final int durationMinutes;
  final String status;

  final List<String> stylistIds;
  final List<ServiceConfigBenefit> benefits;
  final List<ServiceConfigProduct> products;

  const SalonServiceConfigRequestModel({
    required this.serviceId,
    required this.subServiceId,
    required this.priceMin,
    required this.priceMax,
    required this.currency,
    required this.durationMinutes,
    required this.status,
    required this.stylistIds,
    required this.benefits,
    required this.products,
  });

  Map<String, dynamic> toMap() {
    return {
      "service_id": serviceId,
      "sub_service_id": subServiceId,
      "price_min": priceMin,
      "price_max": priceMax,
      "currency": currency,
      "duration_minutes": durationMinutes,
      "status": status,
      "stylist_ids": stylistIds,
      "benefits": benefits.map((e) => e.toMap()).toList(),
      "products": products.map((e) => e.toMap()).toList(),
    };
  }
}


class ServiceConfigBenefit {
  final String benefit;
  final int position;

  const ServiceConfigBenefit({
    required this.benefit,
    required this.position,
  });

  Map<String, dynamic> toMap() {
    return {
      "benefit": benefit,
      "position": position,
    };
  }
}


class ServiceConfigProduct {
  final String productName;
  final String brand;

  const ServiceConfigProduct({
    required this.productName,
    required this.brand,
  });

  Map<String, dynamic> toMap() {
    return {
      "product_name": productName,
      "brand": brand,
    };
  }
}
