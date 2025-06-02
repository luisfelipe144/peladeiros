import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/game_controller.dart';
import '../widgets/custom_drawer.dart';
import 'confronto_screen.dart';

class SorteioTimesScreen extends StatefulWidget {
  const SorteioTimesScreen({Key? key}) : super(key: key);

  @override
  _SorteioTimesScreenState createState() => _SorteioTimesScreenState();
}

class _SorteioTimesScreenState extends State<SorteioTimesScreen> {
  int jogadoresPorTime = 5;
  int maxTimes = 4;

  void sortearTimes() {
    final gameController = Provider.of<GameController>(context, listen: false);

    if (gameController.jogadorController.participantes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Adicione jogadores antes de sortear!")),
      );
      return;
    }

    gameController.timeController.iniciarTimes(
        gameController.jogadorController.participantes, jogadoresPorTime, maxTimes);
    setState(() {}); // Atualiza a UI após o sorteio
  }

  @override
  Widget build(BuildContext context) {
    final gameController = Provider.of<GameController>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Sorteio de Times', style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      drawer: CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Tipo de Sorteio:", style: TextStyle(color: Colors.white)),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  dropdownColor: Colors.grey[900],
                  value: gameController.timeController.tipoSorteio,
                  items: ["Ordem de Chegada", "Aleatório"].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: TextStyle(color: Colors.white)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    gameController.timeController.definirTipoSorteio(value!);
                    setState(() {});
                  },
                  iconEnabledColor: Color(0xFFD4AF37),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text('Jogadores por Time: $jogadoresPorTime',
                style: TextStyle(color: Colors.white)),
            Slider(
              value: jogadoresPorTime.toDouble(),
              min: 2,
              max: 10,
              divisions: 8,
              label: jogadoresPorTime.toString(),
              activeColor: Color(0xFFD4AF37),
              inactiveColor: Colors.grey[700],
              onChanged: (value) {
                setState(() {
                  jogadoresPorTime = value.toInt();
                });
              },
            ),
            Text('Número Máximo de Times: $maxTimes',
                style: TextStyle(color: Colors.white)),
            Slider(
              value: maxTimes.toDouble(),
              min: 2,
              max: 6,
              divisions: 4,
              label: maxTimes.toString(),
              activeColor: Color(0xFFD4AF37),
              inactiveColor: Colors.grey[700],
              onChanged: (value) {
                setState(() {
                  maxTimes = value.toInt();
                });
              },
            ),
            ElevatedButton(
              onPressed: sortearTimes,
              child: Text("Sortear Times"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFD4AF37),
                foregroundColor: Colors.black,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: gameController.timeController.times.length,
                itemBuilder: (context, index) {
                  final time = gameController.timeController.times[index];
                  return Card(
                    color: Colors.grey[850],
                    child: ListTile(
                      title: Text("Time ${time["numero"]}",
                          style: TextStyle(color: Colors.white)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: (time["jogadores"] as List<String>)
                            .map((j) => Text(j, style: TextStyle(color: Colors.white)))
                            .toList(),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (gameController.timeController.times.length >= 2)
              ElevatedButton(
                onPressed: () {
                  gameController.timeController.criarFilaDeConfrontos();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ConfrontoScreen()),
                  );
                },
                child: Text('Iniciar Confrontos'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFD4AF37),
                  foregroundColor: Colors.black,
                ),
              ),
          ],
        ),
      ),
    );
  }
}  
