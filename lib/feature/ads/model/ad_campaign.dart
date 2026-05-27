class AdCampaign {
  final String id;
  final String advertiserName;
  final String title;
  final String? body;
  final String ctaLabel;
  final String destinationUrl;
  final String mediaUrl;
  final String mediaType;
  final String placement;
  final String sponsoredLabel;

  const AdCampaign({
    required this.id,
    required this.advertiserName,
    required this.title,
    required this.body,
    required this.ctaLabel,
    required this.destinationUrl,
    required this.mediaUrl,
    required this.mediaType,
    required this.placement,
    required this.sponsoredLabel,
  });

  factory AdCampaign.fromMap(Map<String, dynamic> map) {
    return AdCampaign(
      id: (map['id'] ?? '').toString(),
      advertiserName: (map['advertiser_name'] ?? '').toString(),
      title: (map['title'] ?? '').toString(),
      body: map['body']?.toString(),
      ctaLabel: (map['cta_label'] ?? 'Learn more').toString(),
      destinationUrl: (map['destination_url'] ?? '').toString(),
      mediaUrl: (map['media_url'] ?? '').toString(),
      mediaType: (map['media_type'] ?? 'image').toString(),
      placement: (map['placement'] ?? '').toString(),
      sponsoredLabel: (map['sponsored_label'] ?? 'Sponsored').toString(),
    );
  }
}
