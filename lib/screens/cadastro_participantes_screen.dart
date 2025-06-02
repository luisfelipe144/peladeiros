import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/sorteio_times_screen.dart';
import '../controllers/game_controller.dart';
import '../widgets/custom_drawer.dart';

class CadastroParticipantesScreen extends StatefulWidget {
  @override
  _CadastroParticipantesScreenState createState() =>
      _CadastroParticipantesScreenState();
}

class _CadastroParticipantesScreenState
    extends State<CadastroParticipantesScreen> {
  TextEditingController nomeController = TextEditingController();

  void adicionarParticipante() {
    final gameController = Provider.of<GameController>(context, listen: false);
    String nome = nomeController.text.trim();

    if (!_validarNomeJogador(nome)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nome inválido! Digite um nome válido.")),
      );
      return;
    }

    if (gameController.jogadorController.participantes.contains(nome)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Este jogador já foi adicionado!")),
      );
      return;
    }

    gameController.jogadorController.adicionarParticipante(nome);
    nomeController.clear();
    setState(() {}); // Atualiza a tela após adicionar
  }

  bool _validarNomeJogador(String nome) {
    if (nome.isEmpty || nome.trim().isEmpty) return false;
    if (!RegExp(r"^[a-zA-Z0-9À-ÿ\s]+$").hasMatch(nome)) return false;
    return true;
  }

  void removerParticipante(String jogador) {
    final gameController = Provider.of<GameController>(context, listen: false);
    gameController.jogadorController.removerParticipante(jogador);
    setState(() {}); // Atualiza a tela após remover
  }

  @override
  Widget build(BuildContext context) {
    final gameController = Provider.of<GameController>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Lista de Jogadores', style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      drawer: CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nomeController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Nome do Jogador',
                labelStyle: TextStyle(color: Colors.white70),
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person, color: Color(0xFFD4AF37)),
                filled: true,
                fillColor: Colors.grey[800],
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: adicionarParticipante,
              icon: Icon(Icons.add, color: Colors.black),
              label: Text('Adicionar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFD4AF37),
                foregroundColor: Colors.black,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: gameController.jogadorController.participantes.isEmpty
                  ? Center(
                      child: Text(
                        "Nenhum jogador na lista",
                        style: TextStyle(fontSize: 16, color: Colors.white70),
                      ),
                    )
                  : ListView.builder(
                      itemCount:
                          gameController.jogadorController.participantes.length,
                      itemBuilder: (context, index) {
                        return Card(
                          color: Colors.grey[850],
                          elevation: 3,
                          child: ListTile(
                            title: Text(
                              gameController
                                  .jogadorController.participantes[index],
                              style: TextStyle(color: Colors.white),
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => removerParticipante(
                                  gameController
                                      .jogadorController.participantes[index]),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            SizedBox(height: 16),
            Visibility(
              visible: gameController.jogadorController.participantes.length >=
                  2,
              child: ElevatedButton.icon(
                onPressed: () {
                  gameController.timeController.iniciarTimes(
                      gameController.jogadorController.participantes, 5, 4);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SorteioTimesScreen()),
                  );
                },
                icon: Icon(Icons.shuffle, color: Colors.black),
                label: Text('Sortear Times'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFD4AF37),
                  foregroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
