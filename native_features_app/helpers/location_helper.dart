import 'package:http/http.dart' as http;
import 'dart:convert';

const GOOGLE_API_KEY = 'None';

class LocationHelper {
  static String generateLocationPrevImage({double lat, double long}) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=&$lat,$long'
        '&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%'
        '$lat,$long&key=$GOOGLE_API_KEY';
  }

  static Future<String> getPlaceAddress(double lat, double long) async {
    final url = 'https://maps.googleapis.com/maps/api/geocode/json?'
        'latlng=$lat,$long&key=$GOOGLE_API_KEY';
    final resp = await http.get(url);
    return json.decode(resp.body)['results'][0]['formatted_address'];
  }
}
