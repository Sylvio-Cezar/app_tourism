import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/tourist_spot.dart';

class TouristSpotsService {
  static const String _overpassUrl = 'https://overpass-api.de/api/interpreter';

  Future<List<TouristSpot>> getTouristSpots(String cityName) async {
    final encodedQuery = Uri.encodeComponent('''
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
    ''');

    try {
      final response = await http.get(
        Uri.parse('$_overpassUrl?data=$encodedQuery'),
        headers: {'Accept-Charset': 'utf-8'},
      );

      if (response.statusCode == 200) {
        final decodedResponse = utf8.decode(response.bodyBytes);
        final data = json.decode(decodedResponse);
        final elements = data['elements'] as List;

        final filteredElements =
            elements.where((element) {
              final acceptable = element['tags']?['tourism'];
              return acceptable == 'attraction' ||
                  acceptable == 'museum' ||
                  acceptable == 'viewpoint';
            }).toList();

        return filteredElements
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

  Future<Map<String, dynamic>> getTouristSpotById(String id) async {
    final query = '''
      [out:json];
      (
        node($id);
        way($id);
        relation($id);
      );
      out body;
      >;
      out skel qt;
    ''';

    try {
      final response = await http.get(
        Uri.parse('$_overpassUrl?data=${Uri.encodeComponent(query)}'),
        headers: {'Accept-Charset': 'utf-8'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        if (data['elements'].isNotEmpty) {
          return data['elements'][0];
        }
      }
      throw Exception('Ponto turístico não encontrado');
    } catch (e) {
      throw Exception('Erro ao carregar detalhes: $e');
    }
  }
}
