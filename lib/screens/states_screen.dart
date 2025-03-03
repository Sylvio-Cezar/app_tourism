import 'package:flutter/material.dart';
import '../widgets/custom_header.dart';
import '../widgets/custom_footer.dart';
import 'tourist_spots_screen.dart';

class StatesScreen extends StatelessWidget {
  final VoidCallback onThemeToggle;
  final bool isDarkMode;

  const StatesScreen({
    super.key,
    required this.onThemeToggle,
    required this.isDarkMode,
  });

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
      appBar: CustomHeader(
        onThemeToggle: onThemeToggle,
        isDarkMode: isDarkMode,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Estados do Brasil',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Selecione um estado para ver seus pontos turísticos',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: brazilianStates.length,
                itemBuilder: (context, index) {
                  final state = brazilianStates[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      title: Text(state['name']!),
                      subtitle: Text('Capital: ${state['capital']}'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => TouristSpotsScreen(
                                  stateName: state['name']!,
                                  capital: state['capital']!,
                                  onThemeToggle: onThemeToggle,
                                  isDarkMode: isDarkMode,
                                ),
                          ),
                        );
                      },
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
