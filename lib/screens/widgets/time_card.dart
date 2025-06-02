import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/placar_controller.dart';

class TimeCard extends StatelessWidget {
  final Map<String, dynamic> time;

  const TimeCard({Key? key, required this.time}) : super(key: key);

  void _mostrarDialogoRegistrarGol(BuildContext context) {
    final placarCtrl = Provider.of<PlacarController>(context, listen: false);
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.grey[850],
          title: const Text(
            'Selecione o jogador que fez o gol',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: time['jogadores'].map<Widget>((jogador) {
              return ListTile(
                title: Text(jogador, style: const TextStyle(color: Colors.white)),
                onTap: () {
                  placarCtrl.registrarGol(time['numero'], jogador);
                  Navigator.pop(ctx);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final placarCtrl = Provider.of<PlacarController>(context);
    final golsTime = placarCtrl.placar[time['numero']] ?? 0;

    return Container(
      width: MediaQuery.of(context).size.width * 0.42,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Time ${time['numero']}',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFFD4AF37),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Gols: $golsTime',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const Divider(color: Colors.white24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: time['jogadores'].map<Widget>((jogador) {
              final golsJogador = placarCtrl.golsJogadores[jogador] ?? 0;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(jogador, style: const TextStyle(fontSize: 16, color: Colors.white)),
                    Text('⚽ $golsJogador', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: 70,
            child: ElevatedButton(
              onPressed: () => _mostrarDialogoRegistrarGol(context),
              child: const Text('GOL'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD4AF37),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 8),
                textStyle: const TextStyle(fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
