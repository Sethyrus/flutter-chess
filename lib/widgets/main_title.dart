import 'package:chess_one/services/game_service.dart';
import 'package:flutter/material.dart';

class MainTitle extends StatelessWidget {
  const MainTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Chess One',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const Text(
          'Sí, otro juego de ajedrez',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () => GameService().restartGame(),
          child: const Text('Iniciar una partida'),
        ),
      ],
    );
  }
}
