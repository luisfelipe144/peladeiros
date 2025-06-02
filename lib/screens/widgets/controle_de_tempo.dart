import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/game_controller.dart';

class ControleDeTempo extends StatelessWidget {
  const ControleDeTempo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gc = Provider.of<GameController>(context);
    final tc = gc.timerController;

    return Column(
      children: [
        Text(
          "Tempo Restante: ${_formatarTempo(tc.tempoRestante)}",
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildBotao("Tempo", Colors.grey[700]!, () => _definirTempoManualmente(context, gc)),
            const SizedBox(width: 8),
            _buildBotao(
              tc.isTimerRunning ? "Pausar" : "Iniciar",
              tc.isTimerRunning ? Colors.grey[700]! : Color(0xFFD4AF37),
              () {
                if (tc.isTimerRunning) {
                  tc.pararTimer();
                } else {
                  tc.iniciarTimer();
                }
              },
            ),
            const SizedBox(width: 8),
            _buildBotao("Resetar", Colors.red, () => tc.resetarTimer()),
          ],
        ),
      ],
    );
  }

  Widget _buildBotao(String titulo, Color cor, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: cor, foregroundColor: cor == Colors.red ? Colors.white : Colors.black),
      onPressed: onPressed,
      child: Text(titulo),
    );
  }

  String _formatarTempo(int segundos) {
    final minutos = segundos ~/ 60;
    final seg = segundos % 60;
    return "$minutos:${seg.toString().padLeft(2, '0')}";
  }

  void _definirTempoManualmente(BuildContext context, GameController gc) {
    showDialog(
      context: context,
      builder: (ctx) {
        int currentMin = gc.timerController.tempoRestante ~/ 60;
        return AlertDialog(
          backgroundColor: Colors.grey[850],
          title: const Text("Tempo de Partida", style: TextStyle(color: Colors.white)),
          content: DropdownButton<int>(
            dropdownColor: Colors.grey[900],
            value: currentMin,
            items: List.generate(45, (i) => i + 1).map((min) {
              return DropdownMenuItem<int>(
                value: min,
                child: Text("$min minutos", style: TextStyle(color: Colors.white)),
              );
            }).toList(),
            onChanged: (min) {
              if (min != null) {
                gc.timerController.definirTempoDefault(min * 60);
              }
              Navigator.pop(ctx);
            },
            iconEnabledColor: Color(0xFFD4AF37),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Fechar", style: TextStyle(color: Colors.white))),
          ],
        );
      },
    );
  }
}  
