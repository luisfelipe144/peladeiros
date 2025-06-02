import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/game_controller.dart';
import 'widgets/controle_de_jogo.dart' show ControleDeJogo;
import 'widgets/controle_de_jogadores.dart' show ControleDeJogadores;
import 'widgets/controle_de_tempo.dart';
import 'widgets/fila_de_confrontos.dart';
import '../widgets/custom_drawer.dart';
import 'widgets/time_card.dart';

class ConfrontoScreen extends StatelessWidget {
  const ConfrontoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gameController = Provider.of<GameController>(context);

    // Se não tiver ao menos 2 times, mostra mensagem de espera
    if (gameController.timeController.filaDeConfrontos.length < 2) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text(
            'Confronto Atual',
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        drawer: CustomDrawer(),
        body: const Center(
          child: Text(
            'Aguardando times suficientes para um confronto.',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    final time1 = gameController.timeController.filaDeConfrontos[0];
    final time2 = gameController.timeController.filaDeConfrontos[1];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Confronto Atual',
          style: TextStyle(color: Colors.white),
        ),
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
      ),
      drawer: CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TimeCard(time: time1),
                const Text(
                  'VS',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFD4AF37),
                  ),
                ),
                TimeCard(time: time2),
              ],
            ),
            const SizedBox(height: 10),
            ControleDeJogo(time1: time1, time2: time2),
            const SizedBox(height: 10),
            const ControleDeTempo(),
            const SizedBox(height: 10),
            const ControleDeJogadores(),
            const SizedBox(height: 10),
            const Center(
              child: Text(
                'Próximos Times:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 5),
            const FilaDeConfrontos(),
          ],
        ),
      ),
    );
  }
}  
