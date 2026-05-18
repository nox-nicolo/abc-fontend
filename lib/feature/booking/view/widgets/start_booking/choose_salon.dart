import 'package:africa_beuty/core/widgets/app_state.dart';
import 'package:africa_beuty/core/widgets/skeleton.dart';
import 'package:africa_beuty/feature/booking/provider/booking_draft.dart';
import 'package:africa_beuty/feature/booking/view/widgets/start_booking/select_time.dart';
import 'package:africa_beuty/feature/booking/view_modal/salon_offer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChooseSalonPage extends ConsumerWidget {
  final String subServiceId;

  const ChooseSalonPage({super.key, required this.subServiceId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(salonOfferViewModelProvider(subServiceId));

    return Scaffold(
      appBar: AppBar(title: const Text('Choose a Salon')),
      body: state.when(
        loading: () => const _SalonOfferSkeletonList(),

        error: (e, _) => AppErrorState(
          message: e,
          onRetry: () =>
              ref.invalidate(salonOfferViewModelProvider(subServiceId)),
        ),

        data: (salons) {
          if (salons.isEmpty) {
            return const AppEmptyState(
              icon: Icons.storefront_outlined,
              title: 'No salons found',
              message: 'Try another style or refresh again soon.',
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: salons.length,
            itemBuilder: (_, i) {
              final s = salons[i];

              return InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  ref
                      .read(bookingDraftProvider.notifier)
                      .selectSalonOffer(
                        salonServicePriceId: s.salonServicePriceId,
                        salonName: s.salonName,
                        serviceName: s.subServiceName,
                        price: s.price,
                        currency: s.currency,
                        durationMinutes: s.durationMinutes,
                      );

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PickDateTimePage()),
                  );
                },
                child: Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        // -----------------------
                        // Salon image
                        // -----------------------
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: s.salonImage.isNotEmpty
                              ? Image.network(
                                  s.salonImage,
                                  width: 72,
                                  height: 72,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  width: 72,
                                  height: 72,
                                  color: Colors.grey.shade300,
                                  child: const Icon(Icons.store, size: 32),
                                ),
                        ),

                        const SizedBox(width: 12),

                        // -----------------------
                        // Salon info
                        // -----------------------
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                s.salonName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                s.salonCity,
                                style: const TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.schedule, size: 16),
                                  const SizedBox(width: 4),
                                  Text('${s.durationMinutes} mins'),
                                  const SizedBox(width: 12),
                                  const Icon(Icons.payments_outlined, size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${s.currency} ${s.price.toStringAsFixed(0)}',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _SalonOfferSkeletonList extends StatelessWidget {
  const _SalonOfferSkeletonList();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (_, _) => const SkeletonListTile(
        roundLeading: false,
        leadingSize: 72,
        trailingWidth: 54,
        padding: EdgeInsets.all(12),
      ),
    );
  }
}
