/* ------------------------------------------------------------
   Model: Selected Service
------------------------------------------------------------- */

import 'dart:convert';

class SelectedServiceModel {
  SelectedServiceModel({
    required this.serviceId,
    required this.serviceName,
    required this.servicePicture,
  });

  final String serviceId;
  final String serviceName;
  final String servicePicture;

  SelectedServiceModel copyWith({
    String? serviceId,
    String? serviceName,
    String? servicePicture,
  }) {
    return SelectedServiceModel(
      serviceId: serviceId ?? this.serviceId,
      serviceName: serviceName ?? this.serviceName,
      servicePicture: servicePicture ?? this.servicePicture,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'service_id': serviceId,
      'service_name': serviceName,
      'service_picture': servicePicture,
    };
  }

  factory SelectedServiceModel.fromMap(Map<String, dynamic> map) {
    return SelectedServiceModel(
      serviceId: map['service_id'] ?? '',
      serviceName: map['service_name'] ?? '',
      servicePicture: map['service_picture'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory SelectedServiceModel.fromJson(String source) =>
      SelectedServiceModel.fromMap(json.decode(source));
}
