import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:torneio_facil/controllers/game_controller.dart';

class ControleDeJogadores extends StatelessWidget {
  const ControleDeJogadores({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gc = Provider.of<GameController>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _botao("Adicionar Jogador", Color(0xFFD4AF37), () => _abrirAdd(context, gc)),
        const SizedBox(width: 8),
        _botao("Remover Jogador", Colors.red, () => _abrirRemover(context, gc)),
      ],
    );
  }

  Widget _botao(String texto, Color cor, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: cor,
        foregroundColor: cor == Colors.red ? Colors.white : Colors.black,
      ),
      child: Text(texto),
    );
  }

  void _abrirAdd(BuildContext ctx, GameController gc) {
    showModalBottomSheet(
      backgroundColor: Colors.grey[900],
      context: ctx,
      isScrollControlled: true,
      builder: (bc) {
        String nome = '';
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(bc).viewInsets.bottom + 16,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Adicionar Jogador",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                TextField(
                  decoration: const InputDecoration(
                    labelText: "Nome do Jogador",
                    labelStyle: TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Color(0xFF212121),
                  ),
                  style: const TextStyle(color: Colors.white),
                  autofocus: true,
                  onChanged: (v) => nome = v.trim(),
                  onSubmitted: (_) => _adicionar(bc, gc, nome),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(onPressed: () => Navigator.pop(bc), child: const Text("Cancelar", style: TextStyle(color: Colors.white))),
                    TextButton(onPressed: () => _adicionar(bc, gc, nome), child: const Text("Adicionar", style: TextStyle(color: Color(0xFFD4AF37)))),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _adicionar(BuildContext bc, GameController gc, String nome) {
    final jc = gc.jogadorController;
    final tc = gc.timeController;

    if (nome.isEmpty) {
      ScaffoldMessenger.of(bc).showSnackBar(const SnackBar(content: Text("Nome inválido.")));
      return;
    }
    if (jc.participantes.contains(nome)) {
      ScaffoldMessenger.of(bc).showSnackBar(const SnackBar(content: Text("Este jogador já foi adicionado!")));
      return;
    }
    bool todosCheios = tc.times.every((t) => (t['jogadores'] as List).length >= tc.jogadoresPorTime);
    if (gc.confrontoFinalizado && todosCheios && tc.times.length >= tc.maxTimes) {
      ScaffoldMessenger.of(bc).showSnackBar(const SnackBar(content: Text("Limite de times atingido.")));
      return;
    }

    jc.adicionarParticipante(nome);

    if (!gc.confrontoFinalizado) {
      if (tc.times.isNotEmpty && (tc.times.last['jogadores'] as List).length < tc.jogadoresPorTime) {
        (tc.times.last['jogadores'] as List).add(nome);
      } else {
        tc.times.add({'numero': tc.times.length + 1, 'jogadores': [nome]});
      }
    } else {
      final fila = tc.filaDeConfrontos;
      bool inseriu = false;
      for (int i = 2; i < fila.length; i++) {
        final teamMap = fila[i];
        final numero = teamMap['numero'] as int;
        final jogadoresAtuais = List<String>.from(
          tc.times.firstWhere((t) => t['numero'] == numero)['jogadores'] as List<String>
        );
        final naoJogaram = <String>[];
        final jaJogaram = <String>[];
        for (var p in jogadoresAtuais) {
          if (jc.jogadoresQueJaJogaram.contains(p)) jaJogaram.add(p);
          else naoJogaram.add(p);
        }
        if (jaJogaram.isNotEmpty) {
          var novaLista = [...naoJogaram, nome, ...jaJogaram];
          String overflow = '';
          if (novaLista.length > tc.jogadoresPorTime) overflow = novaLista.removeLast();
          teamMap['jogadores'] = List<String>.from(novaLista);
          tc.times.firstWhere((t) => t['numero'] == numero)['jogadores'] = List<String>.from(novaLista);
          if (overflow.isNotEmpty) {
            bool realocado = false;
            for (int j = i + 1; j < fila.length; j++) {
              final proxNum = fila[j]['numero'] as int;
              final proxList = tc.times.firstWhere((t) => t['numero'] == proxNum)['jogadores'] as List<String>;
              if (proxList.length < tc.jogadoresPorTime) {
                proxList.insert(0, overflow);
                realocado = true;
                break;
              }
            }
            if (!realocado && tc.times.length < tc.maxTimes) {
              tc.times.add({'numero': tc.times.length + 1, 'jogadores': [overflow]});
            }
          }
          inseriu = true;
          break;
        }
      }
      if (!inseriu) {
        bool realocado = false;
        for (int i = 2; i < fila.length; i++) {
          final num = fila[i]['numero'] as int;
          final list = tc.times.firstWhere((t) => t['numero'] == num)['jogadores'] as List<String>;
          if (list.length < tc.jogadoresPorTime) {
            list.add(nome);
            realocado = true;
            break;
          }
        }
        if (!realocado && tc.times.length < tc.maxTimes) {
          tc.times.add({'numero': tc.times.length + 1, 'jogadores': [nome]});
        }
      }
    }

    tc.criarFilaDeConfrontos();
    tc.ajustarTimesIncompletos();
    Navigator.pop(bc);
    tc.notifyListeners();
  }

  void _abrirRemover(BuildContext ctx, GameController gc) {
    showModalBottomSheet(
      backgroundColor: Colors.grey[900],
      context: ctx,
      isScrollControlled: true,
      builder: (bc) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(bc).viewInsets.bottom + 16,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Remover Jogador',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 10),
                ...gc.jogadorController.participantes.map((jogador) {
                  return ListTile(
                    title: Text(jogador, style: const TextStyle(color: Colors.white)),
                    onTap: () => _remover(bc, gc, jogador),
                  );
                }).toList(),
                const SizedBox(height: 10),
                TextButton(onPressed: () => Navigator.pop(bc), child: const Text('Cancelar', style: TextStyle(color: Colors.white))),
              ],
            ),
          ),
        );
      },
    );
  }

  void _remover(BuildContext bc, GameController gc, String nome) {
    final jc = gc.jogadorController;
    final tc = gc.timeController;

    jc.removerParticipante(nome);
    for (var time in tc.times) {
      (time['jogadores'] as List<String>).remove(nome);
    }
    tc.times.removeWhere((time) => (time['jogadores'] as List<String>).isEmpty);
    tc.criarFilaDeConfrontos();
    tc.ajustarTimesIncompletos();
    Navigator.pop(bc);
    tc.notifyListeners();
  }
}
