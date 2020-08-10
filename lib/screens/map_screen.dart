import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatelessWidget {
  static const routeName = '/map-screen';

  final double latitude;
  final double longitude;

  MapScreen({
    this.latitude,
    this.longitude,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Map'),
      ),
      body: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(
              latitude,
              longitude,
            ),
            zoom: 16,
          ),
          markers: {
            Marker(
              markerId: MarkerId('m1'),
              position: LatLng(
                latitude,
                longitude,
              ),
            ),
          }),
    );
  }
}
