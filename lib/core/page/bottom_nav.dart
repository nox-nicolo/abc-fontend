import 'package:africa_beuty/feature/auth/repositories/local_storage_service.dart';
import 'package:africa_beuty/feature/booking/view/pages/booking.dart';
import 'package:africa_beuty/feature/home/views/page/home_screen.dart';
import 'package:africa_beuty/feature/profile/view/page/profile.dart';
import 'package:africa_beuty/feature/search/view/page/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:icons_plus/icons_plus.dart';

class BottomNavigationPage extends StatefulWidget {
  final int? initialIndex;

  const BottomNavigationPage({super.key, this.initialIndex});

  @override
  State<BottomNavigationPage> createState() => _BottomNavigationPageState();
}

class _BottomNavigationPageState extends State<BottomNavigationPage> {
  String profileImage = '';
  String _name = '';

  late int _index;
  Key _bookingKey = UniqueKey();
  DateTime? _lastBackPressedAt;

  @override
  void initState() {
    super.initState();
    _index =
        (widget.initialIndex != null &&
            widget.initialIndex! >= 0 &&
            widget.initialIndex! < 4)
        ? widget.initialIndex!
        : 0;
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    final user = await LocalStorageService.getuserData();
    if (!mounted) return;

    setState(() {
      profileImage = user?.profilePicture ?? '';
      _name = user?.username ?? '';
    });
  }

  void _onTappedItem(int index) {
    // Any time the user lands on the booking tab (switching in OR re-tapping
    // it), give the BookingPage a fresh key so its state resets and the
    // list re-fetches. IndexedStack keeps siblings alive, so changing the
    // key here only rebuilds the booking subtree.
    if (index == 2) {
      setState(() {
        _index = index;
        _bookingKey = UniqueKey();
      });
      return;
    }
    setState(() {
      _index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        if (_index != 0) {
          setState(() {
            _index = 0;
          });
          _lastBackPressedAt = null;
          return;
        }

        final now = DateTime.now();
        final shouldExit =
            _lastBackPressedAt != null &&
            now.difference(_lastBackPressedAt!) < const Duration(seconds: 2);

        if (shouldExit) {
          SystemNavigator.pop();
          return;
        }

        _lastBackPressedAt = now;
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(
              content: Text('Press back again to exit'),
              duration: Duration(seconds: 2),
            ),
          );
      },
      child: Scaffold(
        body: IndexedStack(
          index: _index,
          children: [
            const HomeScreen(),
            const SearchPage(),
            BookingPage(key: _bookingKey),
            const ProfilePage(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _index,
          onTap: _onTappedItem,
          items: [
            BottomNavigationBarItem(
              activeIcon: Icon(FontAwesome.house_solid),
              icon: Icon(FontAwesome.house_solid),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              activeIcon: Icon(Bootstrap.search_heart),
              icon: Icon(Bootstrap.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              activeIcon: Icon(Bootstrap.calendar_event_fill),
              icon: Icon(Bootstrap.calendar),
              label: 'Booking',
            ),
            BottomNavigationBarItem(
              activeIcon: profileImage.isNotEmpty
                  ? ClipOval(
                      child: Image.network(
                        profileImage,
                        height: 32,
                        width: 32,
                        fit: BoxFit.cover,
                      ),
                    )
                  : const Icon(Icons.person),
              icon: profileImage.isNotEmpty
                  ? ClipOval(
                      child: Image.network(
                        profileImage,
                        height: 32,
                        width: 32,
                        fit: BoxFit.cover,
                      ),
                    )
                  : const Icon(Icons.person),
              label: _name.isEmpty ? 'Profile' : _name,
            ),
          ],
        ),
      ),
    );
  }
}
