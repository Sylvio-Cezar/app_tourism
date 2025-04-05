import 'package:flutter/material.dart';
import '../widgets/custom_header.dart';
import '../widgets/custom_footer.dart';
import '../services/tourist_spots_service.dart';
import '../models/tourist_spot.dart';
import 'details_screen.dart';
import '../utils/page_transitions.dart';

class TouristSpotsScreen extends StatefulWidget {
  final String stateName;
  final String capital;

  const TouristSpotsScreen({
    super.key,
    required this.stateName,
    required this.capital,
  });

  @override
  State<TouristSpotsScreen> createState() => _TouristSpotsScreenState();
}

class _TouristSpotsScreenState extends State<TouristSpotsScreen> {
  final _touristSpotsService = TouristSpotsService();
  List<TouristSpot> _spots = [];
  bool _isLoading = false;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _loadTouristSpots();
  }

  Future<void> _loadTouristSpots() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final spots = await _touristSpotsService.getTouristSpots(widget.capital);
      setState(() {
        _spots = spots;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Erro ao carregar pontos turísticos: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomHeader(
        showBackButton: true,
        title: widget.capital,
        subtitle: 'Capital de ${widget.stateName}',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_error.isNotEmpty)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _error,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: _loadTouristSpots,
                      child: const Text('Tentar Novamente'),
                    ),
                  ],
                ),
              )
            else if (_spots.isEmpty)
              const Center(
                child: Text(
                  'Nenhum ponto turístico encontrado nesta região.',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              )
            else
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _loadTouristSpots,
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.8,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                    itemCount: _spots.length,
                    itemBuilder: (context, index) {
                      final spot = _spots[index];
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
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary.withAlpha(25),
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          Icons.map,
                                          size: 48,
                                          color: Colors.grey,
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
              ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomFooter(),
    );
  }
}
