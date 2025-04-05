import 'package:http/http.dart' as http;
import 'dart:math';

class ImageService {
  String getStaticMapUrl(double latitude, double longitude) {
    return 'https://tile.openstreetmap.org/14'
        '/${_lon2tile(longitude, 14)}'
        '/${_lat2tile(latitude, 14)}.png';
  }

  int _lon2tile(double lon, int z) {
    return ((lon + 180.0) / 360.0 * (1 << z)).floor();
  }

  int _lat2tile(double lat, int z) {
    final latRad = lat * pi / 180.0;
    return ((1.0 - log(tan(latRad) + 1.0 / cos(latRad)) / pi) / 2.0 * (1 << z))
        .floor();
  }

  Future<bool> checkImageAvailability(String url) async {
    try {
      final response = await http.head(Uri.parse(url));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
