import 'dart:async';
import 'package:flutter/material.dart';
import 'game_controller.dart';

class TimerController extends ChangeNotifier {
  GameController? gameController;

  // armazena o tempo padrão (em segundos)
  int _defaultTempo = 600;

  // tempo restante da partida
  int tempoRestante = 600;

  Timer? _timer;
  bool isTimerRunning = false;

  TimerController() {
    // garante que o tempoInicial e tempoRestante estejam iguais ao default
    tempoRestante = _defaultTempo;
  }

  /// Define um novo tempo padrão (em segundos) e reseta o timer imediatamente
  void definirTempoDefault(int segundos) {
    _defaultTempo = segundos;
    tempoRestante = segundos;
    _notify();
  }

  /// Inicia a contagem regressiva
  void iniciarTimer() {
    if (isTimerRunning) return;

    isTimerRunning = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (tempoRestante > 0) {
        tempoRestante--;
        _notify();
      } else {
        pararTimer();
      }
    });
  }

  /// Para o timer sem alterar o tempo atual
  void pararTimer() {
    _timer?.cancel();
    isTimerRunning = false;
    _notify();
  }

  /// Reseta o timer para o tempo padrão (_defaultTempo)
  void resetarTimer() {
    pararTimer();
    tempoRestante = _defaultTempo;
    _notify();
  }

  /// Reseta completamente (idem a resetarTimer)
  void reset() {
    pararTimer();
    tempoRestante = _defaultTempo;
    _notify();
  }

  void _notify() {
    notifyListeners();
    gameController?.notify();
  }
}
