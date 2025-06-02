import 'package:flutter/material.dart';
import 'game_controller.dart';

class TimeController extends ChangeNotifier {
  GameController? gameController;

  /// Lista principal de todos os times.
  List<Map<String, dynamic>> times = [];

  /// Fila de confrontos: sempre deriva de `times`.
  List<Map<String, dynamic>> filaDeConfrontos = [];

  /// Quantos jogadores por time.
  int jogadoresPorTime = 4;

  /// Máximo de times permitidos.
  int maxTimes = 999;

  /// Tipo de sorteio: "Ordem de Chegada" ou "Aleatório".
  String tipoSorteio = "Ordem de Chegada";

  void definirTipoSorteio(String tipo) {
    tipoSorteio = tipo;
    _notify();
  }

  void iniciarTimes(List<String> jogadores, int porTime, int max) {
    if (jogadores.isEmpty) return;
    jogadoresPorTime = porTime;
    maxTimes = max;
    times.clear();

    // Ordenação
    if (tipoSorteio == "Aleatório") {
      jogadores.shuffle();
    } else {
      // Ordem de chegada em blocos alternados
      final p = <String>[];
      final s = <String>[];
      final d = <String>[];
      for (int i = 0; i < jogadores.length; i++) {
        if (i.isEven) {
          if (p.length < porTime)
            p.add(jogadores[i]);
          else
            d.add(jogadores[i]);
        } else {
          if (s.length < porTime)
            s.add(jogadores[i]);
          else
            d.add(jogadores[i]);
        }
      }
      jogadores = [...p, ...s, ...d];
    }

    // Cria a quantidade de times necessária
    int total = (jogadores.length / porTime).ceil();
    total = total > max ? max : total;

    for (int i = 0; i < total; i++) {
      times.add({
        "numero": i + 1,
        "jogadores": <String>[],
      });
    }

    // Distribui jogadores pelos times
    int idx = 0;
    for (final t in times) {
      for (int j = 0; j < porTime && idx < jogadores.length; j++) {
        t["jogadores"].add(jogadores[idx++]);
      }
    }

    // Gera a fila e já ajusta incompletos
    criarFilaDeConfrontos();
    _notify();
  }

  /// Recria a fila a partir de `times` e já ajusta quaisquer times incompletos.
  void criarFilaDeConfrontos() {
    filaDeConfrontos = List.from(times);
    ajustarTimesIncompletos();
    _notify();
  }

  /// Para cada time (exceto o último), se estiver abaixo de `jogadoresPorTime`,
  /// puxa jogadores do próximo time, até que só o último time fique incompleto.
  void ajustarTimesIncompletos() {
    // Remove qualquer time vazio
    filaDeConfrontos.removeWhere((t) => (t["jogadores"] as List).isEmpty);

    for (int i = 0; i < filaDeConfrontos.length - 1; i++) {
      final faltam = jogadoresPorTime -
          (filaDeConfrontos[i]["jogadores"] as List).length;

      for (int j = 0; j < faltam; j++) {
        final proximo = filaDeConfrontos[i + 1]["jogadores"] as List<String>;
        if (proximo.isNotEmpty) {
          // Move o primeiro do time de baixo para completar este time
          filaDeConfrontos[i]["jogadores"]
              .add(proximo.removeAt(0));
        }
      }

      // Se o próximo time ficou vazio, remove-o
      if ((filaDeConfrontos[i + 1]["jogadores"] as List).isEmpty) {
        filaDeConfrontos.removeAt(i + 1);
        i--; // reavalia essa posição
      }
    }
  }

  void _notify() {
    notifyListeners();
    gameController?.notify();
  }
}
