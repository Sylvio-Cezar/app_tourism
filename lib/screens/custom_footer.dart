import 'package:flutter/material.dart';

class CustomFooter extends StatelessWidget {
  const CustomFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      color: Theme.of(context).colorScheme.primary,
      padding: const EdgeInsets.all(16),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Contato: contato@brasatour.com',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
              Text(
                '© 2024 BrasaTour',
                style: TextStyle(color: Colors.white70, fontSize: 10),
              ),
            ],
          ),
          Row(
            children: [
              Icon(Icons.thumb_up, color: Colors.white, size: 20), // Facebook
              SizedBox(width: 12),
              Icon(Icons.camera_alt, color: Colors.white, size: 20), // Instagram
              SizedBox(width: 12),
              Icon(Icons.email, color: Colors.white, size: 20),
            ],
          )
        ],
      ),
    );
  }
}