import 'package:flutter/material.dart';
import '../helpers/location_helper.dart';
import '../screens/map_screen.dart';

class HospitalLocation extends StatelessWidget {
  final double lat;
  final double lng;

  HospitalLocation(this.lat, this.lng);

  @override
  Widget build(BuildContext context) {
    final String _previewImageUrl = LocationHelper.generateLocationPreviewImage(
      latitude: lat,
      longitude: lng,
    );

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            fullscreenDialog: true,
            builder: (ctx) => MapScreen(
              latitude: lat,
              longitude: lng,
            ),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(
          left: 25,
          right: 25,
        ),
        alignment: Alignment.center,
        child: Image.network(
          _previewImageUrl,
          fit: BoxFit.cover,
          width: double.infinity,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
