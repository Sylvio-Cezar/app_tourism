import 'package:flutter/material.dart';
import '../widgets/custom_header.dart';
import '../widgets/custom_footer.dart';
import '../services/tourist_spots_service.dart';
import '../models/tourist_spot.dart';
import 'details_screen.dart';
import '../utils/page_transitions.dart';
import '../data/brazilian_cities.dart';

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
  List<TouristSpot> _filteredSpots = [];
  bool _isLoading = false;
  String _error = '';
  final _searchController = TextEditingController();
  final _cityController = TextEditingController();
  String _selectedCity = '';

  @override
  void initState() {
    super.initState();
    _selectedCity = widget.capital;
    _cityController.text = widget.capital;
    _loadTouristSpots();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  void _filterSpots(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredSpots = _spots;
      } else {
        _filteredSpots =
            _spots
                .where(
                  (spot) =>
                      spot.name.toLowerCase().contains(query.toLowerCase()),
                )
                .toList();
      }
    });
  }

  Future<void> _showCitySelectionDialog() async {
    final uf =
        BrazilianCities.states.firstWhere(
          (state) => state['name'] == widget.stateName,
          orElse: () => {'uf': ''},
        )['uf'];

    final cities = BrazilianCities.citiesByState[uf] ?? [];

    final result = await showDialog<String>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Selecionar Cidade'),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: cities.length,
                itemBuilder: (context, index) {
                  final city = cities[index];
                  return ListTile(
                    leading: const Icon(Icons.location_city),
                    title: Text(city),
                    onTap: () => Navigator.pop(context, city),
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
            ],
          ),
    );

    if (result != null && result.isNotEmpty) {
      setState(() {
        _selectedCity = result;
        _spots = [];
        _filteredSpots = [];
      });
      await _loadTouristSpots();
    }
  }

  Future<void> _loadTouristSpots() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final spots = await _touristSpotsService.getTouristSpots(_selectedCity);
      setState(() {
        _spots = spots;
        _filteredSpots = spots;
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
    // Encontrar a UF do estado atual
    final uf =
        BrazilianCities.states.firstWhere(
          (state) => state['name'] == widget.stateName,
          orElse: () => {'uf': ''},
        )['uf'];

    return Scaffold(
      appBar: CustomHeader(
        showBackButton: true,
        title: _selectedCity,
        subtitle: widget.stateName,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(BrazilianCities.stateImages[uf]!),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.2),
              BlendMode.darken,
            ),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9),
                Theme.of(context).scaffoldBackgroundColor,
              ],
              stops: const [0.0, 0.3, 0.6],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: FilledButton.icon(
                    onPressed: _showCitySelectionDialog,
                    icon: const Icon(Icons.location_city, color: Colors.white),
                    label: Text(
                      'Selecionar cidade de ${widget.stateName}',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: FilledButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      minimumSize: const Size.fromHeight(50),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.surface.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _filterSpots,
                    decoration: InputDecoration(
                      hintText: 'Pesquisar pontos turísticos...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon:
                          _searchController.text.isNotEmpty
                              ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _searchController.clear();
                                  _filterSpots('');
                                },
                              )
                              : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surface,
                    ),
                  ),
                ),

                if (_isLoading)
                  const Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (_error.isNotEmpty)
                  Expanded(
                    child: Center(
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
                    ),
                  )
                else if (_filteredSpots.isEmpty)
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Nenhum ponto turístico encontrado.',
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
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
                        itemCount: _filteredSpots.length,
                        itemBuilder: (context, index) {
                          final spot = _filteredSpots[index];
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
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
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
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  spot.translatedType,
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
        ),
      ),
      bottomNavigationBar: const CustomFooter(),
    );
  }
}
