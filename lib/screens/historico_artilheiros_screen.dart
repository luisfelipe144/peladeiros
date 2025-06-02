import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/placar_controller.dart';

class HistoricoArtilheirosScreen extends StatelessWidget {
  const HistoricoArtilheirosScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Artilheiros",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Consumer<PlacarController>(
        builder: (context, placarController, child) {
          final artilheiros = placarController.golsJogadores.entries.toList()
            ..sort((a, b) => b.value.compareTo(a.value));

          if (artilheiros.isEmpty) {
            return const Center(
              child: Text(
                "Nenhum gol registrado ainda.",
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          return ListView.builder(
            itemCount: artilheiros.length,
            itemBuilder: (context, index) {
              final jogador = artilheiros[index].key;
              final gols = artilheiros[index].value;
              return Card(
                color: Colors.grey[850],
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey[800],
                    child: Text(
                      "${index + 1}",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(
                    jogador,
                    style: const TextStyle(color: Colors.white),
                  ),
                  trailing: Text(
                    "$gols gols",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
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
