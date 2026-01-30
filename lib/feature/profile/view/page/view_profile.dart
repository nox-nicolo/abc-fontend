// import 'package:africa_beuty/feature/profile/view/widget/followunfollow.dart';
// import 'package:africa_beuty/feature/profile/view/widget/location.dart';
// import 'package:africa_beuty/feature/profile/view/widget/setting.dart';
// import 'package:africa_beuty/core/widgets/spacing.dart';
// import 'package:africa_beuty/feature/profile/view/widget/three_dots.dart';
// import 'package:flutter/material.dart';
// import 'package:icons_plus/icons_plus.dart';

// class ViewProfilePage extends StatefulWidget {
//   const ViewProfilePage( 
//     {
//       super.key,
//     }
//   ); 

//   @override 
//   State<ViewProfilePage> createState() => _ViewProfilePageState();
// }

// class _ViewProfilePageState extends State<ViewProfilePage> with SingleTickerProviderStateMixin {
//   final bool isCustomer = true;

//   late ScrollController _scrollController;
//   late TabController _tabController;
//   static const kExpandedHeight = kToolbarHeight + 270;

//   @override
//   void initState() {
//     super.initState();

//     _scrollController = ScrollController()
//       ..addListener(() {
//         setState(() {
          
//         });
//       }
//     );

//     _tabController = TabController(length: 2, vsync: this);
//   }

//   @override 
//   void dispose() {
//     _tabController.dispose();
//     _scrollController.dispose();

//     super.dispose();
//   }

//   bool get _isSliverAppBarExpanded {
//     return _scrollController.hasClients &&
//         _scrollController.offset > kExpandedHeight - kToolbarHeight;
//   }
  
  
//   @override 
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;

//     return Scaffold(
//       body: isCustomer ? 

//       CustomScrollView(
//         controller: _scrollController, 
//         physics: BouncingScrollPhysics(), 
//         slivers: [
//           SliverAppBar(
//             floating: false,
//             pinned: true,
//             // snap: true,
//             collapsedHeight: size.height * .12,
//             expandedHeight: size.height * .45, 
//             shape: const RoundedRectangleBorder(
//               borderRadius: BorderRadius.only(
//                 bottomLeft: Radius.circular(20), 
//                 bottomRight: Radius.circular(20)
//               )
//             ),
//             flexibleSpace: FlexibleSpaceBar(
//               titlePadding: EdgeInsets.all(10),
//               title: _isSliverAppBarExpanded ? Row(
//                 children: [
//                   CircleAvatar(
//                     radius: 35,
//                   ),
//                   SizedBox(width: 10,), 
//                   Text(
//                     'Username', 
//                     style: Theme.of(context).textTheme.titleLarge,
//                   ),
//                   const Spacer(), 
//                   TextButton(onPressed: () {}, child: Text('Booking Now'))
//                 ],
//               ) 
              
//               : null,

//               background: Container(
//                 padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
//                 decoration: BoxDecoration(
//                   gradient: RadialGradient(
//                     center: Alignment(0.5, 0.5),
//                     radius: 1.0,
//                     colors: [Colors.brown.shade400, Colors.blueGrey.shade500],
//                   ),
//                   borderRadius: BorderRadius.only(
//                     bottomLeft: Radius.circular(20), 
//                     bottomRight: Radius.circular(20)
//                   )
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Row(
//                       children: [
//                         CircleAvatar(
//                           radius: 50,
//                         ),
//                         const SizedBox(width: 20,),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             SizedBox(
//                               width: size.width * .65,
//                               child: Text(
//                                 maxLines: 1, 
//                                 overflow: TextOverflow.ellipsis,
//                                 'Name of the salon to behere',
//                                 style: Theme.of(context).textTheme.headlineSmall,
//                               ),
//                             ), 
//                             const SizedBox(height: 10,),
//                             SizedBox(
//                               width: size.width * .6,
//                               child: Text(
//                                 maxLines: 1, 
//                                 overflow: TextOverflow.ellipsis, 
//                                 'Username names names names names names names', 
//                                 style: Theme.of(context).textTheme.bodyLarge,
//                               ),
//                             )
//                           ],
//                         )
//                       ],
//                     ), 
//                     const SizedBox(height: 10,), 
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             const SizedBox(width: 10,), 
//                             const SettingAccount(isCustomer: true,), 
//                             const SizedBox(width: 10,), 
//                             const ThreeDotsOptions(isCustomer: true,),
//                           ],
//                         ),
                        
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ), 
//           ),
//           SliverAppBar(), 
//           SliverFillRemaining(
//             child: Text('Customer shared post by salon here'),
//           )
//         ],
//       )

