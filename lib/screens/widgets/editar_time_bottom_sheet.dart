import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/game_controller.dart';

class EditarTimeBottomSheet extends StatefulWidget {
  final Map<String, dynamic> time;

  const EditarTimeBottomSheet({Key? key, required this.time}) : super(key: key);

  @override
  _EditarTimeBottomSheetState createState() => _EditarTimeBottomSheetState();
}

class _EditarTimeBottomSheetState extends State<EditarTimeBottomSheet> {
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = widget.time["jogadores"]
        .map<TextEditingController>((jogador) => TextEditingController(text: jogador))
        .toList();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameController = Provider.of<GameController>(context, listen: false);

    return Container(
      color: Colors.grey[900],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Editar Time ${widget.time["numero"]}",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 10),
            ...List.generate(
              _controllers.length,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: TextField(
                  controller: _controllers[index],
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: "Jogador ${index + 1}",
                    labelStyle: TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.grey[800],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    List<String> novosJogadores = _controllers.map((c) => c.text).toList();
                    widget.time["jogadores"] = novosJogadores;
                    gameController.notify();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFD4AF37),
                    foregroundColor: Colors.black,
                  ),
                  child: const Text("Salvar"),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancelar", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
