enum SalonServiceStatus {
  active,
  inactive,
  archived;

  static SalonServiceStatus fromJson(String value) {
    switch (value) {
      case 'active':
        return SalonServiceStatus.active;
      case 'inactive':
        return SalonServiceStatus.inactive;
      case 'archived':
        return SalonServiceStatus.archived;
      default:
        throw ArgumentError('Unknown SalonServiceStatus: $value');
    }
  }

  String toJson() => name;
}

class MessageResponseModel {
  final String message;

  const MessageResponseModel({
    required this.message,
  });

  factory MessageResponseModel.fromJson(Map<String, dynamic> json) {
    return MessageResponseModel(
      message: json['message'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'message': message,
      };
}

/// ----------------------
/// WRITE REQUEST MODELS
/// ----------------------
class ServiceConfigBenefit {
  final String benefit;
  final int position;

  const ServiceConfigBenefit({
    required this.benefit,
    required this.position,
  });

  Map<String, dynamic> toMap() {
    return {
      'benefit': benefit,
      'position': position,
    };
  }
}

class ServiceConfigProduct {
  final String productName;
  final String? brand;

  const ServiceConfigProduct({
    required this.productName,
    this.brand,
  });

  Map<String, dynamic> toMap() {
    return {
      'product_name': productName,
      'brand': brand,
    };
  }
}

class SalonServiceConfigRequestModel {
  final String serviceId;
  final String? subServiceId;
  final int? priceMin;
  final int? priceMax;
  final String currency;
  final int? durationMinutes;
  final int concurrentCapacity;
  final SalonServiceStatus status;
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
    this.concurrentCapacity = 1,
    required this.status,
    required this.stylistIds,
    required this.benefits,
    required this.products,
  });

  Map<String, dynamic> toMap() {
    return {
      'service_id': serviceId,
      'sub_service_id': subServiceId,
      'price_min': priceMin,
      'price_max': priceMax,
      'currency': currency,
      'duration_minutes': durationMinutes,
      'concurrent_capacity': concurrentCapacity,
      'status': status.toJson(),
      'stylist_ids': stylistIds,
      'benefits': benefits.map((e) => e.toMap()).toList(),
      'products': products.map((e) => e.toMap()).toList(),
    };
  }
}

/// ----------------------
/// READ RESPONSE MODELS
/// ----------------------
class SalonServiceBenefitModel {
  final String benefit;
  final int position;

  const SalonServiceBenefitModel({
    required this.benefit,
    required this.position,
  });

  factory SalonServiceBenefitModel.fromJson(Map<String, dynamic> json) {
    return SalonServiceBenefitModel(
      benefit: json['benefit'] as String,
      position: json['position'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'benefit': benefit,
      'position': position,
    };
  }
}

class SalonServiceProductModel {
  final String productName;
  final String? brand;

  const SalonServiceProductModel({
    required this.productName,
    this.brand,
  });

  factory SalonServiceProductModel.fromJson(Map<String, dynamic> json) {
    return SalonServiceProductModel(
      productName: json['product_name'] as String,
      brand: json['brand'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_name': productName,
      'brand': brand,
    };
  }
}

class SalonServiceConfigStylistModel {
  final String id;
  final String name;
  final String? image;

  const SalonServiceConfigStylistModel({
    required this.id,
    required this.name,
    this.image,
  });

  factory SalonServiceConfigStylistModel.fromJson(Map<String, dynamic> json) {
    return SalonServiceConfigStylistModel(
      id: json['id'] as String,
      name: json['name'] as String,
      image: json['image'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
    };
  }
}

class SalonServiceConfigModel {
  final String salonServicePriceId;
  final int? priceMin;
  final int? priceMax;
  final String currency;
  final int? durationMinutes;
  final int concurrentCapacity;
  final SalonServiceStatus status;
  final List<SalonServiceConfigStylistModel> stylists;
  final List<SalonServiceBenefitModel> benefits;
  final List<SalonServiceProductModel> products;

  const SalonServiceConfigModel({
    required this.salonServicePriceId,
    required this.priceMin,
    required this.priceMax,
    required this.currency,
    required this.durationMinutes,
    this.concurrentCapacity = 1,
    required this.status,
    required this.stylists,
    required this.benefits,
    required this.products,
  });

  factory SalonServiceConfigModel.fromJson(Map<String, dynamic> json) {
    return SalonServiceConfigModel(
      salonServicePriceId: json['salon_service_price_id'] as String,
      priceMin: json['price_min'] as int?,
      priceMax: json['price_max'] as int?,
      currency: json['currency'] as String,
      durationMinutes: json['duration_minutes'] as int?,
      concurrentCapacity: (json['concurrent_capacity'] as int?) ?? 1,
      status: SalonServiceStatus.fromJson(json['status'] as String),
      stylists: (json['stylists'] as List<dynamic>? ?? [])
          .map(
            (e) => SalonServiceConfigStylistModel.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
      benefits: (json['benefits'] as List<dynamic>? ?? [])
          .map(
            (e) => SalonServiceBenefitModel.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
      products: (json['products'] as List<dynamic>? ?? [])
          .map(
            (e) => SalonServiceProductModel.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'salon_service_price_id': salonServicePriceId,
      'price_min': priceMin,
      'price_max': priceMax,
      'currency': currency,
      'duration_minutes': durationMinutes,
      'concurrent_capacity': concurrentCapacity,
      'status': status.toJson(),
      'stylists': stylists.map((e) => e.toJson()).toList(),
      'benefits': benefits.map((e) => e.toJson()).toList(),
      'products': products.map((e) => e.toJson()).toList(),
    };
  }
}

class SalonServiceSelectableItemModel {
  final String serviceId;
  final String serviceName;
  final String? serviceImage;
  final String? subServiceId;
  final String? subServiceName;
  final String? subServiceImage;
  final bool isConfigured;
  final SalonServiceConfigModel? config;

  const SalonServiceSelectableItemModel({
    required this.serviceId,
    required this.serviceName,
    required this.serviceImage,
    required this.subServiceId,
    required this.subServiceName,
    required this.subServiceImage,
    required this.isConfigured,
    required this.config,
  });

  factory SalonServiceSelectableItemModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return SalonServiceSelectableItemModel(
      serviceId: json['service_id'] as String,
      serviceName: json['service_name'] as String,
      serviceImage: json['service_image'] as String?,
      subServiceId: json['sub_service_id'] as String?,
      subServiceName: json['sub_service_name'] as String?,
      subServiceImage: json['sub_service_image'] as String?,
      isConfigured: json['is_configured'] as bool,
      config: json['config'] == null
          ? null
          : SalonServiceConfigModel.fromJson(
              json['config'] as Map<String, dynamic>,
            ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'service_id': serviceId,
      'service_name': serviceName,
      'service_image': serviceImage,
      'sub_service_id': subServiceId,
      'sub_service_name': subServiceName,
      'sub_service_image': subServiceImage,
      'is_configured': isConfigured,
      'config': config?.toJson(),
    };
  }
}

class SalonServiceConfigDetailResponseModel {
  final SalonServiceSelectableItemModel item;

  const SalonServiceConfigDetailResponseModel({
    required this.item,
  });

  factory SalonServiceConfigDetailResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return SalonServiceConfigDetailResponseModel(
      item: SalonServiceSelectableItemModel.fromJson(
        json['item'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'item': item.toJson(),
    };
  }
}