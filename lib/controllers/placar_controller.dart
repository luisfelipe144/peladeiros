import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'game_controller.dart';

class PlacarController extends ChangeNotifier {
  GameController? gameController;
  Map<int, int> placar = {};
  Map<String, int> golsJogadores = {};
  List<Map<String, dynamic>> historicoResultados = [];

  PlacarController() {
    carregarDados();
  }

  /// Registra um gol individual.
  void registrarGol(int numeroTime, String jogador) {
    placar[numeroTime] = (placar[numeroTime] ?? 0) + 1;
    golsJogadores[jogador] = (golsJogadores[jogador] ?? 0) + 1;
    _salvarDados();
    notifyListeners();
    gameController?.notify();
  }

  /// Registra o resultado de um confronto:
  /// - marca jogadores como já jogados,
  /// - atualiza histórico,
  /// - reseta placar,
  /// - move o perdedor real para o fim de `times`,
  /// - reconstrói `filaDeConfrontos`,
  /// - seta `confrontoFinalizado = true`,
  /// - reseta timer.
  void registrarResultado(int winnerIndex) {
    final gc = gameController!;
    final tc = gc.timeController;
    final fila = tc.filaDeConfrontos;
    if (fila.length < 2) return;

    final vencedor = fila[winnerIndex];
    final perdedor  = fila[1 - winnerIndex];

    // marca jogadores
    for (int i = 0; i < 2; i++) {
      for (final p in (fila[i]['jogadores'] as List<String>)) {
        if (!gc.jogadorController.jogadoresQueJaJogaram.contains(p)) {
          gc.jogadorController.adicionarJogadorQueJaJogou(p);
        }
      }
    }

    // histórico vitória
    historicoResultados.add({
      "vencedor": "Time ${vencedor["numero"]} - ${(vencedor["jogadores"] as List<String>).join(', ')}",
      "perdedor": "Time ${perdedor["numero"]} - ${(perdedor["jogadores"] as List<String>).join(', ')}",
      "placar":   "${placar[vencedor["numero"]] ?? 0} - ${placar[perdedor["numero"]] ?? 0}",
    });

    placar.clear();
    tc.times.removeWhere((t) => t['numero'] == perdedor['numero']);
    tc.times.add(perdedor);
    tc.criarFilaDeConfrontos();

    gc.confrontoFinalizado = true;
    gc.timerController.resetarTimer();

    _salvarDados();
    notifyListeners();
    gc.notify();
  }

  /// Registra empate e posiciona na fila conforme escolha.
  void registrarEmpate(int chosenIndex) {
    final gc = gameController!;
    final tc = gc.timeController;
    final fila = tc.filaDeConfrontos;
    if (fila.length < 2) return;

    final t1 = fila[0], t2 = fila[1];

    // histórico de empate
    historicoResultados.add({
      "empate": "Time ${t1["numero"]} e Time ${t2["numero"]}",
      "placar": "${placar[t1["numero"]] ?? 0} - ${placar[t2["numero"]] ?? 0}",
    });

    placar.clear();

    // remove ambos
    fila.removeAt(0);
    fila.removeAt(0);

    // reinsere na ordem escolhida
    if (chosenIndex == 0) {
      fila.add(t1);
      fila.add(t2);
    } else {
      fila.add(t2);
      fila.add(t1);
    }

    tc.ajustarTimesIncompletos();
    gc.timerController.resetarTimer();

    _salvarDados();
    notifyListeners();
    gc.notify();
  }

  /// Reseta todo o histórico de gols e jogos.
  void reset() {
    placar.clear();
    golsJogadores.clear();
    historicoResultados.clear();
    _salvarDados();
    notifyListeners();
  }

  Future<void> _salvarDados() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('golsJogadores', jsonEncode(golsJogadores));
    prefs.setString('historicoResultados', jsonEncode(historicoResultados));
  }

  Future<void> carregarDados() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final gs = prefs.getString('golsJogadores');
      if (gs != null && gs.isNotEmpty) {
        golsJogadores = Map<String, int>.from(jsonDecode(gs));
      }

      final hs = prefs.getString('historicoResultados');
      if (hs != null && hs.isNotEmpty) {
        historicoResultados = List<Map<String, dynamic>>.from(jsonDecode(hs));
      }

      notifyListeners();
    } catch (e) {
      debugPrint("Erro ao carregar dados de placar: $e");
    }
  }
}
