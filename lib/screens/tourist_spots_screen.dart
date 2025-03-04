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
      appBar: CustomHeader(showBackButton: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pontos Turísticos - ${widget.stateName}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Capital: ${widget.capital}',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),
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
                  child: ListView.builder(
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
                          child: Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              title: Text(spot.name),
                              subtitle: Text(spot.type),
                              trailing: const Icon(Icons.arrow_forward_ios),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  FadePageRoute(
                                    child: DetailsScreen(
                                      spot: {
                                        'name': spot.name,
                                        'location':
                                            '${spot.latitude}, ${spot.longitude}',
                                        'description':
                                            spot.tags['description'] ??
                                            'Sem descrição disponível.',
                                        'image': 'assets/placeholder.png',
                                      },
                                    ),
                                  ),
                                );
                              },
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
