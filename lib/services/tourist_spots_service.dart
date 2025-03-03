import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/tourist_spot.dart';

class TouristSpotsService {
  static const String _overpassUrl = 'https://overpass-api.de/api/interpreter';

  Future<List<TouristSpot>> getTouristSpots(String cityName) async {
    final query = '''
      [out:json];
      area["name"="$cityName"]["admin_level"="8"]->.searchArea;
      (
        node["tourism"](area.searchArea);
        way["tourism"](area.searchArea);
        relation["tourism"](area.searchArea);
      );
      out body;
      >;
      out skel qt;
    ''';

    try {
      final response = await http.post(Uri.parse(_overpassUrl), body: query);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final elements = data['elements'] as List;

        return elements
            .where(
              (element) =>
                  element['type'] == 'node' &&
                  element['tags'] != null &&
                  element['tags']['name'] != null,
            )
            .map((element) => TouristSpot.fromJson(element))
            .toList();
      } else {
        throw Exception('Falha ao carregar pontos turísticos');
      }
    } catch (e) {
      throw Exception('Erro na requisição: $e');
    }
  }
}
