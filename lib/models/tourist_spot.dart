class TouristSpot {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final String type;
  final Map<String, String> tags;

  TouristSpot({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.type,
    Map<String, String>? tags,
  }) : tags = tags ?? {}; // Se tags for null, usa um mapa vazio

  factory TouristSpot.fromJson(Map<String, dynamic> json) {
    return TouristSpot(
      id: json['id'].toString(),
      name: json['tags']['name'] ?? 'Sem nome',
      latitude: json['lat'].toDouble(),
      longitude: json['lon'].toDouble(),
      type: json['tags']['tourism'] ?? 'attraction',
      tags: Map<String, String>.from(json['tags'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tags': {'name': name, ...tags},
      'lat': latitude,
      'lon': longitude,
      'type': 'node',
    };
  }

  String get translatedType {
    final translations = {
      'attraction': 'Atração Turística',
      'museum': 'Museu',
      'viewpoint': 'Mirante',
      'picnic_site': 'Área de Piquenique',
      'hostel': 'Hostel',
      'artwork': 'Obra de Arte',
      'gallery': 'Galeria',
      'zoo': 'Zoológico',
      'theme_park': 'Parque Temático',
      'water_park': 'Parque Aquático',
      'park': 'Parque',
      'aquarium': 'Aquário',
    };

    return translations[type] ?? 'Ponto Turístico';
  }
}
