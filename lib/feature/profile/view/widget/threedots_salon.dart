import 'package:africa_beuty/feature/booking/view/pages/salon_booking.dart';
import 'package:africa_beuty/feature/post/view/page/post_management.dart';
import 'package:africa_beuty/feature/profile/view/page/appointment_settings.dart';
import 'package:africa_beuty/feature/profile/view/page/salon_event_campaign.dart';
import 'package:africa_beuty/feature/profile/view/page/three_dots_tools.dart';
import 'package:africa_beuty/feature/profile/view/widget/three_dots/service/salon_service.dart';
import 'package:africa_beuty/feature/profile/view/widget/three_dots/stylist/stylist_management.dart';
import 'package:africa_beuty/feature/profile/view/widget/settings/edit_salon_profile.dart';
import 'package:africa_beuty/feature/saved/view/page/saved_page.dart';
import 'package:flutter/material.dart';

class ThreedotsSalon extends StatefulWidget {
  const ThreedotsSalon({super.key});

  @override
  State<ThreedotsSalon> createState() => _ThreedotsSalonState();
}

class _ThreedotsSalonState extends State<ThreedotsSalon> {
  void _open(Widget page) {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Salon tools', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          ListTile(
            onTap: () {
              _open(const PostManagementPage());
            },
            leading: Icon(
              Icons.photo_library_outlined,
              color: theme.colorScheme.secondary,
            ),
            title: const Text('Content Management'),
            subtitle: const Text('View, manage, and delete posts'),
          ),
          const Divider(height: 1),
          ListTile(
            onTap: () {
              _open(const SalonStylistsPage());
            },
            leading: Icon(
              Icons.face_2_rounded,
              color: theme.colorScheme.secondary,
            ),
            title: const Text('Stylists Management'),
            subtitle: const Text('Add, edit, assign, and remove stylists'),
          ),
          const Divider(height: 1),
          ListTile(
            onTap: () {
              _open(SelectServicePage());
            },
            leading: Icon(Icons.edit, color: theme.colorScheme.secondary),
            title: const Text('Service Management'),
            subtitle: const Text('Create services, pricing, durations'),
          ),
          const Divider(height: 1),
          ListTile(
            onTap: () => _open(const SalonEventCampaignPage()),
            leading: Icon(
              Icons.sell_rounded,
              color: theme.colorScheme.secondary,
            ),
            title: const Text('Marketing & Promotion'),
            subtitle: const Text('Campaigns, offers, events, rebooking'),
          ),
          const Divider(height: 1),
          ListTile(
            onTap: () => _open(const SalonBookingPage()),
            leading: Icon(
              Icons.calendar_today_rounded,
              color: theme.colorScheme.secondary,
            ),
            title: const Text('Booking Management'),
            subtitle: const Text('Requests, schedule, confirmations'),
          ),
          const Divider(height: 1),
          ListTile(
            onTap: () => _open(
              const ProfileToolPage(
                title: 'Payments',
                subtitle:
                    'Prepare salon payment tools for deposits, payouts, and business invoices.',
                icon: Icons.monetization_on,
                items: [
                  ProfileToolItem(
                    icon: Icons.account_balance_wallet_rounded,
                    title: 'Payout setup',
                    subtitle: 'Connect payout account for salon earnings.',
                    badge: 'Setup',
                  ),
                  ProfileToolItem(
                    icon: Icons.receipt_long_rounded,
                    title: 'Invoices',
                    subtitle: 'Track booking receipts and salon records.',
                    badge: 'Soon',
                  ),
                  ProfileToolItem(
                    icon: Icons.verified_rounded,
                    title: 'Deposit protection',
                    subtitle: 'Reduce no-shows with booking deposits.',
                    badge: 'Premium',
                  ),
                ],
              ),
            ),
            leading: Icon(
              Icons.monetization_on,
              color: theme.colorScheme.secondary,
            ),
            title: const Text('Payments'),
            subtitle: const Text('Payouts, deposits, invoices'),
          ),
          const Divider(height: 1),
          ListTile(
            onTap: () => _open(
              const ProfileToolPage(
                title: 'Reports & Analytics',
                subtitle:
                    'Understand bookings, customer retention, service demand, and profile engagement.',
                icon: Icons.analytics_outlined,
                items: [
                  ProfileToolItem(
                    icon: Icons.trending_up_rounded,
                    title: 'Booking trends',
                    subtitle: 'See busiest days, services, and time slots.',
                    badge: 'Premium',
                  ),
                  ProfileToolItem(
                    icon: Icons.people_alt_rounded,
                    title: 'Customer insights',
                    subtitle: 'Follower growth, returning customers, and saves.',
                    badge: 'Premium',
                  ),
                  ProfileToolItem(
                    icon: Icons.visibility_rounded,
                    title: 'Profile reach',
                    subtitle: 'Track views, taps, and service interest.',
                    badge: 'Soon',
                  ),
                ],
              ),
            ),
            leading: Icon(
              Icons.analytics_outlined,
              color: theme.colorScheme.secondary,
            ),
            title: const Text('Reports & Analytics'),
            subtitle: const Text('Summary, trends, profile reach'),
          ),
          const Divider(height: 1),
          ListTile(
            onTap: () => _open(const SalonProfileInformationPage()),
            leading: Icon(Icons.mediation, color: theme.colorScheme.secondary),
            title: const Text('Social & Availability'),
            subtitle: const Text('Contacts, socials, hours, location'),
          ),
          const Divider(height: 1),
          ListTile(
            onTap: () {
              _open(const SavedPage());
            },
            leading: Icon(
              Icons.bookmark_border,
              color: theme.colorScheme.secondary,
            ),
            title: const Text('Saved'),
            subtitle: const Text('Saved services, salons, and styles'),
          ),
          const Divider(height: 1),
          ListTile(
            onTap: () => _open(const AppointmentSettingsPage()),
            leading: Icon(
              Icons.tune_rounded,
              color: theme.colorScheme.secondary,
            ),
            title: const Text('Booking Rules'),
            subtitle: const Text('Reminder timing and appointment controls'),
          ),
        ],
      ),
    );
  }
}
