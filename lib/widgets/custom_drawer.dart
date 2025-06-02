import 'package:flutter/material.dart';
import '../screens/cadastro_participantes_screen.dart';
import '../screens/sorteio_times_screen.dart';
import '../screens/confronto_screen.dart';
import '../screens/historico_artilheiros_screen.dart';
import '../screens/historico_jogos_screen.dart';
import 'package:provider/provider.dart';
import '../controllers/game_controller.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gameController = Provider.of<GameController>(context);

    return Drawer(
      child: Container(
        color: Colors.grey[900],
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.black),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    width: 48,
                    height: 48,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Peladeiros',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.list, color: Color(0xFFD4AF37)),
              title: Text("Cadastro de Jogadores", style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CadastroParticipantesScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.shuffle, color: Color(0xFFD4AF37)),
              title: Text("Sorteio de Times", style: TextStyle(color: Colors.white)),
              onTap: () {
                if (gameController.timeController.times.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SorteioTimesScreen()),
                  );
                } else {
                  _mostrarAviso(context, "Nenhum time foi sorteado ainda.");
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.sports_soccer, color: Color(0xFFD4AF37)),
              title: Text("Confronto Atual", style: TextStyle(color: Colors.white)),
              onTap: () {
                if (gameController.timeController.filaDeConfrontos.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ConfrontoScreen()),
                  );
                } else {
                  _mostrarAviso(context, "Nenhum confronto foi gerado ainda.");
                }
              },
            ),
            Divider(color: Colors.white24),
            ListTile(
              leading: Icon(Icons.emoji_events, color: Color(0xFFD4AF37)),
              title: Text("Artilheiros", style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HistoricoArtilheirosScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.history, color: Color(0xFFD4AF37)),
              title: Text("Histórico de Jogos", style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HistoricoJogosScreen()),
                );
              },
            ),
            Divider(color: Colors.white24),
            ListTile(
              leading: Icon(Icons.refresh, color: Colors.red),
              title: Text("Novo Torneio", style: TextStyle(color: Colors.red)),
              onTap: () {
                _confirmarReset(context, gameController);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _mostrarAviso(BuildContext context, String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem)),
    );
  }

  void _confirmarReset(BuildContext context, GameController gameController) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[850],
          title: Text("Novo Torneio", style: TextStyle(color: Colors.white)),
          content: Text(
            "Tem certeza que deseja começar um novo torneio? Isso apagará todos os dados atuais.",
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancelar", style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {
                gameController.resetarTorneio();
                Navigator.pop(context);
                _mostrarAviso(context, "Novo torneio iniciado!");
              },
              child: Text("Confirmar", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
