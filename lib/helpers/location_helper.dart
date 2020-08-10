const GOOGLE_API_KEY = 'AIzaSyCv5f8Wa3Og3HxOJ2HBDyDAhCSLkb1kuDk';

class LocationHelper {
  static String generateLocationPreviewImage({
    double latitude,
    double longitude,
  }) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$latitude,$longitude&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7C$latitude,$longitude&key=$GOOGLE_API_KEY';
  }
}
