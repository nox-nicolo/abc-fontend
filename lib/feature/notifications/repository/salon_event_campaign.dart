import 'dart:convert';

import 'package:africa_beuty/core/constants/server_constants.dart';
import 'package:africa_beuty/core/failure/failure.dart';
import 'package:africa_beuty/core/http/api_client.dart';
import 'package:fpdart/fpdart.dart';

class SalonEventCampaignResult {
  const SalonEventCampaignResult({
    required this.targetGroup,
    required this.recipientsFound,
    required this.sent,
    required this.skippedDuplicates,
    this.sampleMessage,
  });

  final String targetGroup;
  final int recipientsFound;
  final int sent;
  final int skippedDuplicates;
  final String? sampleMessage;

  factory SalonEventCampaignResult.fromMap(Map<String, dynamic> map) {
    return SalonEventCampaignResult(
      targetGroup: map['target_group']?.toString() ?? '',
      recipientsFound: (map['recipients_found'] as num?)?.toInt() ?? 0,
      sent: (map['sent'] as num?)?.toInt() ?? 0,
      skippedDuplicates: (map['skipped_duplicates'] as num?)?.toInt() ?? 0,
      sampleMessage: map['sample_message'] as String?,
    );
  }
}

class SalonEventCampaignRepository {
  Future<Either<AppFailure, SalonEventCampaignResult>> sendCampaign({
    required String upcomingEvent,
    required int daysUntilEvent,
    required String serviceType,
    required String targetGroup,
    String? stylistName,
    String? bookingLink,
  }) async {
    try {
      final response = await ApiClient.instance.post(
        Uri.parse(
          '${ServerConstants.serverUrl}/notifications/salon/event-campaign',
        ),
        body: jsonEncode({
          'upcoming_event': upcomingEvent.trim(),
          'days_until_event': daysUntilEvent,
          'service_type': serviceType.trim(),
          'target_group': targetGroup,
          'stylist_name': _nullable(stylistName),
          'booking_link': _nullable(bookingLink),
        }),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return Right(
          SalonEventCampaignResult.fromMap(
            jsonDecode(response.body) as Map<String, dynamic>,
          ),
        );
      }
      return Left(AppFailure(_safeDetail(response.body)));
    } catch (e) {
      return Left(AppFailure('Could not send event campaign: $e'));
    }
  }

  Future<Either<AppFailure, SalonEventCampaignResult>> sendPromotion({
    required String offerTitle,
    required String serviceType,
    required String targetGroup,
    String? discountCode,
    String? expiresAt,
    String? stylistName,
    String? bookingLink,
  }) async {
    try {
      final response = await ApiClient.instance.post(
        Uri.parse(
          '${ServerConstants.serverUrl}/notifications/salon/promotion-campaign',
        ),
        body: jsonEncode({
          'offer_title': offerTitle.trim(),
          'service_type': serviceType.trim(),
          'target_group': targetGroup,
          'discount_code': _nullable(discountCode),
          'expires_at': _nullable(expiresAt),
          'stylist_name': _nullable(stylistName),
          'booking_link': _nullable(bookingLink),
        }),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return Right(
          SalonEventCampaignResult.fromMap(
            jsonDecode(response.body) as Map<String, dynamic>,
          ),
        );
      }
      return Left(AppFailure(_safeDetail(response.body)));
    } catch (e) {
      return Left(AppFailure('Could not send promotion: $e'));
    }
  }

  String? _nullable(String? value) {
    final trimmed = value?.trim();
    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }

  String _safeDetail(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map && decoded['detail'] != null) {
        return decoded['detail'].toString();
      }
    } catch (_) {}
    return 'Could not send event campaign';
  }
}