//       : 
      
//       CustomScrollView(
//         controller: _scrollController, 
//         physics: BouncingScrollPhysics(), 
//         slivers: [
//             // Saloon information, 
//           SliverAppBar(
//             floating: false,
//             pinned: true,
//             // snap: true,
//             collapsedHeight: size.height * .12,
//             expandedHeight: size.height * .45, 
//             shape: const RoundedRectangleBorder(
//               borderRadius: BorderRadius.only(
//                 bottomLeft: Radius.circular(20), 
//                 bottomRight: Radius.circular(20)
//               )
//             ),
//             flexibleSpace: FlexibleSpaceBar(
//               titlePadding: EdgeInsets.all(10),
//               title: _isSliverAppBarExpanded ? Row(
//                 children: [
//                   CircleAvatar(
//                     radius: 35,
//                   ),
//                   SizedBox(width: 10,), 
//                   Text('Username'),
//                   const Spacer(), 
//                   TextButton(onPressed: () {}, child: Text('Booking Now'))
//                 ],
//               ) 
              
//               : null,

//               background: Container(
//                 padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
//                 decoration: BoxDecoration(
//                   gradient: RadialGradient(
//                     center: Alignment(0.5, 0.5),
//                     radius: 1.0,
//                     colors: [Colors.brown.shade400, Colors.blueGrey.shade500],
//                   ),
//                   borderRadius: BorderRadius.only(
//                     bottomLeft: Radius.circular(20), 
//                     bottomRight: Radius.circular(20)
//                   )
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Row(
//                       children: [
//                         CircleAvatar(
//                           radius: 50,
//                         ),
//                         const SizedBox(width: 20,),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             SizedBox(
//                               width: size.width * .65,
//                               child: Text(
//                                 maxLines: 1, 
//                                 overflow: TextOverflow.ellipsis,
//                                 'Name of the salon to behere',
//                                 style: Theme.of(context).textTheme.headlineSmall,
//                               ),
//                             ), 
//                             const SizedBox(height: 10,),
//                             Row(
//                               children: [
//                                 Positioned(
//                                   top: -0, 
//                                   left: 0,
//                                   child: Icon(
//                                   OctIcons.verified, 
//                                     size: 14, 
//                                     color: Colors.blue.shade500,
//                                   ), 
//                                 ),
//                                 const SizedBox(width: 5,), 
//                                 SizedBox(
//                                   width: size.width * .6,
//                                   child: Text(
//                                     maxLines: 1, 
//                                     overflow: TextOverflow.ellipsis, 
//                                     'Username names names names names names names', 
//                                     style: Theme.of(context).textTheme.bodyLarge,
//                                   ),
//                                 ),
//                               ],
//                             )
//                           ],
//                         )
//                       ],
//                     ), 
//                     const SizedBox(height: 10,), 
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Row(
//                           children: [
//                             const Followunfollow(), 
//                             const SizedBox(width: 10,), 
//                             const SettingAccount(isCustomer: false,), 
//                             const SizedBox(width: 10,), 
//                             const ThreeDotsOptions(isCustomer: false,),
//                           ],
//                         ),
//                         Icon(
//                           Bootstrap.lock_fill,
//                           size: 16,
//                         )
//                       ],
//                     ),
//                     const SizedBox(height: 10,),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         SizedBox(
//                           width: size.width * .70,
//                           child: Center(
//                             child: Text(
//                               'Slogan or Tagline of the Saloon', 
//                               style: Theme.of(context).textTheme.headlineLarge?.copyWith(
//                                 fontSize: 16,
//                               ),
//                             ),
//                           ),
//                         ), 
//                         SizedBox(
//                           width: size.width * .20,
//                           child: Text(
//                             'Working Hours', 
//                             style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                               fontSize: 14
//                             )
//                           ),
//                         )
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ), 
//           ),

//           // Saloon Motor
//           SliverSpaceHeader(title: 'Bio'),
//           SliverToBoxAdapter(
//             child: Column(
//               children: [
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), 
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(20),
//                       topRight: Radius.circular(20) 
//                     )
//                   ),
//                   child: Text(
//                     maxLines: 3, 
//                     overflow: TextOverflow.ellipsis, 
//                     'This is bio of this saloon and alot of words, to say but let\'s keep simple This is bio of this saloon and alot of words, to say but let\'s keep simple', 
//                     style: Theme.of(context).textTheme.labelMedium,
//                   ),
//                 ),
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), 
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Row(
//                         children: [
//                           Text(
//                             'Rated 4.5', 
//                             style: Theme.of(context).textTheme.bodyLarge,
//                           ), 
//                           SizedBox(width: 5,), 
//                           Icon(
//                             OctIcons.star, 
//                             size: 16,
//                             color: Colors.blue.shade500,
//                           ),
//                         ],
//                       ),
//                       Spacer(),
//                       Icon(
//                         Bootstrap.chat_heart_fill,
//                         size: 32, 
//                         color: Colors.blue.shade500,
//                       )
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // Location Pin Point
//           SliverSpaceHeader(title: 'Location',), 
//           SliverToBoxAdapter(
//             child: const ProfileLocation(), 
//           ),

//           // Servered Offer
//           SliverSpaceHeader(title: 'Service Offered',), 
//           SliverList(
//             delegate: SliverChildBuilderDelegate(
//               (context, index) {
//                 return SizedBox(
//                   height: 50, 
//                   child: ListView.builder(
//                     scrollDirection: Axis.horizontal,
//                     itemCount: 5,
//                     itemBuilder: (context, index) {
//                       return Card(
//                         child: Container(
//                           width: 150,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10), 
                            
//                             gradient: LinearGradient(
//                               colors: [
//                                 Colors.blue.shade100,
//                                 Colors.amber.shade100,  
//                                 Colors.green.shade100, 
//                               ]
//                             ),
//                           ),
//                           child: Center(child: Text('Item $index')),
//                         ),
//                       );
//                     },
//                   ),
//                 );
//               },
//               childCount: 1, // Only 1 item for the horizontal list
//             ),
//           ),

//           // Booking 
//           SliverPadding(
//             padding: EdgeInsets.symmetric(vertical: 20,),
//           ),
//           SliverToBoxAdapter(
//             child: Container(
//               margin: EdgeInsets.symmetric(horizontal: 20),
//               child: TextButton(
//                 onPressed: () {}, 
//                 style: TextButton.styleFrom(
//                   padding: EdgeInsets.symmetric(vertical: 20), 
//                   elevation: 10, 
//                 ),
//                 child: Text(
//                   'Book Now', 
//                   style: Theme.of(context).textTheme.displaySmall,
//                 ),
//               ),
//             ),
//           ),

//           // Special Offer
//           SliverSpaceHeader(title: 'Special offers',), 
//           SliverList(
//             delegate: SliverChildBuilderDelegate(
//               (context, index) {
//                 return SizedBox(
//                   width: size.width * .90,
//                   height: 110,
//                   child: Column(
//                     children: [
//                       Stack(
//                         children: [
//                           Container(
//                             margin: EdgeInsets.symmetric(horizontal: 20),
//                             padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                             child: Row(
//                               children: [
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   children: [
//                                     Text(
//                                       'Offer Name, ', 
//                                       style: Theme.of(context).textTheme.titleLarge,
//                                       textAlign: TextAlign.center,
//                                     ),
//                                     Text(
//                                       'Offer description, to Be putted here!',
//                                       style: Theme.of(context).textTheme.bodyLarge, 
//                                     )
//                                   ],
//                                 ), 
//                                 Spacer(), 
//                                 TextButton(
//                                   onPressed: () {},
//                                   child: Text('Book Now'),
//                                 ), 
                                
//                               ],
//                             ),
//                           ),
//                           Positioned(
//                             top: -10,
//                             right: size.width * .21,
//                             child: Text(
//                               '20%-', 
//                               style: Theme.of(context).textTheme.displaySmall?.copyWith(
//                                 fontWeight: FontWeight.w900, 
//                               ),
//                             )
//                           )
//                         ],
//                       ),
//                       SizedBox(height: 10,),
//                     ],
//                   ),
//                 );
//               }, 
//               childCount: 3, 
//             ) 
//           ), 

//           // Media Content
//           SliverSpaceHeader(title: 'Post',), 
//           SliverPersistentHeader(
//             delegate: MySliverPersistentHeaderDelegate(
//               tabController: _tabController,
//               maxHeight: 50,
//               minHeight: 50,
//             ),
//             pinned: true,
//           ),
//           SliverFillRemaining( // Important: Use SliverFillRemaining
//             child: TabBarView(
//               controller: _tabController,
//               children: <Widget>[
//                 ListView.builder(
//                   itemCount: 20,
//                   itemBuilder: (context, index) =>
//                       ListTile(title: Text('Tab 1 Item $index')),
//                 ),
//                 ListView.builder(
//                   itemCount: 20,
//                   itemBuilder: (context, index) =>
//                       ListTile(title: Text('Tab 2 Item $index')),
//                 ),
//               ],
//             ),
//           ),

//           // Team Member
//           SliverSpaceHeader(title: 'Team Member',), 
//           SliverToBoxAdapter(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                  Container(
//                   padding: EdgeInsets.symmetric(horizontal: 20),
//                   height: 20,
//                   child: Text(
//                     'Owner', 
//                     style: Theme.of(context).textTheme.titleSmall?.copyWith(
//                       fontSize: 14, 
//                       fontWeight: FontWeight.w400
//                     ), 
//                     textAlign: TextAlign.start,
//                   ),
//                 ),
//                 SingleChildScrollView(
//                   child: Container(
//                     padding: EdgeInsets.symmetric(horizontal: 10),
//                     height: 200,
//                     child: ListView.builder(
//                       scrollDirection: Axis.horizontal,
//                       itemCount: 3,
//                       itemBuilder: (context, index) {
//                         return Card(
//                           child: Container(
//                             padding: EdgeInsets.symmetric(horizontal: 20),
//                             child: Row(
//                               children: [
//                                 Row(
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   children: [
//                                     CircleAvatar(
//                                       foregroundImage: AssetImage(
//                                         'assets/images/dp.jpg', 
//                                       ),
//                                       radius: 40,
//                                     ),
//                                     SizedBox(width: 10,), 
//                                     Column(
//                                       mainAxisAlignment: MainAxisAlignment.center,
//                                       crossAxisAlignment: CrossAxisAlignment.end,
//                                       children: [
//                                         Text(
//                                           'Nicolaus Boniface Joseph', 
//                                           style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//                                             fontSize: 16, 
//                                           )
//                                         ), 
//                                         Text(
//                                           'Profession', 
//                                           style: Theme.of(context).textTheme.labelLarge,
//                                         ),
//                                       ],
//                                     )
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ), 

//                 // Staff
//                 Container( 
//                   padding: EdgeInsets.symmetric(horizontal: 20),
//                   height: 20,
//                   child: Text(
//                     'Staffs', 
//                     style: Theme.of(context).textTheme.titleSmall?.copyWith(
//                       fontSize: 14, 
//                       fontWeight: FontWeight.w500
//                     ), 
//                     textAlign: TextAlign.start,
//                   ),
//                 ),
//                 SingleChildScrollView(
//                   child: Container(
//                     padding: EdgeInsets.symmetric(horizontal: 10),
//                     height: 200,
//                     child:  ListView.builder(
//                       scrollDirection: Axis.horizontal,
//                       itemCount: 5,
//                       itemBuilder: (context, index) {
//                         return Card(
//                           child: Container(
//                             padding: EdgeInsets.symmetric(horizontal: 20),
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 CircleAvatar(
//                                   foregroundImage: AssetImage(
//                                     'assets/images/dp.jpg', 
//                                   ),
//                                   radius: 45,
//                                 ), 
//                                 SizedBox(height: 10,),
//                                 Text(
//                                   'Nicolaus Boniface Joseph', 
//                                   style: Theme.of(context).textTheme.labelLarge
//                                 ), 
//                                 SizedBox(height: 10,),
//                                 Text(
//                                   'professional', 
//                                   style: Theme.of(context).textTheme.labelSmall
//                                 )
//                               ],
//                             ),
//                           ),
//                         );
//                       }
//                     ),
//                   ),
//                 ), 
//               ],

//             ),
//           ),

          
//           // Online Presence
//           SliverSpaceHeader(title: 'Social Accounts',), 
//           SliverToBoxAdapter(
//             child: Column(
//               children: [
//                 // Social Media
//                 SingleChildScrollView(
//                   child: Container(
//                     padding: EdgeInsets.symmetric(horizontal: 20),
//                     height: 100,
//                     child: ListView.builder(
//                       scrollDirection: Axis.horizontal,
//                       itemCount: 5,
//                       itemBuilder: (context, index) {
//                         return  Container(
//                           padding: EdgeInsets.symmetric(horizontal: 20),
//                           child: Column(
//                             children: [
//                               Brand(
//                                 Brands.instagram, 
//                                 size: 55,
//                               ),
//                               SizedBox(height: 5,), 
//                               Text(
//                                 'InsertChart',
//                                 style: Theme.of(context).textTheme.titleSmall, 
//                               ),
//                             ],
//                           ),
//                         );
//                       }
//                     ),
//                   ),
//                 ),

//                 // Website
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 20),
//                   child: Row(
//                     children: [
//                       Icon(
//                         FontAwesome.weibo_brand, 
//                         color: Colors.blue.shade400, 
//                         size: 32,
//                       ), 
//                       SizedBox(width: 10,), 
//                       Text(
//                         'www.salon.com', 
//                         style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                           fontSize: 14,
//                         ), 
//                       ),
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           ),

//           // Customer Review
//           SliverSpaceHeader(title: 'Customer Reviews',), 
//           SliverList(
//             delegate: SliverChildBuilderDelegate(
//               (context, index) {
//                 return Container(
//                   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                   height: 200,
//                   child: ListView.builder(
//                     scrollDirection: Axis.horizontal,
//                     itemCount: 5,
//                     itemBuilder: (context, index) {
//                       return Card(
//                         child: Container(
//                           padding: EdgeInsets.symmetric(horizontal: 10),
//                           width: 300,
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 crossAxisAlignment: CrossAxisAlignment.end,
//                                 children: [
//                                   CircleAvatar(
//                                     foregroundImage: AssetImage(
//                                       'assets/images/dp.jpg', 
//                                     ),
//                                     radius: 30,
//                                   ), 
//                                   SizedBox(width: 10), 
//                                   Column(
//                                     children: [
//                                       Text(
//                                         '_el_ocin_',
//                                         style: Theme.of(context).textTheme.titleSmall
//                                       ),
//                                       SizedBox(height: 10,)
//                                     ],
//                                   ), 
//                                 ],
//                               ), 
//                               SizedBox(height: 10,),
//                               Container(
//                                 padding: EdgeInsets.symmetric(horizontal: 10),
//                                 width: 300,
//                                 child: Text(
//                                   maxLines: 4,
//                                   overflow: TextOverflow.ellipsis, 
//                                   'Yead its amaizing to get dress by you I preceate the treia of sahtioa ajea aldan ajkeor apreciate i think this is ot Yead its amaizing to get dress by you I preceate the treia of sahtioa ajea aldan ajkeor apreciate i think this is ', 
//                                 ),
//                               ),
//                               Container(
//                                 padding: EdgeInsets.symmetric(horizontal: 10),
//                                 height: 20,
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     }
//                   )
//                 );
//               }, 
//               childCount: 1
//             )
//           ), 
//         ],

