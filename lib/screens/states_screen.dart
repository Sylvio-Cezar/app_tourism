import 'package:flutter/material.dart';
import '../widgets/custom_header.dart';
import '../widgets/custom_footer.dart';
import 'tourist_spots_screen.dart';
import '../utils/page_transitions.dart';

class StatesScreen extends StatelessWidget {
  const StatesScreen({super.key});

  final List<Map<String, String>> brazilianStates = const [
    {'name': 'Acre', 'capital': 'Rio Branco', 'uf': 'AC'},
    {'name': 'Alagoas', 'capital': 'Maceió', 'uf': 'AL'},
    {'name': 'Amapá', 'capital': 'Macapá', 'uf': 'AP'},
    {'name': 'Amazonas', 'capital': 'Manaus', 'uf': 'AM'},
    {'name': 'Bahia', 'capital': 'Salvador', 'uf': 'BA'},
    {'name': 'Ceará', 'capital': 'Fortaleza', 'uf': 'CE'},
    {'name': 'Distrito Federal', 'capital': 'Brasília', 'uf': 'DF'},
    {'name': 'Espírito Santo', 'capital': 'Vitória', 'uf': 'ES'},
    {'name': 'Goiás', 'capital': 'Goiânia', 'uf': 'GO'},
    {'name': 'Maranhão', 'capital': 'São Luís', 'uf': 'MA'},
    {'name': 'Mato Grosso', 'capital': 'Cuiabá', 'uf': 'MT'},
    {'name': 'Mato Grosso do Sul', 'capital': 'Campo Grande', 'uf': 'MS'},
    {'name': 'Minas Gerais', 'capital': 'Belo Horizonte', 'uf': 'MG'},
    {'name': 'Pará', 'capital': 'Belém', 'uf': 'PA'},
    {'name': 'Paraíba', 'capital': 'João Pessoa', 'uf': 'PB'},
    {'name': 'Paraná', 'capital': 'Curitiba', 'uf': 'PR'},
    {'name': 'Pernambuco', 'capital': 'Recife', 'uf': 'PE'},
    {'name': 'Piauí', 'capital': 'Teresina', 'uf': 'PI'},
    {'name': 'Rio de Janeiro', 'capital': 'Rio de Janeiro', 'uf': 'RJ'},
    {'name': 'Rio Grande do Norte', 'capital': 'Natal', 'uf': 'RN'},
    {'name': 'Rio Grande do Sul', 'capital': 'Porto Alegre', 'uf': 'RS'},
    {'name': 'Rondônia', 'capital': 'Porto Velho', 'uf': 'RO'},
    {'name': 'Roraima', 'capital': 'Boa Vista', 'uf': 'RR'},
    {'name': 'Santa Catarina', 'capital': 'Florianópolis', 'uf': 'SC'},
    {'name': 'São Paulo', 'capital': 'São Paulo', 'uf': 'SP'},
    {'name': 'Sergipe', 'capital': 'Aracaju', 'uf': 'SE'},
    {'name': 'Tocantins', 'capital': 'Palmas', 'uf': 'TO'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomHeader(
        showBackButton: true,
        title: 'Estados do Brasil',
        subtitle: 'Selecione um estado',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.8,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: brazilianStates.length,
          itemBuilder: (context, index) {
            final state = brazilianStates[index];
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
                        child: TouristSpotsScreen(
                          stateName: state['name']!,
                          capital: state['capital']!,
                        ),
                      ),
                    );
                  },
                  child: Material(
                    elevation: 2,
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Theme.of(
                                  context,
                                ).colorScheme.primary.withOpacity(0.1),
                                Theme.of(
                                  context,
                                ).colorScheme.primary.withOpacity(0.2),
                              ],
                            ),
                          ),
                          child: Center(
                            child: Text(
                              state['uf']!,
                              style: TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary.withOpacity(0.5),
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
                              borderRadius: const BorderRadius.vertical(
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  state['name']!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Capital: ${state["capital"]!}',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
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
            );
          },
        ),
      ),
      bottomNavigationBar: const CustomFooter(),
    );
  }
}
