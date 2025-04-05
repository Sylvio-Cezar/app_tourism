import 'package:flutter/material.dart';
import '../widgets/custom_header.dart';
import '../widgets/custom_footer.dart';
import 'tourist_spots_screen.dart';
import '../utils/page_transitions.dart';

class StatesScreen extends StatelessWidget {
  const StatesScreen({super.key});

  final List<Map<String, String>> brazilianStates = const [
    {'name': 'Acre', 'capital': 'Rio Branco'},
    {'name': 'Alagoas', 'capital': 'Maceió'},
    {'name': 'Amapá', 'capital': 'Macapá'},
    {'name': 'Amazonas', 'capital': 'Manaus'},
    {'name': 'Bahia', 'capital': 'Salvador'},
    {'name': 'Ceará', 'capital': 'Fortaleza'},
    {'name': 'Distrito Federal', 'capital': 'Brasília'},
    {'name': 'Espírito Santo', 'capital': 'Vitória'},
    {'name': 'Goiás', 'capital': 'Goiânia'},
    {'name': 'Maranhão', 'capital': 'São Luís'},
    {'name': 'Mato Grosso', 'capital': 'Cuiabá'},
    {'name': 'Mato Grosso do Sul', 'capital': 'Campo Grande'},
    {'name': 'Minas Gerais', 'capital': 'Belo Horizonte'},
    {'name': 'Pará', 'capital': 'Belém'},
    {'name': 'Paraíba', 'capital': 'João Pessoa'},
    {'name': 'Paraná', 'capital': 'Curitiba'},
    {'name': 'Pernambuco', 'capital': 'Recife'},
    {'name': 'Piauí', 'capital': 'Teresina'},
    {'name': 'Rio de Janeiro', 'capital': 'Rio de Janeiro'},
    {'name': 'Rio Grande do Norte', 'capital': 'Natal'},
    {'name': 'Rio Grande do Sul', 'capital': 'Porto Alegre'},
    {'name': 'Rondônia', 'capital': 'Porto Velho'},
    {'name': 'Roraima', 'capital': 'Boa Vista'},
    {'name': 'Santa Catarina', 'capital': 'Florianópolis'},
    {'name': 'São Paulo', 'capital': 'São Paulo'},
    {'name': 'Sergipe', 'capital': 'Aracaju'},
    {'name': 'Tocantins', 'capital': 'Palmas'},
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: brazilianStates.length,
                itemBuilder: (context, index) {
                  final state = brazilianStates[index];
                  return AnimatedBuilder(
                    animation: Tween<double>(begin: 0, end: 1).animate(
                      CurvedAnimation(
                        parent: ModalRoute.of(context)!.animation!,
                        curve: Interval(
                          index * 0.1,
                          1.0,
                          curve: Curves.easeOut,
                        ),
                      ),
                    ),
                    builder:
                        (context, child) => SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(1, 0),
                            end: Offset.zero,
                          ).animate(
                            CurvedAnimation(
                              parent: ModalRoute.of(context)!.animation!,
                              curve: Interval(
                                index * 0.1,
                                1.0,
                                curve: Curves.easeOut,
                              ),
                            ),
                          ),
                          child: Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              title: Text(state['name']!),
                              subtitle: Text('Capital: ${state['capital']}'),
                              trailing: const Icon(Icons.arrow_forward_ios),
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
