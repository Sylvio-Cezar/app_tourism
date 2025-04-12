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
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : _error.isNotEmpty
            ? Text(_error, textAlign: TextAlign.center)
            : CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Hero(
                      tag: widget.name,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        height: 400,
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
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: Text(
                              widget.name,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
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
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Center(
                            child: InkWell(
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
                          ),
                          if (_spotDetails != null &&
                              _hasTranslations(_spotDetails)) ...[
                            const SizedBox(height: 24),
                            Text(
                              'Nomes em outros idiomas',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ..._buildTranslations(_spotDetails),
                          ],
                          const SizedBox(height: 24),
                          Text(
                            _spotDetails?['description'] ?? '',
                            style: Theme.of(context).textTheme.bodyLarge,
                            textAlign: TextAlign.center,
                          ),
                          if (_spotDetails != null) ...[
                            const SizedBox(height: 24),

                            // Endereço
                            if (_hasAddress(_spotDetails!)) ...[
                              Text(
                                'Endereço',
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _buildAddress(_spotDetails!),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                            ],

                            // Horário de Funcionamento
                            if (_spotDetails!['opening_hours'] != null) ...[
                              Text(
                                'Horário de Funcionamento',
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _spotDetails!['opening_hours'],
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                            ],

                            // Website
                            if (_spotDetails!['website'] != null ||
                                _spotDetails!['contact:website'] != null) ...[
                              Text(
                                'Website',
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              InkWell(
                                onTap: () {
                                  final url =
                                      _spotDetails!['website'] ??
                                      _spotDetails!['contact:website'];
                                  launcher.launchUrl(
                                    Uri.parse(url),
                                    mode:
                                        launcher.LaunchMode.externalApplication,
                                  );
                                },
                                child: Text(
                                  _spotDetails!['website'] ??
                                      _spotDetails!['contact:website'] ??
                                      '',
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    decoration: TextDecoration.underline,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],

                            // Telefone
                            if (_spotDetails!['phone'] != null ||
                                _spotDetails!['contact:phone'] != null) ...[
                              Text(
                                'Telefone',
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _spotDetails!['phone'] ??
                                    _spotDetails!['contact:phone'] ??
                                    '',
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                            ],

                            // Acessibilidade
                            if (_hasAccessibilityInfo(_spotDetails!)) ...[
                              Text(
                                'Acessibilidade',
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              ..._buildAccessibilityInfo(_spotDetails!),
                              const SizedBox(height: 16),
                            ],

                            // Informações Adicionais
                            if (_hasAdditionalInfo(_spotDetails!)) ...[
                              Text(
                                'Informações Adicionais',
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              ..._buildAdditionalInfo(_spotDetails!),
                            ],
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    languageFlags[lang]!,
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(width: 12),
                  Text(value, style: const TextStyle(fontSize: 16)),
                ],
              ),
            ),
          );
        }
      }
    });

    return translations;
  }

  bool _hasAddress(Map<String, dynamic> tags) {
    return tags['addr:street'] != null ||
        tags['addr:housenumber'] != null ||
        tags['addr:postcode'] != null ||
        tags['addr:city'] != null;
  }

  String _buildAddress(Map<String, dynamic> tags) {
    final parts = <String>[];

    if (tags['addr:street'] != null) {
      parts.add(tags['addr:street']);
      if (tags['addr:housenumber'] != null) {
        parts.add(tags['addr:housenumber']);
      }
    }

    if (tags['addr:postcode'] != null) {
      parts.add(tags['addr:postcode']);
    }

    if (tags['addr:city'] != null) {
      parts.add(tags['addr:city']);
    }

    return parts.join(', ');
  }

  bool _hasAccessibilityInfo(Map<String, dynamic> tags) {
    return tags['wheelchair'] != null ||
        tags['wheelchair:description'] != null ||
        tags['tactile_paving'] != null;
  }

  List<Widget> _buildAccessibilityInfo(Map<String, dynamic> tags) {
    final info = <Widget>[];

    if (tags['wheelchair'] != null) {
      info.add(
        Text(
          'Acesso para cadeirantes: ${_translateWheelchair(tags["wheelchair"])}',
          textAlign: TextAlign.center,
        ),
      );
    }

    if (tags['wheelchair:description'] != null) {
      info.add(const SizedBox(height: 4));
      info.add(
        Text(
          'Detalhes: ${tags["wheelchair:description"]}',
          textAlign: TextAlign.center,
        ),
      );
    }

    if (tags['tactile_paving'] != null) {
      info.add(const SizedBox(height: 4));
      info.add(
        Text(
          'Piso tátil: ${tags["tactile_paving"] == "yes" ? "Sim" : "Não"}',
          textAlign: TextAlign.center,
        ),
      );
    }

    return info;
  }

  String _translateWheelchair(String value) {
    switch (value) {
      case 'yes':
        return 'Acessível';
      case 'limited':
        return 'Parcialmente acessível';
      case 'no':
        return 'Não acessível';
      default:
        return 'Não informado';
    }
  }

  bool _hasAdditionalInfo(Map<String, dynamic> tags) {
    return tags['fee'] != null ||
        tags['payment:*'] != null ||
        tags['internet_access'] != null ||
        tags['cuisine'] != null;
  }

  List<Widget> _buildAdditionalInfo(Map<String, dynamic> tags) {
    final info = <Widget>[];

    if (tags['fee'] != null) {
      info.add(
        Text(
          'Entrada: ${tags["fee"] == "yes" ? "Paga" : "Gratuita"}',
          textAlign: TextAlign.center,
        ),
      );
    }

    if (tags['internet_access'] != null) {
      info.add(const SizedBox(height: 4));
      info.add(
        Text(
          'Wi-Fi: ${_translateInternetAccess(tags["internet_access"])}',
          textAlign: TextAlign.center,
        ),
      );
    }

    if (tags['cuisine'] != null) {
      info.add(const SizedBox(height: 4));
      info.add(
        Text(
          'Culinária: ${tags["cuisine"]}',
          textAlign: TextAlign.center,
        ),
      );
    }

    return info;
  }

  String _translateInternetAccess(String value) {
    switch (value) {
      case 'yes':
        return 'Disponível';
      case 'no':
        return 'Não disponível';
      case 'wlan':
        return 'Wi-Fi disponível';
      default:
        return value;
    }
  }
}
