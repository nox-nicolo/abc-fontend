import 'package:africa_beuty/feature/notifications/repository/salon_event_campaign.dart';
import 'package:flutter/material.dart';

class SalonEventCampaignPage extends StatefulWidget {
  const SalonEventCampaignPage({super.key});

  @override
  State<SalonEventCampaignPage> createState() => _SalonEventCampaignPageState();
}

class _SalonEventCampaignPageState extends State<SalonEventCampaignPage> {
  final _formKey = GlobalKey<FormState>();
  final _repo = SalonEventCampaignRepository();
  final _eventController = TextEditingController();
  final _offerController = TextEditingController();
  final _discountController = TextEditingController();
  final _expiryController = TextEditingController();
  final _serviceController = TextEditingController();
  final _stylistController = TextEditingController();
  final _linkController = TextEditingController();

  String _targetGroup = 'followers';
  String _campaignType = 'promotion';
  int _daysUntilEvent = 21;
  bool _sending = false;
  SalonEventCampaignResult? _lastResult;

  @override
  void dispose() {
    _eventController.dispose();
    _offerController.dispose();
    _discountController.dispose();
    _expiryController.dispose();
    _serviceController.dispose();
    _stylistController.dispose();
    _linkController.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _sending = true;
      _lastResult = null;
    });

    final result = _campaignType == 'event'
        ? await _repo.sendCampaign(
            upcomingEvent: _eventController.text,
            daysUntilEvent: _daysUntilEvent,
            serviceType: _serviceController.text,
            targetGroup: _targetGroup,
            stylistName: _stylistController.text,
            bookingLink: _linkController.text,
          )
        : await _repo.sendPromotion(
            offerTitle: _offerController.text,
            serviceType: _serviceController.text,
            targetGroup: _targetGroup,
            discountCode: _discountController.text,
            expiresAt: _expiryController.text,
            stylistName: _stylistController.text,
            bookingLink: _linkController.text,
          );

    if (!mounted) return;
    result.match(
      (failure) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(failure.message))),
      (success) {
        setState(() => _lastResult = success);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sent to ${success.sent} customers')),
        );
      },
    );

    setState(() => _sending = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Campaigns')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Send trusted in-app offers to customers who already know your salon. Customers book here and pay you directly.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: SegmentedButton<String>(
              segments: const [
                ButtonSegment(
                  value: 'promotion',
                  icon: Icon(Icons.local_offer_outlined),
                  label: Text('Promotion'),
                ),
                ButtonSegment(
                  value: 'event',
                  icon: Icon(Icons.celebration_outlined),
                  label: Text('Event'),
                ),
              ],
              selected: {_campaignType},
              onSelectionChanged: (value) {
                setState(() {
                  _campaignType = value.first;
                  _lastResult = null;
                });
              },
            ),
          ),
          const SizedBox(height: 16),
          Form(
            key: _formKey,
            child: Column(
              children: [
                if (_campaignType == 'event') ...[
                  TextFormField(
                    controller: _eventController,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: 'Event',
                      hintText: 'Eid, Christmas, school holidays',
                      border: OutlineInputBorder(),
                    ),
                    validator: _required,
                  ),
                  const SizedBox(height: 12),
                ] else ...[
                  TextFormField(
                    controller: _offerController,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      labelText: 'Offer',
                      hintText: '20% off braids this week',
                      border: OutlineInputBorder(),
                    ),
                    validator: _required,
                  ),
                  const SizedBox(height: 12),
                ],
                const SizedBox(height: 12),
                TextFormField(
                  controller: _serviceController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Service',
                    hintText: 'Braids, nails, facial',
                    border: OutlineInputBorder(),
                  ),
                  validator: _required,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _targetGroup,
                  decoration: const InputDecoration(
                    labelText: 'Target customers',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'followers',
                      child: Text('Followers'),
                    ),
                    DropdownMenuItem(
                      value: 'past_customers',
                      child: Text('Past customers'),
                    ),
                    DropdownMenuItem(
                      value: 'all_engaged',
                      child: Text('Followers and past customers'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) setState(() => _targetGroup = value);
                  },
                ),
                if (_campaignType == 'event') ...[
                  const SizedBox(height: 12),
                  _DaysField(
                    value: _daysUntilEvent,
                    onChanged: (value) =>
                        setState(() => _daysUntilEvent = value),
                  ),
                ],
                if (_campaignType == 'promotion') ...[
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _discountController,
                    textCapitalization: TextCapitalization.characters,
                    decoration: const InputDecoration(
                      labelText: 'Discount code',
                      hintText: 'Optional, e.g. BRAIDS20',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _expiryController,
                    decoration: const InputDecoration(
                      labelText: 'Valid until',
                      hintText: 'Optional, e.g. Saturday or 31 May',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                TextFormField(
                  controller: _stylistController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Stylist',
                    hintText: 'Optional',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _linkController,
                  decoration: const InputDecoration(
                    labelText: 'Booking link',
                    hintText: 'Optional',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _sending ? null : _send,
            icon: _sending
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.campaign_rounded),
            label: Text(
              _campaignType == 'event'
                  ? 'Send event notification'
                  : 'Send promotion',
            ),
          ),
          if (_lastResult != null) ...[
            const SizedBox(height: 16),
            _ResultCard(result: _lastResult!),
          ],
        ],
      ),
    );
  }

  String? _required(String? value) {
    if (value == null || value.trim().length < 2) {
      return 'Required';
    }
    return null;
  }
}

class _DaysField extends StatelessWidget {
  const _DaysField({required this.value, required this.onChanged});

  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: const InputDecoration(
        labelText: 'Days until event',
        border: OutlineInputBorder(),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$value days'),
          Slider(
            value: value.toDouble(),
            min: 0,
            max: 21,
            divisions: 21,
            label: '$value',
            onChanged: (next) => onChanged(next.round()),
          ),
        ],
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.result});

  final SalonEventCampaignResult result;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Found ${result.recipientsFound} customers'),
            Text('Sent ${result.sent} notifications'),
            if (result.skippedDuplicates > 0)
              Text('Skipped ${result.skippedDuplicates} duplicates'),
            if (result.sampleMessage != null) ...[
              const SizedBox(height: 12),
              Text(
                result.sampleMessage!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
