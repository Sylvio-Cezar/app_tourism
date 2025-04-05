import 'package:app_tourism/widgets/custom_footer.dart';
import 'package:app_tourism/widgets/custom_header.dart';
import 'package:flutter/material.dart';
import 'favorites_screen.dart';
import 'states_screen.dart';
import '../utils/page_transitions.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomHeader(),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/logo.png',
                height: 200,
                width: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Bem-vindo ao BrasaTour!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              'Descubra os melhores pontos turísticos do Brasil.',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            FilledButton.icon(
              icon: const Icon(Icons.explore, color: Colors.white),
              label: const Text(
                'Prosseguir',
                style: TextStyle(color: Colors.white),
              ),
              onPressed:
                  () => Navigator.push(
                    context,
                    FadePageRoute(child: const StatesScreen()),
                  ),
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size.fromHeight(50),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              icon: const Icon(Icons.favorite, color: Colors.white),
              label: const Text(
                'Meus Favoritos',
                style: TextStyle(color: Colors.white),
              ),
              onPressed:
                  () => Navigator.push(
                    context,
                    FadePageRoute(child: const FavoritesScreen()),
                  ),
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size.fromHeight(50),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomFooter(),
    );
  }
}
