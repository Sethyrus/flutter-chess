import 'package:chess_one/helpers/alert.dart';
import 'package:chess_one/services/game_service.dart';
import 'package:flutter/material.dart';

class OptionsButton extends StatelessWidget {
  const OptionsButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 32,
      icon: const Icon(
        Icons.settings,
        color: Colors.white,
      ),
      onPressed: () => Alert.showGenericDialog(
        context: context,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                child: const Text('Reiniciar partida'),
                onPressed: () {
                  Navigator.of(context).pop();

                  Alert.showConfirm(
                    context: context,
                    title: 'Confirmar',
                    content: '¿Quieres reiniciar la partida?',
                  ).then((confirmed) {
                    if (confirmed == true) {
                      GameService().restartGame();
                    }
                  });
                },
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                child: const Text('Abandonar partida'),
                onPressed: () {
                  Navigator.of(context).pop();

                  Alert.showConfirm(
                    context: context,
                    title: 'Confirmar',
                    content: '¿Quieres abandonar la partida?',
                  ).then((confirmed) {
                    if (confirmed == true) {
                      GameService().finishGame();
                    }
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
