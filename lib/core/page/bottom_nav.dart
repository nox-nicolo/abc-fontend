import 'package:africa_beuty/feature/auth/repositories/local_storage_service.dart';
import 'package:africa_beuty/feature/booking/view/pages/booking.dart';
import 'package:africa_beuty/feature/home/views/page/home_screen.dart';
import 'package:africa_beuty/feature/profile/view/page/profile.dart';
import 'package:africa_beuty/feature/search/view/page/search.dart';
// import 'package:africa_beuty/feature/trends/view/pages/trending.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class BottomNavigationPage extends StatefulWidget {
  final int? initialIndex; // optional

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

  final appScreens =  [
    HomeScreen(),
    SearchPage(),
    // TrendingPage(),
    BookingPage(),
    ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex ?? 0; // default Home
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

  void _onTapedItem(int index) {
    setState(() {
      _index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _index == 0, // Only pop when on Home

      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        if (_index != 0) {
          setState(() {
            _index = 0;
          });
        }
      },

      child: Scaffold(
        body: appScreens[_index],
        bottomNavigationBar: BottomNavigationBar(
          onTap: _onTapedItem,
          currentIndex: _index,
          items: [
            BottomNavigationBarItem(
              activeIcon: Icon(FontAwesome.house_solid),
              label: 'Home',
              icon: Icon(FontAwesome.house_solid),
            ),
            BottomNavigationBarItem(
              activeIcon: Icon(Bootstrap.search_heart),
              label: 'Search',
              icon: Icon(Bootstrap.search),
            ),
            // BottomNavigationBarItem(
            //   activeIcon: Icon(FontAwesome.fire_flame_curved_solid),
            //   label: 'Trending',
            //   icon: Icon(FontAwesome.fire_flame_curved_solid),
            // ),
            BottomNavigationBarItem(
              activeIcon: Icon(Bootstrap.calendar_event_fill),
              label: 'Booking',
              icon: Icon(Bootstrap.calendar),
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
              label: _name.isEmpty ? 'Profile' : _name,
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
            ),
          ],
        ),
      ),
    );
  }
}
