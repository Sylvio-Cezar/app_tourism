import 'package:app_tourism/widgets/custom_footer.dart';
import 'package:app_tourism/widgets/custom_header.dart';
import 'package:flutter/material.dart';
import 'details_screen.dart';
import '../utils/page_transitions.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';
import '../services/image_service.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FavoritesProvider>().favorites;
    final imageService = ImageService();

    return Scaffold(
      appBar: const CustomHeader(showBackButton: true, title: 'Meus Favoritos'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (favorites.isEmpty)
              const Expanded(
                child: Center(
                  child: Text(
                    'Nenhum ponto turístico favorito.',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              )
            else
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: favorites.length,
                  itemBuilder: (context, index) {
                    final spot = favorites[index];
                    return AnimatedScale(
                      scale: 1.0,
                      duration: const Duration(milliseconds: 300),
                      child: AnimatedOpacity(
                        opacity: 1.0,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              FadePageRoute(
                                child: DetailsScreen(
                                  id: spot.id,
                                  name: spot.name,
                                  latitude: spot.latitude,
                                  longitude: spot.longitude,
                                ),
                              ),
                            );
                          },
                          child: Hero(
                            tag: spot.name,
                            child: Material(
                              elevation: 2,
                              borderRadius: BorderRadius.circular(12),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: CachedNetworkImage(
                                      imageUrl: imageService.getStaticMapUrl(
                                        spot.latitude,
                                        spot.longitude,
                                      ),
                                      height: double.infinity,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      placeholder:
                                          (context, url) => Container(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.primary.withAlpha(25),
                                            child: const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          ),
                                      errorWidget:
                                          (context, url, error) => Container(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.primary.withAlpha(25),
                                            child: const Center(
                                              child: Icon(Icons.map),
                                            ),
                                          ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            const BorderRadius.vertical(
                                              bottom: Radius.circular(12),
                                            ),
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.transparent,
                                            Colors.black.withOpacity(0.7),
                                          ],
                                        ),
                                      ),
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            spot.name,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            spot.type,
                                            style: const TextStyle(
                                              color: Colors.white70,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomFooter(),
    );
  }
}
