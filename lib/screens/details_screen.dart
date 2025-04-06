import 'package:app_tourism/widgets/custom_footer.dart';
import 'package:app_tourism/widgets/custom_header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../services/image_service.dart';
import '../services/tourist_spots_service.dart';
import '../models/tourist_spot.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

class DetailsScreen extends StatefulWidget {
  final String id;
  final String name;
  final double latitude;
  final double longitude;

  const DetailsScreen({
    super.key,
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final _touristSpotsService = TouristSpotsService();
  final _imageService = ImageService();
  Map<String, dynamic>? _spotDetails;
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _loadSpotDetails();
  }

  Future<void> _loadSpotDetails() async {
    try {
      final details = await _touristSpotsService.getTouristSpotById(widget.id);
      setState(() {
        _spotDetails = details['tags'];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);

    return Scaffold(
      appBar: CustomHeader(showBackButton: true, title: widget.name),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _error.isNotEmpty
              ? Center(child: Text(_error))
              : CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 400,
                    flexibleSpace: Hero(
                      tag: widget.name,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        child: Center(
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: _imageService.getStaticMapUrl(
                                      widget.latitude,
                                      widget.longitude,
                                    ),
                                    fit: BoxFit.cover,
                                    alignment: Alignment.center,
                                    placeholder:
                                        (context, url) => const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                    errorWidget:
                                        (context, url, error) => const Center(
                                          child: Icon(Icons.map),
                                        ),
                                  ),
                                  const Center(
                                    child: Icon(
                                      Icons.location_on,
                                      color: Colors.red,
                                      size: 36,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black26,
                                          blurRadius: 4,
                                          offset: Offset(2, 2),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    pinned: true,
                    automaticallyImplyLeading: false,
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            widget.name,
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.location_on,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${widget.latitude}, ${widget.longitude}',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          InkWell(
                            onTap: () {
                              final url =
                                  'https://www.google.com/maps/search/?api=1&query=${widget.latitude},${widget.longitude}';
                              launcher.launchUrl(
                                Uri.parse(url),
                                mode: launcher.LaunchMode.externalApplication,
                              );
                            },
                            child: Text(
                              'Ver no Maps',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                                decoration: TextDecoration.underline,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          if (_spotDetails != null &&
                              _hasTranslations(_spotDetails)) ...[
                            const SizedBox(height: 24),
                            Text(
                              'Nomes em outros idiomas',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 16),
                            ..._buildTranslations(_spotDetails),
                          ],
                          const SizedBox(height: 24),
                          Text(
                            _spotDetails?['description'] ?? '',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      bottomNavigationBar: const CustomFooter(),
      floatingActionButton: FutureBuilder<bool>(
        future: favoritesProvider.isFavorite(widget.id),
        builder: (context, snapshot) {
          return FloatingActionButton(
            onPressed: () {
              final spot = TouristSpot(
                id: widget.id,
                name: widget.name,
                latitude: widget.latitude,
                longitude: widget.longitude,
                type: _spotDetails?['tourism'] ?? 'attraction',
                tags: Map<String, String>.from(_spotDetails ?? {}),
              );
              favoritesProvider.toggleFavorite(widget.id, spot: spot);
            },
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Icon(
              snapshot.data == true ? Icons.favorite : Icons.favorite_border,
              color: Colors.white,
            ),
          );
        },
      ),
    );
  }

  bool _hasTranslations(Map<String, dynamic>? tags) {
    return tags?.keys.any((key) => key.startsWith('name:')) ?? false;
  }

  List<Widget> _buildTranslations(Map<String, dynamic>? tags) {
    if (tags == null) return [];

    final Map<String, String> languageFlags = {
      'pt': '🇵🇹',
      'en': '🇬🇧',
      'es': '🇪🇸',
      'de': '🇩🇪',
      'fr': '🇫🇷',
      'it': '🇮🇹',
      'nl': '🇳🇱',
      'pl': '🇵🇱',
      'ru': '🇷🇺',
      'ja': '🇯🇵',
      'zh': '🇨🇳',
    };

    final List<Widget> translations = [];

    tags.forEach((key, value) {
      if (key.startsWith('name:')) {
        final lang = key.split(':')[1];
        if (languageFlags.containsKey(lang)) {
          translations.add(
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Text(
                    languageFlags[lang]!,
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(value, style: const TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            ),
          );
        }
      }
    });

    return translations;
  }
}