//       ),
//     );
//   }
// }

// // Abstract of SliverPersistentHeader

// class MySliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
//   final TabController tabController;
//   final double maxHeight;
//   final double minHeight;

//   MySliverPersistentHeaderDelegate({
//     required this.tabController,
//     required this.maxHeight,
//     required this.minHeight,
//   });

//   @override
//   Widget build(
//       BuildContext context, double shrinkOffset, bool overlapsContent) {
//     return Column(
//       children: [
//         Expanded(child: Container()), // Pushes TabBar to the bottom
//         TabBar(
//           controller: tabController,
//           tabs: const [
//             Tab(text: 'Media'),
//             Tab(text: 'Category'),
//           ],
//           // indicatorColor: Colors.blue,
//           // labelColor: Colors.black,
//           // unselectedLabelColor: Colors.grey,
//         ),
//       ],
//     );
//   }

//   @override
//   double get maxExtent => maxHeight;

//   @override
//   double get minExtent => minHeight;

//   @override
//   bool shouldRebuild(covariant MySliverPersistentHeaderDelegate oldDelegate) {
//     return tabController != oldDelegate.tabController ||
//         maxHeight != oldDelegate.maxHeight ||
//         minHeight != oldDelegate.minHeight;
//   }
// }

import 'package:africa_beuty/feature/profile/view/widget/view_customer_profile.dart';
import 'package:africa_beuty/feature/profile/view/widget/view_salon_profile.dart';
import 'package:flutter/material.dart';

class ViewProfilePage extends StatelessWidget {
  const ViewProfilePage({
    super.key,
    required this.isServiceProfile,
    required this.userId
  });

  final bool isServiceProfile; // change to false to preview customer
  final String userId;

  @override
  Widget build(BuildContext context) {
    return isServiceProfile
        ? ViewServiceProfilePage(salonId: userId)
        : const ViewCustomerProfilePage();
  }
}
