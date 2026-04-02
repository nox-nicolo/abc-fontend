import 'package:africa_beuty/feature/auth/repositories/local_storage_service.dart';
import 'package:africa_beuty/feature/booking/view/pages/booking.dart';
import 'package:africa_beuty/feature/home/views/page/home_screen.dart';
import 'package:africa_beuty/feature/profile/view/page/profile.dart';
import 'package:africa_beuty/feature/search/view/page/search.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class BottomNavigationPage extends StatefulWidget {
  final int? initialIndex;

  const BottomNavigationPage({
    super.key,
    this.initialIndex,
  });

  @override
  State<BottomNavigationPage> createState() => _BottomNavigationPageState();
}

class _BottomNavigationPageState extends State<BottomNavigationPage> {
  String profileImage = '';
  String _name = '';

  late int _index;

  final List<Widget> appScreens = const [
    HomeScreen(),
    SearchPage(),
    BookingPage(),
    ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _index = (widget.initialIndex != null &&
            widget.initialIndex! >= 0 &&
            widget.initialIndex! < appScreens.length)
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
    setState(() {
      _index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _index == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        if (_index != 0) {
          setState(() {
            _index = 0;
          });
        }
      },
      child: Scaffold(
        body: IndexedStack(
          index: _index,
          children: appScreens,
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