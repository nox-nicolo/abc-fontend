import 'dart:convert';

class SalonServiceItemModel {
  SalonServiceItemModel({
    required this.serviceId,
    required this.subServiceId,
    required this.serviceName,
    required this.subServiceName,
    required this.serviceImage,
    required this.isConfigured,
    this.salonServicePriceId,
    this.status,
  });

  final String serviceId;
  final String subServiceId;
  final String serviceName;     // Category
  final String subServiceName;  // Actual service
  final String serviceImage;    // Full image URL
  final bool isConfigured;
  final String? salonServicePriceId;
  final String? status;

  SalonServiceItemModel copyWith({
    String? serviceId,
    String? subServiceId,
    String? serviceName,
    String? subServiceName,
    String? serviceImage,
    bool? isConfigured,
    String? salonServicePriceId,
    String? status,
  }) {
    return SalonServiceItemModel(
      serviceId: serviceId ?? this.serviceId,
      subServiceId: subServiceId ?? this.subServiceId,
      serviceName: serviceName ?? this.serviceName,
      subServiceName: subServiceName ?? this.subServiceName,
      serviceImage: serviceImage ?? this.serviceImage,
      isConfigured: isConfigured ?? this.isConfigured,
      salonServicePriceId: salonServicePriceId ?? this.salonServicePriceId,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'service_id': serviceId,
      'sub_service_id': subServiceId,
      'service_name': serviceName,
      'sub_service_name': subServiceName,
      'service_image': serviceImage,
      'is_configured': isConfigured,
      'salon_service_price_id': salonServicePriceId,
      'status': status,
    };
  }

  factory SalonServiceItemModel.fromMap(Map<String, dynamic> map) {
    return SalonServiceItemModel(
      serviceId: map['service_id'] ?? "",
      subServiceId: map['sub_service_id'] ?? "",
      serviceName: map['service_name'] ?? "",
      subServiceName: map['sub_service_name'] ?? "",
      serviceImage: map['service_image'] ?? "",
      isConfigured: map['is_configured'] ?? false,
      salonServicePriceId: map['salon_service_price_id'],
      status: map['status'],
    );
  }

  String toJson() => json.encode(toMap());

  factory SalonServiceItemModel.fromJson(String source) =>
      SalonServiceItemModel.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );

  @override
  String toString() {
    return 'SalonServiceItemModel(serviceId: $serviceId, subServiceId: $subServiceId, serviceName: $serviceName, subServiceName: $subServiceName, serviceImage: $serviceImage, isConfigured: $isConfigured, salonServicePriceId: $salonServicePriceId, status: $status)';
  }

  @override
  bool operator ==(covariant SalonServiceItemModel other) {
    if (identical(this, other)) return true;

    return
      other.serviceId == serviceId &&
      other.subServiceId == subServiceId &&
      other.serviceName == serviceName &&
      other.subServiceName == subServiceName &&
      other.serviceImage == serviceImage &&
      other.isConfigured == isConfigured &&
      other.salonServicePriceId == salonServicePriceId &&
      other.status == status;
  }

  @override
  int get hashCode {
    return serviceId.hashCode ^
      subServiceId.hashCode ^
      serviceName.hashCode ^
      subServiceName.hashCode ^
      serviceImage.hashCode ^
      isConfigured.hashCode ^
      salonServicePriceId.hashCode ^
      status.hashCode;
  }
}



class ConfigureServiceContextModel {
  const ConfigureServiceContextModel({
    required this.serviceId,
    required this.serviceName,
    required this.serviceImage,
    required this.subServiceId,
    required this.subServiceName,
    required this.subServiceImage,
  });

  final String serviceId;
  final String serviceName;
  final String serviceImage;

  final String subServiceId;
  final String subServiceName;
  final String subServiceImage;

  ConfigureServiceContextModel copyWith({
    String? serviceId,
    String? serviceName,
    String? serviceImage,
    String? subServiceId,
    String? subServiceName,
    String? subServiceImage,
  }) {
    return ConfigureServiceContextModel(
      serviceId: serviceId ?? this.serviceId,
      serviceName: serviceName ?? this.serviceName,
      serviceImage: serviceImage ?? this.serviceImage,
      subServiceId: subServiceId ?? this.subServiceId,
      subServiceName: subServiceName ?? this.subServiceName,
      subServiceImage: subServiceImage ?? this.subServiceImage,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'service_id': serviceId,
      'service_name': serviceName,
      'service_image': serviceImage,
      'sub_service_id': subServiceId,
      'sub_service_name': subServiceName,
      'sub_service_image': subServiceImage,
    };
  }

  factory ConfigureServiceContextModel.fromMap(Map<String, dynamic> map) {
    return ConfigureServiceContextModel(
      serviceId: map['service_id'] ?? '',
      serviceName: map['service_name'] ?? '',
      serviceImage: map['service_image'] ?? '',
      subServiceId: map['sub_service_id'] ?? '',
      subServiceName: map['sub_service_name'] ?? '',
      subServiceImage: map['sub_service_image'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ConfigureServiceContextModel.fromJson(String source) =>
      ConfigureServiceContextModel.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );

  @override
  String toString() {
    return 'ConfigureServiceContextModel(serviceId: $serviceId, serviceName: $serviceName, serviceImage: $serviceImage, subServiceId: $subServiceId, subServiceName: $subServiceName, subServiceImage: $subServiceImage)';
  }

  @override
  bool operator ==(covariant ConfigureServiceContextModel other) {
    if (identical(this, other)) return true;

    return other.serviceId == serviceId &&
        other.serviceName == serviceName &&
        other.serviceImage == serviceImage &&
        other.subServiceId == subServiceId &&
        other.subServiceName == subServiceName &&
        other.subServiceImage == subServiceImage;
  }

  @override
  int get hashCode {
    return serviceId.hashCode ^
        serviceName.hashCode ^
        serviceImage.hashCode ^
        subServiceId.hashCode ^
        subServiceName.hashCode ^
        subServiceImage.hashCode;
  }
}