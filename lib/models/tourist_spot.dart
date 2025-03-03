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
    required this.tags,
  });

  factory TouristSpot.fromJson(Map<String, dynamic> json) {
    return TouristSpot(
      id: json['id'].toString(),
      name: json['tags']['name'] ?? 'Sem nome',
      latitude: json['lat'].toDouble(),
      longitude: json['lon'].toDouble(),
      type: json['tags']['tourism'] ?? 'attraction',
      tags: Map<String, String>.from(json['tags']),
    );
  }
} 