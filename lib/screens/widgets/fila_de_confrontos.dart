import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/game_controller.dart';
import '../widgets/editar_time_bottom_sheet.dart';

class FilaDeConfrontos extends StatelessWidget {
  const FilaDeConfrontos({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gameController = Provider.of<GameController>(context);

    return Expanded(
      child: ListView.builder(
        itemCount: gameController.timeController.filaDeConfrontos.length - 2,
        itemBuilder: (context, index) {
          final proximoTime = gameController.timeController.filaDeConfrontos[index + 2];

          return GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => EditarTimeBottomSheet(time: proximoTime),
                backgroundColor: Colors.grey[900],
              );
            },
            child: Card(
              color: Colors.grey[850],
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
              child: ListTile(
                title: Text(
                  "Time ${proximoTime["numero"]}",
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  proximoTime["jogadores"].join(", "),
                  style: const TextStyle(color: Colors.white70),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
