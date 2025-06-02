import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/placar_controller.dart';

class HistoricoJogosScreen extends StatelessWidget {
  const HistoricoJogosScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Histórico de Jogos', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Consumer<PlacarController>(
        builder: (context, placarCtrl, child) {
          final historico = placarCtrl.historicoResultados.reversed.toList();
          if (historico.isEmpty) {
            return const Center(
              child: Text('Nenhum jogo registrado ainda.', style: TextStyle(color: Colors.white70)),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: historico.length,
            itemBuilder: (context, index) {
              final jogo = historico[index];
              final bool isEmpate = jogo.containsKey('empate');
              final String titulo = isEmpate
                  ? jogo['empate'] as String
                  : jogo['vencedor'] as String;
              final String detalhes = isEmpate
                  ? 'Placar: ${jogo['placar']}'
                  : 'Perdedor: ${jogo['perdedor']}\nPlacar: ${jogo['placar']}';

              return Card(
                color: Colors.grey[900],
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  leading: Icon(
                    isEmpate ? Icons.handshake : Icons.emoji_events,
                    color: isEmpate ? Colors.orange : Color(0xFFD4AF37),
                    size: 28,
                  ),
                  title: Text(titulo, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(detalhes, style: const TextStyle(color: Colors.white70)),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
