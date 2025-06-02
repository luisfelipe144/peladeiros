import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'jogador_controller.dart';
import 'time_controller.dart';
import 'placar_controller.dart';
import 'timer_controller.dart';

class GameController extends ChangeNotifier {
  final JogadorController jogadorController = JogadorController();
  final TimeController timeController = TimeController();
  final PlacarController placarController = PlacarController();
  final TimerController timerController = TimerController();

  /// Flag para indicar que ocorreu pelo menos 1 confronto
  bool confrontoFinalizado = false;

  GameController() {
    jogadorController.gameController = this;
    timeController.gameController = this;
    placarController.gameController = this;
    timerController.gameController = this;
    _carregarDados();
  }

  /// Marca jogadores como já jogados, reordena o perdedor para o fim de `times`
  /// e reconstrói a fila.
  void finalizarConfronto() {
    confrontoFinalizado = true;
    final times = timeController.times;
    if (times.length >= 2) {
      final fila = timeController.filaDeConfrontos;
      for (int i = 0; i < 2 && i < fila.length; i++) {
        for (final j in (fila[i]['jogadores'] as List<String>)) {
          if (!jogadorController.jogadoresQueJaJogaram.contains(j)) {
            jogadorController.adicionarJogadorQueJaJogou(j);
          }
        }
      }
      final perdedor = times.removeAt(1);
      times.add(perdedor);
      timeController.criarFilaDeConfrontos();
    }
    notify();
  }

  /// Reseta todo o estado (SharedPreferences + listas em memória)
  Future<void> resetarTorneio() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    jogadorController.participantes.clear();
    jogadorController.jogadoresQueJaJogaram.clear();
    timeController.times.clear();
    timeController.filaDeConfrontos.clear();
    placarController.reset();
    timerController.reset();
    confrontoFinalizado = false;

    notify();
  }

  /// Notifica UI e salva
  void notify() {
    notifyListeners();
    _salvarDados();
  }

  Future<void> _salvarDados() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('jogadores', jsonEncode(jogadorController.participantes));
    prefs.setString('times', jsonEncode(timeController.times));
    prefs.setString('filaConfrontos', jsonEncode(timeController.filaDeConfrontos));
  }

  Future<void> _carregarDados() async {
    final prefs = await SharedPreferences.getInstance();

    final js = prefs.getString('jogadores');
    if (js != null) {
      jogadorController.participantes = List<String>.from(jsonDecode(js));
    }

    final ts = prefs.getString('times');
    if (ts != null) {
      timeController.times = List<Map<String, dynamic>>.from(jsonDecode(ts));
    }

    final fs = prefs.getString('filaConfrontos');
    if (fs != null) {
      timeController.filaDeConfrontos = List<Map<String, dynamic>>.from(jsonDecode(fs));
    }

    notifyListeners();
  }
}
