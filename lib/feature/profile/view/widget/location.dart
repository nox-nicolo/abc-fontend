import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ProfileLocation extends StatefulWidget {
  const ProfileLocation(
    {
      super.key
    }
  );

  @override
  State<ProfileLocation> createState() => _ProfileLocationState();
}

class _ProfileLocationState extends State<ProfileLocation> {

  static const LatLng _pGooglePlex = LatLng(-3.3869, 36.6830);
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.pink.shade300,
        ),
        child: Center(
          child: GoogleMap(
            padding: EdgeInsets.all(1),
            zoomControlsEnabled: false,
            scrollGesturesEnabled: false,
            initialCameraPosition: CameraPosition(
              target: _pGooglePlex, 
              zoom: 16,
            ),
            markers: {
              Marker(
                markerId: MarkerId('Yep'), 
                icon: BitmapDescriptor.defaultMarker, 
                position: _pGooglePlex
              ),
            },
          ),
        ),
      ),
    );
  }
} 