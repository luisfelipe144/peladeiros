import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/game_controller.dart';

class ControleDeJogo extends StatelessWidget {
  final Map<String, dynamic> time1;
  final Map<String, dynamic> time2;

  const ControleDeJogo({Key? key, required this.time1, required this.time2}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gc = Provider.of<GameController>(context, listen: false);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: ElevatedButton(
              onPressed: () => gc.placarController.registrarResultado(0),
              child: Text("Time ${time1["numero"]} Venceu"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(0, 44),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                backgroundColor: Color(0xFFD4AF37),
                foregroundColor: Colors.black,
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ),
        Expanded(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: ElevatedButton(
              onPressed: () => _mostrarEmpate(context, gc),
              child: const Text("Empate"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(0, 44),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ),
        Expanded(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: ElevatedButton(
              onPressed: () => gc.placarController.registrarResultado(1),
              child: Text("Time ${time2["numero"]} Venceu"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(0, 44),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                backgroundColor: Color(0xFFD4AF37),
                foregroundColor: Colors.black,
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _mostrarEmpate(BuildContext context, GameController gc) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.grey[850],
        title: const Text("Desempate", style: TextStyle(color: Colors.white)),
        content: const Text("Quem deve ficar à frente na fila?", style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () {
              gc.placarController.registrarEmpate(0);
              Navigator.pop(context);
            },
            child: Text("Time ${time1["numero"]}", style: TextStyle(color: Color(0xFFD4AF37))),
          ),
          TextButton(
            onPressed: () {
              gc.placarController.registrarEmpate(1);
              Navigator.pop(context);
            },
            child: Text("Time ${time2["numero"]}", style: TextStyle(color: Color(0xFFD4AF37))),
          ),
        ],
      ),
    );
  }
}
